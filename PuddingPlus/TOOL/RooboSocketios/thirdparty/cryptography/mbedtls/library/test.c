#include <stdio.h>
#include <stdlib.h>

#include "mbedtls/rsa.h"
#include "mbedtls/md2.h"
#include "mbedtls/md4.h"
#include "mbedtls/md5.h"
#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"
#include "mbedtls/entropy.h"
#include "mbedtls/ctr_drbg.h"

#include "mbedtls/test.h"

#include "mbedtls/pk.h"

int test_rsa(unsigned char * to_encrypt, size_t to_encrypt_len){

	int ret = 0;

	char tmp[1000] = {0};

	mbedtls_pk_context pk;

	mbedtls_pk_init( &pk );

	/*
	 *      * Read the RSA public key
	 *           
	 *  */
	if( ( ret = mbedtls_pk_parse_public_keyfile( &pk, "test.pub" ) ) != 0 )
	{
		printf( " failed\n  ! mbedtls_pk_parse_public_keyfile returned -0x%04x\n", -ret );
		goto exit;
	}

	unsigned char buf[MBEDTLS_MPI_MAX_SIZE];
	size_t olen = 0;

	/*
	 *      * Calculate the RSA encryption of the data.
	 *           */
	printf( "\n  . Generating the encrypted value\n" );
	fflush( stdout );

	mbedtls_entropy_context entropy;
	mbedtls_entropy_init( &entropy );

	mbedtls_ctr_drbg_context ctr_drbg;
	mbedtls_ctr_drbg_init(&ctr_drbg);
	
	char *personalization = "my_app_specific_string";

	ret = mbedtls_ctr_drbg_seed( &ctr_drbg, mbedtls_entropy_func, &entropy,
			(const unsigned char *) personalization,
			strlen( personalization ) );
	if( ret != 0){
		printf("mbedtls_ctr_drbg_seed failed, return %d\n", ret);
		goto exit;
	}



	if( ( ret = mbedtls_pk_encrypt( &pk, to_encrypt, to_encrypt_len,
					buf, &olen, sizeof(buf),
					mbedtls_ctr_drbg_random, &ctr_drbg ) ) != 0 )
	{
		printf( " failed\n  ! mbedtls_pk_encrypt returned -0x%04x\n", -ret );
		goto exit;
	}


	 hexify( tmp, buf, olen );
	 printf("encrypted %s\n", tmp);



exit:
	mbedtls_ctr_drbg_free(&ctr_drbg);
	mbedtls_pk_free(&pk);
	return ret;
}




/* BEGIN_CASE */
void test_mbedtls_rsa_pkcs1_encrypt( char *message_hex_string, int padding_mode, int mod,
		int radix_N, char *input_N, int radix_E, char *input_E,
		char *result_hex_str, int result )
{
	unsigned char message_str[1000];
	unsigned char output[1000];
	unsigned char output_str[1000];

	mbedtls_rsa_context ctx;

	size_t msg_len;
	rnd_pseudo_info rnd_info;

	memset( &rnd_info, 0, sizeof( rnd_pseudo_info ) );

	mbedtls_rsa_init( &ctx, padding_mode, 0 );

	memset( message_str, 0x00, 1000 );
	memset( output, 0x00, 1000 );
	memset( output_str, 0x00, 1000 );

	ctx.len = mod / 8;

	TEST_ASSERT( mbedtls_mpi_read_string( &ctx.N, radix_N, input_N ) == 0 );

	TEST_ASSERT( mbedtls_mpi_read_string( &ctx.E, radix_E, input_E ) == 0 );

	TEST_ASSERT( mbedtls_rsa_check_pubkey( &ctx ) == 0 );

	msg_len = unhexify( message_str, message_hex_string );

	TEST_ASSERT( mbedtls_rsa_pkcs1_encrypt( &ctx, &rnd_pseudo_rand, &rnd_info, MBEDTLS_RSA_PUBLIC, msg_len, message_str, output ) == result );
	if( result == 0 )
	{
		hexify( output_str, output, ctx.len );

		TEST_ASSERT( strcasecmp( (char *) output_str, result_hex_str ) == 0 );
	}

exit:
	mbedtls_rsa_free( &ctx );
}


int main1(){

	unsigned char input[10] = {'1','2','3','4','5','6','7','8','9','0'};
	test_rsa((unsigned char *)input, (size_t)10);
	return 0;
}
