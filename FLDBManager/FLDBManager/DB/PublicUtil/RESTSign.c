#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <openssl/sha.h>

#include "RESTSign.h"

#define DEFAULT_SALT "LOVE_GDMallCHINA"

int REST_sign(char* url, int url_len, char* data, int data_len, unsigned char** hash_out, int* hash_len)
{
    
    char* buf;
    unsigned long buf_len;
    char salt[] = DEFAULT_SALT;
    unsigned char* result;
    SHA256_CTX sha256;
    
    // basic validation
    if ((NULL == url)||(url_len<=0)
        || ( NULL!=data&&data_len<=0 )
        || ( NULL==data&&data_len!=0 )
        ||(NULL == hash_out)||(NULL == hash_len)) {
        return -1;
    }
    
    // construct the covered text
    buf_len = url_len+strlen(salt)+data_len+1;
    buf =(char*)  malloc(buf_len*sizeof(char));
    
    memcpy(buf, url, url_len);
    memcpy(buf+url_len, salt, strlen(salt));
    if (NULL != data)
    {
        memcpy(buf+url_len+strlen(salt), data, data_len);
    }
    
    // construct the hash result buffer
    result = (unsigned char*)  malloc(SHA256_DIGEST_LENGTH*sizeof(unsigned char));
    
    //hash
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, buf, buf_len-1);
    SHA256_Final(result, &sha256);
    
    free(buf);
    
    *hash_out = result;
    *hash_len = SHA256_DIGEST_LENGTH;
    
    return 0;
}

int REST_sign_verify(char* url, unsigned long url_len, char* data, unsigned long data_len, unsigned char* hash, unsigned long hash_len)
{
    char* buf;
    unsigned long buf_len;
    char salt[] = DEFAULT_SALT;
    unsigned char* result;
    SHA256_CTX sha256;
    
    int i;
    
    // basic validation
    if ((NULL == url)||(url_len<=0)
        || ( NULL!=data&&data_len<=0 )
        || ( NULL==data&&data_len!=0 )
        || ( SHA256_DIGEST_LENGTH != hash_len )
        ||(NULL == hash)||(hash_len<=0)) {
        return -1;
    }
    
    // construct the covered text
    buf_len = url_len+strlen(salt)+data_len+1;
    buf =(char*)  malloc(buf_len*sizeof(char));
    if (NULL == data) {
        snprintf(buf,buf_len, "%s%s", url, salt);
    } else {
        snprintf(buf,buf_len, "%s%s%s", url, salt, data);
    }
    
    // construct the hash result buffer
    result = (unsigned char*) malloc(SHA256_DIGEST_LENGTH*sizeof(unsigned char));
    
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, buf, buf_len);
    SHA256_Final(result, &sha256);
    
    free(buf);
    
    // validate the hash
    for (i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        if (hash[i]!=result[i]) {
            free(result);
            return -1;
        }
    }
    
    free(result);
    return 0;
}



