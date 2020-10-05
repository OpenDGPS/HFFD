
/*****************************************************************/
/*               THIS FILE WILL BE GENERATED                     */
/*                        DO NOT EDIT!                           */
/*****************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>

    
#define NUMOFRECORDS 223
#define RECORDLENGTH 63
#define OUTPUTRECORDLENGTH 81 
#define BINARYSIZE RECORDLENGTH * NUMOFRECORDS 
#define OUTPUTBINARYSIZE OUTPUTRECORDLENGTH * NUMOFRECORDS
#define NUMOFCORES 1024

#define BLOCKSPERGRID 1024

#define DELIMITER 0x3b
#define COMMA 0x2c

#include "converter.cu"

__device__ int getGlobalIdx_1D_1D() {
	return blockIdx.x *blockDim.x + threadIdx.x;
}

__device__ int getGlobalIdx_1D_2D() {
	return blockIdx.x * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
}

__global__ void decodeRecord ( uint8_t *inputMemAddress , uint8_t *outputMemAddress ) {
	int recordAddress,outputAddress;
	int threadIdx;
	int bcdIntegerLength = 0;
	threadIdx = getGlobalIdx_1D_2D(); // getGlobalIdx_1D_1D();
	if (threadIdx < NUMOFRECORDS ) {
		recordAddress = (threadIdx * RECORDLENGTH);
		outputAddress = (threadIdx * OUTPUTRECORDLENGTH);

    		// DECIMAL: BUENDELPOLNR
		bcdIntegerLength = 11;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 6;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: VERSION
		bcdIntegerLength = 5;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 3;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: SPARTENPOLNR
		bcdIntegerLength = 11;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 6;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: PRODUKT
		charToCharArray ( inputMemAddress, recordAddress, 5, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 5;
			outputAddress = outputAddress + 6;
			outputMemAddress[outputAddress - 1] = DELIMITER;

         
      		// DECIMAL: VB
		bcdIntegerLength = 9;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 5, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 5;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: KZVALID
		charToCharArray ( inputMemAddress, recordAddress, 1, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 2;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BETREUER
		bcdIntegerLength = 7;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 4, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 4;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: ANTRAGSART
		bcdIntegerLength = 1;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 1, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: TC_KZ
		charToCharArray ( inputMemAddress, recordAddress, 3, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 3;
			outputAddress = outputAddress + 4;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: SPARTE
		bcdIntegerLength = 1;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 1, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: KZDUPO
		charToCharArray ( inputMemAddress, recordAddress, 1, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 2;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: VERARB_STAT
		charToCharArray ( inputMemAddress, recordAddress, 1, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 2;
			outputMemAddress[outputAddress - 1] = DELIMITER;

			outputMemAddress[outputAddress] = 0x0d;
			outputMemAddress[outputAddress + 1] = 0x0a;
	}

}
      
    