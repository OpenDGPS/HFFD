/*****************************************************************/
/*	             THIS FILE WILL BE GENERATED                     */
/*	                      DO NOT EDIT!                           */
/*****************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>
#include "converter.cu"
#include "writeRecord.cu"

#define RECORDLENGTH 120
struct recordData
{
	// 03 RECID        PIC 9(05) COMP-3 VALUE ZERO. // 3
	uint32_t 	RECID;
	// 03 SYSTEMID     PIC X(04) VALUE 'S085'. // 4
	char		*SYSTEMID[4];
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
};

__device__ int getGlobalIdx_1D_1D()
{
	return blockIdx.x *blockDim.x + threadIdx.x;
}

__global__ void decodeRecord ( int numOfCores, int recordNum, uint8_t *inputMemAddress , uint8_t *outputMemAddress ) {
	int recordAddress;
	int threadIdx;
	threadIdx = getGlobalIdx_1D_1D();
	recordAddress = (threadIdx * RECORDLENGTH);
	outputMemAddress[threadIdx] = recordAddress; // recordAddress; // inputMemAddress[ ( uint8_t ) recordAddress ];

	struct recordData theRecord;
	comp3ToInt ( recordAddress, 5, &theRecord.RECID );
		recordAddress = recordAddress + 5; 
	charToCharArray ( recordAddress, 4, *theRecord.SYSTEMID );
		recordAddress = recordAddress + 4; 
	comp3ToInt ( recordAddress, 5, &theRecord.MANDID );
		recordAddress = recordAddress + 5; 
	charToCharArray ( recordAddress, 40, *theRecord.NAME );
		recordAddress = recordAddress + 40; 
	comp3ToInt ( recordAddress, 11, &theRecord.POLNR );
		recordAddress = recordAddress + 11; 
	comp3ToInt ( recordAddress, 3, &theRecord.RISPA );
		recordAddress = recordAddress + 3; 
	charToCharArray ( recordAddress, 3, *theRecord.WAEHR );
		recordAddress = recordAddress + 3; 
	comp3ToSignedInt ( recordAddress, 9, &theRecord.PRAEMIE );
		recordAddress = recordAddress + 9; 
	charToCharArray ( recordAddress, 50, *theRecord.INFO );
		recordAddress = recordAddress + 50; 
	charToCharArray ( recordAddress, 3, *theRecord.ENDE );
		recordAddress = recordAddress + 3; 

}
