/**************    reference black-box implementation of SPNBOX-16    ************/
/*******            2019.12                          ***************/
/**********     junjunll1212@gmail.com            ***********************/
  
#include <stdlib.h>
#include<sys/time.h>
#include <givaro/gfq.h>
#include <ctime>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include <vector>
//#include <aessbox.h>
#define u8 uint8_t
#define u16 uint16_t   
#define u32 uint32_t
#define roundaes16 32
#define round 10
#define block 1// message of length 2048 bytes
#define loops 1 //  repeat 100000 times
static	u16 input[block][8][1],temp[block][8][1];
static	u8 rk[roundaes16 + 1][2];
#ifdef __GNUC__
#include <x86intrin.h>
#endif
#ifdef _MSC_VER_
#include <intrin.h>
#endif
#pragma intrinsic(__rdtsc)
uint64_t start_rdtsc()
{
	return __rdtsc();
}
uint64_t end_rdtsc()
{
	return __rdtsc();
}
using namespace Givaro;
int modulus[] = { 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 }; // x^16 + x^5 + x^3 + x + 1 (1,002b)
GFqDom<int32_t> GF216(2, 16, modulus);

/***aessbox***/
u8 aessbox[256]=
{
	    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
		0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
		0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
		0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
		0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
		0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
		0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
		0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
		0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
		0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
		0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
		0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
		0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
		0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
		0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
		0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};
u8 aesinvsbox[256]=
{
    	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
		0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
		0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
		0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
		0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
		0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
		0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
		0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
		0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
		0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
		0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
		0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
		0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
		0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
		0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
		0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
};


/****************     MDS matrix comes from block cipher khazad    ***********************/
u16 PM[8][8] = { //khazad matrix = had(1,3,4,5,6,8,b,7)
	{0x01,0x03,0x04,0x05,0x06,0x08,0x0b,0x07},
	{0x03,0x01,0x05,0x04,0x08,0x06,0x07,0x0b},
	{0x04,0x05,0x01,0x03,0x0b,0x07,0x06,0x08},
	{0x05,0x04,0x03,0x01,0x07,0x0b,0x08,0x06},
	{0x06,0x08,0x0b,0x07,0x01,0x03,0x04,0x05},
	{0x08,0x06,0x07,0x0b,0x03,0x01,0x05,0x04},
	{0x0b,0x07,0x06,0x08,0x04,0x05,0x01,0x03},
	{0x07,0x0b,0x08,0x06,0x05,0x04,0x03,0x01}
}; /*************************************************************************************/
/**************       AES16  ***************************/

using namespace Givaro;
int modulus2[] = { 1, 1, 0, 1, 1, 0, 0, 0, 1 }; // x^8 + x^4 + x^3 + x + 1 (AES) (right is high-order)
GFqDom<int32_t> GF28(2, 8, modulus2);

