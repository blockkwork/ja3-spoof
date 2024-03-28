#ifndef client
#define client

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

struct {
  char *url;
  char *ciphers;
  char *user_agent;
  char *cookies;
  char *headers[1000];
} typedef Config;

struct {
  char *ptr;
  char *error_msg;
  unsigned char error_code;
  size_t len;
  long response_status_code;
} typedef Response;

Response domainRequest(Config config);

#endif
