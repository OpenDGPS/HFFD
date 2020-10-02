
/*****************************************************************/
/*               THIS FILE WILL BE GENERATED                     */
/*                        DO NOT EDIT!                           */
/*****************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>

    
#define NUMOFRECORDS 10000
#define RECORDLENGTH 64
#define OUTPUTRECORDLENGTH 131 
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

    		// DECIMAL: POLNR
		bcdIntegerLength = 11;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 6;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: SPARTE
		bcdIntegerLength = 1;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 1, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: TARIF
		bcdIntegerLength = 5;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 3;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: RISIKO
		bcdIntegerLength = 3;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 2;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: SCHICHT
		bcdIntegerLength = 5;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 3;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;

         
      		// DECIMAL: AEART
		bcdIntegerLength = 3;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 2;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// INTEGER: BONUS
		compToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 4;
			outputAddress = outputAddress + 5;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: KFZLFDNR
		bcdIntegerLength = 3;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 2;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;

         
      
         
      
         
      
         
      
         
      		// INTEGER: STATZAHL
		compToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 4;
			outputAddress = outputAddress + 5;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// CHAR: KZGRUENK
		charToCharArray ( inputMemAddress, recordAddress, 1, outputMemAddress, outputAddress);
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 2;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: AUTTAR
		bcdIntegerLength = 1;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 1, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 1;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BASISPREX
		bcdIntegerLength = 13;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 7, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 7;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BASISPRIN
		bcdIntegerLength = 13;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 7, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 7;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BMSTUFE
		bcdIntegerLength = 5;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 3, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 3;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BMJAHR
		bcdIntegerLength = 7;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 4, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 4;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;
		// DECIMAL: BLOCKNR
		bcdIntegerLength = 3;
		comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 2, 8, outputMemAddress, outputAddress, 0 );
			recordAddress = recordAddress + 2;
			outputAddress = outputAddress + 9;
			outputMemAddress[outputAddress - 1] = DELIMITER;

			outputMemAddress[outputAddress] = 0x0d;
			outputMemAddress[outputAddress + 1] = 0x0a;
	}

}
      
    