#ifndef RESTSIGN_5F88HE5K

#define RESTSIGN_5F88HE5K


int REST_sign(char* url, int url_len, char* data, int data_len, unsigned char** hash_out, int* hash_len);

int REST_sign_verify(char* url, unsigned long url_len, char* data, unsigned long data_len, unsigned char* hash, unsigned long hash_len);

#endif /* end of include guard: RESTSIGN_5F88HE5K */
