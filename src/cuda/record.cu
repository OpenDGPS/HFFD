/*****************************************************************/
/*               THIS FILE WILL BE GENERATED                     */
/*                        DO NOT EDIT!                           */
/*****************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>
#include "converter.cu"
#include "writeRecord.cu"

#define RECORDLENGTH 120
typedef struct recordData
{
	// 03 RECID        PIC 9(05) COMP-3 VALUE ZERO. // 3
	uint32_t 	RECID;
	// 03 SYSTEMID     PIC X(04) VALUE 'S085'. // 4
	uint32_t	SYSTEMID_0;
	uint32_t	SYSTEMID_1;
	uint32_t	SYSTEMID_2;
	uint32_t	SYSTEMID_3;
	// 03 MANDID       PIC 9(05) COMP-3 VALUE 10010. // 3
	uint32_t	MANDID;
	// 03 NAME         PIC X(40) VALUE 'MAX MUSTER'. // 40
	char 		*NAME[40];
	// 03 POLNR        PIC 9(11) COMP-3 VALUE 0100001. // 6
	uint32_t 	POLNR;
	// 03 RISPA        PIC 9(03) COMP-3 VALUE 207. // 2
	uint32_t 	RISPA;
	// 03 WAEHR        PIC X(03) VALUE 'EUR'. // 3
	char 		*WAEHR[3];
	// 03 PRAEMIE      PIC S9(9)V99 COMP-3 VALUE 228.30. // 5
	int32_t		PRAEMIE;
	// 03 INFO         PIC X(50) VALUE 'ICH BIN EIN SATZ.'. // 50
	char 		*INFO[50];
	// 03 ENDE         PIC X(03) VALUE LOW-VALUE. // 3
	char 		*ENDE[3];
} theRecords;

// int outputLength[10] = {4,4,4,40,4,4,3,4,50,3};

__device__ int getGlobalIdx_1D_1D()
{
	return blockIdx.x *blockDim.x + threadIdx.x;
}

__global__ void decodeRecord ( int numOfCores, int recordNum, uint8_t *inputMemAddress , uint8_t *outputMemAddress ) {
	int recordAddress,outputAddress;
	int threadIdx;
	threadIdx = getGlobalIdx_1D_1D();
	recordAddress = (threadIdx * RECORDLENGTH);
	outputAddress = (threadIdx * RECORDLENGTH);
	outputMemAddress[threadIdx] = inputMemAddress[ recordAddress ]; // recordAddress; // inputMemAddress[ ( uint8_t ) recordAddress ];
	theRecords theRecord;
	theRecords * thisRecord = &theRecord;
	// recordData theRecords;
	// theRecords *theRecord = malloc(sizeof(theRecords));
	thisRecord->RECID = 14;
	comp3ToInt ( inputMemAddress, recordAddress, 3, &thisRecord->RECID );
		outputMemAddress[outputAddress] = thisRecord->RECID >> 24;
		outputMemAddress[outputAddress + 1] = thisRecord->RECID >> 16;
		outputMemAddress[outputAddress + 2] = thisRecord->RECID >> 8;
		outputMemAddress[outputAddress + 3] = thisRecord->RECID >> 0;
		recordAddress = recordAddress + 3; 
		outputAddress = outputAddress + 4;
	charToCharArray ( inputMemAddress, recordAddress, 1, &thisRecord->SYSTEMID_0 );
		outputMemAddress[outputAddress] = thisRecord->SYSTEMID_0;
		recordAddress = recordAddress + 1; 
		outputAddress = outputAddress + 1;
	charToCharArray ( inputMemAddress, recordAddress, 1, &thisRecord->SYSTEMID_1 );
		outputMemAddress[outputAddress] = thisRecord->SYSTEMID_1;
		recordAddress = recordAddress + 1; 
		outputAddress = outputAddress + 1;
	charToCharArray ( inputMemAddress, recordAddress, 1, &thisRecord->SYSTEMID_2 );
		outputMemAddress[outputAddress] = thisRecord->SYSTEMID_2;
		recordAddress = recordAddress + 1; 
		outputAddress = outputAddress + 1;
	charToCharArray ( inputMemAddress, recordAddress, 1, &thisRecord->SYSTEMID_3 );
		outputMemAddress[outputAddress] = thisRecord->SYSTEMID_3;
		recordAddress = recordAddress + 1; 
		outputAddress = outputAddress + 1;
/*	comp3ToInt ( inputMemAddress, recordAddress, 5, &theRecord.MANDID );
		recordAddress = recordAddress + 5; 
	charToCharArray ( recordAddress, 40, *theRecord.NAME );
		recordAddress = recordAddress + 40; 
	comp3ToInt ( inputMemAddress, recordAddress, 11, &theRecord.POLNR );
		recordAddress = recordAddress + 11; 
	comp3ToInt ( inputMemAddress, recordAddress, 3, &theRecord.RISPA );
		recordAddress = recordAddress + 3; 
	charToCharArray ( recordAddress, 3, *theRecord.WAEHR );
		recordAddress = recordAddress + 3; 
	comp3ToSignedInt ( recordAddress, 9, &theRecord.PRAEMIE );
		recordAddress = recordAddress + 9; 
	charToCharArray ( recordAddress, 50, *theRecord.INFO );
		recordAddress = recordAddress + 50; 
	charToCharArray ( recordAddress, 3, *theRecord.ENDE );
		recordAddress = recordAddress + 3; */
}