/***************    key generation of AES-16   *********************/
void AES16KeySchedule(u8 rk[roundaes16 + 1][2])
{
	u8 i;
	for (i = 0; i < roundaes16 + 1; ++i)
	{
		//rk[i] = rand();
		rk[i][0] = i; //ignore KDF, we fix the key
		rk[i][1] = i + 1;
		printf("rk = %llu\n",rk[i][0]);
		printf("rk = %llu\n",rk[i][1]);
	}
}
/***************    round function of AES-16   *********************/
void AES16Roundfunc(u8* arrc1, u8* arrc0, u8 arrrk[])
{
	/********      Subbyte       **************/
	*arrc1 = aessbox[*arrc1]; *arrc0 = aessbox[*arrc0];
	/***********    Mixcolumn  *****************/// MC = [02, 01; 03, 02];
	GFqDom<int32_t>::Element s1, s0, a1, b1, c1, a2, b2, c2;
	GF28.init(s1, 0); GF28.init(s0, 0);

	GF28.init(a1, 0x02);  GF28.init(a2, 0x01); // initialize
	GF28.init(b1, *arrc1); GF28.init(b2, *arrc0);
	GF28.mul(c1, a1, b1); GF28.mul(c2, a2, b2);  // field multiplication
	GF28.add(s1, c1, c2);   //0x02*arrc1+0x01*arrc0
	int32_t s1_int;
	GF28.convert(s1_int, s1);

	GF28.init(a1, 0x03);  GF28.init(a2, 0x02); // initialize
	GF28.init(b1, *arrc1); GF28.init(b2, *arrc0);
	GF28.mul(c1, a1, b1); GF28.mul(c2, a2, b2);  // field multiplication
	GF28.add(s0, c1, c2);   //0x03*arrc1+0x02*arrc0
	int32_t s0_int;
	GF28.convert(s0_int, s0);
	*arrc1 = (u8)s1_int;
	*arrc0 = (u8)s0_int;
	/*********      Addroundkey         ***************/
	*arrc1 ^= arrrk[1]; *arrc0 ^= arrrk[0];
}
/***************    inverse round function of AES-16   *********************/
void AES16invRoundfunc(u8* arrc1, u8* arrc0, u8 arrrk[])
{
	/*********      Addroundkey         ****************/
	*arrc1 ^= arrrk[1]; *arrc0 ^= arrrk[0];

	/***********    Mixcolumn  ******************/ //invMC = [b9, d1; 68, b9];
	GFqDom<int32_t>::Element s1, s0, a1, b1, c1, a2, b2, c2;
	GF28.init(s1, 0); GF28.init(s0, 0);

	GF28.init(a1, 0xb9);  GF28.init(a2, 0xd1); // initialize
	GF28.init(b1, *arrc1); GF28.init(b2, *arrc0);
	GF28.mul(c1, a1, b1); GF28.mul(c2, a2, b2);  // field multiplication
	GF28.add(s1, c1, c2);   //0xb9*arrc1+0xd1*arrc0
	int32_t s1_int;
	GF28.convert(s1_int, s1);

	GF28.init(a1, 0x68);  GF28.init(a2, 0xb9); // initialize
	GF28.init(b1, *arrc1); GF28.init(b2, *arrc0);
	GF28.mul(c1, a1, b1); GF28.mul(c2, a2, b2);  // field multiplication
	GF28.add(s0, c1, c2);   //0x68*arrc1+0xb9*arrc0
	int32_t s0_int;
	GF28.convert(s0_int, s0);
	*arrc1 = (u8)s1_int;
	*arrc0 = (u8)s0_int;
	/********      Subbyte       ***************/
	*arrc1 = aesinvsbox[*arrc1]; *arrc0 = aesinvsbox[*arrc0];
}
/***************    encryption of AES-16   *********************/
void AES16Encrypt(u8 Pt[], u8 Ct[], u8 rk[roundaes16 + 1][2])
{
	u8 i;
	printf("rk[0][0] = %llu\n",rk[0][0]);
	printf("rk[0][1] = %llu\n",rk[0][1]);
	printf("aes round bbefore 1 = %llu\n",Pt[0]);
	printf("aes round bbefore 2 = %llu\n",Pt[1]);
	Ct[0] = Pt[0] ^ rk[0][0]; Ct[1] = Pt[1] ^ rk[0][1];
	printf("aes round before 1 = %llu\n",Ct[0]);
	printf("aes round before 2 = %llu\n",Ct[1]);
	for (i = 0; i < roundaes16; i++)
	{
		AES16Roundfunc(&Ct[1], &Ct[0], rk[i + 1]);
	}
	printf("aes round after 1 = %llu\n",Ct[0]);
	printf("aes round after 2 = %llu\n",Ct[1]);
}
/***************    decryption of AES-16   *********************/
void AES16Decrypt(u8 Ct[], u8 Pt[], u8 rk[roundaes16 + 1][2])
{
	u8 i;
	Pt[0] = Ct[0]; Pt[1] = Ct[1];
	for (i = roundaes16; i > 0; i--)
	{
		AES16invRoundfunc(&Pt[1], &Pt[0], rk[i]);
	}
	Pt[0] ^= rk[0][0]; Pt[1] ^= rk[0][1];
}
/*******************   (inv)nonlinear layer of SPNBOX16  ****************************/
void nonlinear(u16 arr[8][1], u8 roundkey[roundaes16 + 1][2]) // need to be modified
{
	u8 arrP[8][2],arrC[8][2];
	for (u16 i = 0; i < 8; i++)
	{
		arrP[i][0]= (u8)(arr[i][0] >> 8); //high
		arrP[i][1] = (u8)(arr[i][0]); //low
		AES16Encrypt(arrP[i], arrC[i], roundkey);
		arr[i][0]=(arrC[i][0] << 8) ^ arrC[i][1];	
	}  
}
void invnonlinear(u16 arr[8][1], u8 roundkey[roundaes16 + 1][2])
{
	u8 arrP[8][2], arrC[8][2];
	for (u16 i = 0; i < 8; i++)
	{
		arrC[i][0] = (u8)(arr[i][0] >> 8); //high
		arrC[i][1] = (u8)(arr[i][0]); //low
		AES16Decrypt(arrC[i], arrP[i], roundkey);
		arr[i][0] = (arrP[i][0] << 8) ^ arrP[i][1];
	}
}
/*******************   (inv)linear layer of SPNBOX16  ****************************/
void linear(u16 arr[8][1])
{
	u16 temp[8][1];
	for (u16 i = 0; i < 8; i++)
	{
		GFqDom<int32_t>::Element s;
		GF216.init(s, 0);
		for (u16 k = 0; k < 8; k++)
		{
			GFqDom<int32_t>::Element a, b, c;
			GF216.init(a, PM[i][k]);   // initialize
			GF216.init(b, arr[k][0]);
			GF216.mul(c, a, b);   // field multiplication
			GF216.add(s, s, c);
		}
		int32_t s_int;
		GF216.convert(s_int, s);
		temp[i][0] = (u16)s_int;
	}
	for (u16 i = 0; i < 8; i++) {
		arr[i][0] = temp[i][0];
	}
}
/*******************   encryption of SPNBOX16  ****************************/
void encryptionblack(u16 input[block][8][1], u8 roundkey[roundaes16 + 1][2])
{
	for (int i = 0; i < round; i++)
	{
		for (int j = 0; j < block; j++)
		{
			nonlinear(input[j],roundkey);  // nonlinear layer
			linear(input[j]);    //linear layer	
			for (int k = 0; k < 8; k++)  //affine layer
			{
				input[j][k][0] ^= (u16)(8 * i + k + 1);
			}
		}
	}
}
/*******************   decryption of SPNBOX16  ****************************/
void decryptionblack(u16 input[block][8][1], u8 roundkey[roundaes16 + 1][2])
{
	for (int i = round-1; i >= 0 ; i--)
	{
		for (int j = 0; j < block; j++)
		{
			for (int k = 0; k < 8; k++)  //inverse affine layer
			{
				input[j][k][0] ^= (u8)(8 * i + k + 1);
			}
			linear(input[j]);    //inverse linear layer is the same as linear layer
			invnonlinear(input[j],roundkey);  // inverse nonlinear layer
		}
	}
}
/*********************************************************************************************

BELOW are some useful functions!

************************************************************************************************/
uint64_t Average(uint64_t list[], int lenlist)
{
	uint64_t ave, sum = 0;
	for (int i = 0; i < lenlist; i++) {
		sum += list[i];
	}
	ave = sum / lenlist;
	return ave;
}
void printmessage(u16 arr[block][8][1])
{
	for (int i = 0; i < block; i++)
		printf("%04X%04X%04X%04X%04X%04X%04X%04X",
			arr[i][0][0], arr[i][1][0], arr[i][2][0], arr[i][3][0], arr[i][4][0], arr[i][5][0], arr[i][6][0], arr[i][7][0]);
}
/********************** generate random message (plaintext)  ************************************/
void generatemessage(u16 arr1[block][8][1])
{
	// for (int i = 0; i < block; i++)
	// {
	// 	for (int j = 0; j < 8; j++)
	// 	{
	// 		arr1[i][j][0] = rand();
	// 	}
	// }
	arr1[0][0][0] = 47299;
	arr1[0][1][0] = 63330;
	arr1[0][2][0] = 59632;
	arr1[0][3][0] = 15413;
	arr1[0][4][0] = 31369;
	arr1[0][5][0] = 16064;
	arr1[0][6][0] = 37007;
	arr1[0][7][0] = 36856;
}
/***********************  verify decryption   **********************************/
void verifydecryption(u16 arr1[block][8][1], u16 arr2[block][8][1])
{
	int i = memcmp(arr1, arr2, 16);
	if (i == 0)
		printf("VERIFY DECRYPTION CORRECT!");
	else
		printf("VERIFY DECRYPTION WRONG!");
}
int main(int argc, char** argv, u8 roundkey[roundaes16 + 1][2])
{
	srand(time(0));
	uint64_t begin; uint64_t end; uint64_t elapsed_cycles[loops];
	AES16KeySchedule(rk);
	for (int k = 0; k < loops; k++)
	{
		printf("********* loop %d results below  ************\n", k);		
		generatemessage(input);
		memcpy(temp, input, 16*block);
		begin = start_rdtsc();
		encryptionblack(input,rk); //encrypt message
		end = end_rdtsc();

		printf("after encryption.\n");
		for (int i = 0; i < block; i++)
		{
			for (int j = 0; j < 8; j++)
			{
				printf("input = %llu\n",input[i][j][0]);
			}

		}
		elapsed_cycles[k] = (end - begin);
		decryptionblack(input,rk);//decrypt message
		printf("\n");
		verifydecryption(input, temp);	//verify decryption result
		printf("\n"); 	
	}
	uint64_t avecycles = Average(elapsed_cycles, loops);
	printf ("average cost %llu CPU cycles \n",avecycles);
	uint64_t cpb = avecycles/(block*16);
	printf ("average CPB for encryption is %llu \n",cpb);
	return 0;
}







