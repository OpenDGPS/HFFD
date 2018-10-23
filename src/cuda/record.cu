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

__device__ int getGlobalIdx_1D_1D() {
	return blockIdx.x *blockDim.x + threadIdx.x;
}

__device__ int getGlobalIdx_1D_2D() {
	return blockIdx.x * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
}

__global__ void decodeRecord ( int numOfCores, int recordNum, uint8_t *inputMemAddress , uint8_t *outputMemAddress ) {
	int recordAddress,outputAddress;
	int threadIdx;
	threadIdx = getGlobalIdx_1D_2D(); // getGlobalIdx_1D_1D();
	recordAddress = (threadIdx * RECORDLENGTH);
	outputAddress = (threadIdx * RECORDLENGTH);
	outputMemAddress[threadIdx] = inputMemAddress[ recordAddress ]; // recordAddress; // inputMemAddress[ ( uint8_t ) recordAddress ];
	int bcdIntegerLength = 5;
	// 03 RECID        PIC 9(05) COMP-3 VALUE ZERO. // 3
	comp3ToInt ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 3; 
		outputAddress = outputAddress + 4;
	// 03 SYSTEMID     PIC X(04) VALUE 'S085'. // 4
	charToCharArray ( inputMemAddress, recordAddress, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 4; 
		outputAddress = outputAddress + 4;
	// 03 MANDID       PIC 9(05) COMP-3 VALUE 10010. // 3
	comp3ToInt ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 3; 
		outputAddress = outputAddress + 4;
	// 03 NAME         PIC X(40) VALUE 'MAX MUSTER'. // 40
	charToCharArray ( inputMemAddress, recordAddress, 40, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 40; 
		outputAddress = outputAddress + 40;
	// 03 POLNR        PIC 9(11) COMP-3 VALUE 0100001. // 6
	bcdIntegerLength = 11;
	comp3ToInt ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 6; 
		outputAddress = outputAddress + 4;
	// 03 RISPA        PIC 9(03) COMP-3 VALUE 207. // 2
	bcdIntegerLength = 3;
	comp3ToInt ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 2; 
		outputAddress = outputAddress + 4;
	// 03 WAEHR        PIC X(03) VALUE 'EUR'. // 3
	charToCharArray ( inputMemAddress, recordAddress, 3, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 3; 
		outputAddress = outputAddress + 3;
	// 03 PRAEMIE      PIC S9(9)V99 COMP-3 VALUE 228.30. // 5
	bcdIntegerLength = 9;
	comp3ToInt ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 4, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 6; 
		outputAddress = outputAddress + 4;
	// 03 INFO         PIC X(50) VALUE 'ICH BIN EIN SATZ.'. // 50
	charToCharArray ( inputMemAddress, recordAddress, 50, outputMemAddress, outputAddress );
		recordAddress = recordAddress + 50; 
		outputAddress = outputAddress + 50;
	// 03 ENDE         PIC X(03) VALUE LOW-VALUE. // 3
	charToCharArray ( inputMemAddress, recordAddress, 3, outputMemAddress, outputAddress );
	//	recordAddress = recordAddress + 3; 
	//	outputAddress = outputAddress + 3;
}
