#include <curl/curl.h>
#include <curl/easy.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "client.h"

void
init_response(Response* s)
{
    s->len = 0;
    s->ptr = malloc(s->len + 1);
    if (s->ptr == NULL) {
        fprintf(stderr, "malloc() failed\n");
        exit(EXIT_FAILURE);
    }
    s->ptr[0] = '\0';
}

size_t
writefunc(void* ptr, size_t size, size_t nmemb, Response* s)
{
    size_t new_len = s->len + size * nmemb;
    s->ptr = realloc(s->ptr, new_len + 1);
    if (s->ptr == NULL) {
        fprintf(stderr, "realloc() failed\n");
        exit(EXIT_FAILURE);
    }
    memcpy(s->ptr + s->len, ptr, size * nmemb);
    s->ptr[new_len] = '\0';
    s->len = new_len;

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
            r.error_code = res;
            r.error_msg = "curl_easy_perform() failed";
            curl_easy_cleanup(curl);
            return r;
        }
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
        curl_easy_cleanup(curl);
    } else {
        r.error_msg = "curl_easy_init() failed";
        r.error_code = 1;
        return r;
    }
    r.response_status_code = response_code;
    return r;
}