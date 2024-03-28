#include <curl/curl.h>
#include <curl/easy.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "client.h"

void
init_response(Response* r)
{
    r->error_msg = "";
    r->len = 0;
    r->ptr = malloc(r->len + 1);
    if (r->ptr == NULL) {
        fprintf(stderr, "malloc() failed\n");
        exit(EXIT_FAILURE);
    }
    r->ptr[0] = '\0';
}

size_t
writefunc(void* ptr, size_t size, size_t nmemb, Response* r)
{
    size_t new_len = r->len + size * nmemb;
    r->ptr = realloc(r->ptr, new_len + 1);
    if (r->ptr == NULL) {
        fprintf(stderr, "realloc() failed\n");
        exit(EXIT_FAILURE);
    }
    memcpy(r->ptr + r->len, ptr, new_len - r->len);
    r->ptr[new_len] = '\0';
    r->len = new_len;

    return size * nmemb;
}

Response
domainRequest(Config config)
{
    CURL* curl;
    CURLcode res;
    long response_code;
    Response r;

    init_response(&r);

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_COOKIE, config.cookies);
        curl_easy_setopt(curl, CURLOPT_USERAGENT, config.user_agent);
        curl_easy_setopt(curl, CURLOPT_SSL_CIPHER_LIST, config.ciphers);
        curl_easy_setopt(curl, CURLOPT_URL, config.url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writefunc);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &r);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            r.error_msg = curl_easy_strerror(res);
            curl_easy_cleanup(curl);
            return r;
        }
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
        r.response_status_code = response_code;
        curl_easy_cleanup(curl);
    } else {
        r.error_msg = "curl_easy_init() failed";
        return r;
    }
    return r;
}