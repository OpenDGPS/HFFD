#include <stdio.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>


// 03 C86R8200-RECID        PIC 9(05) COMP-3 VALUE ZERO.
__global__ int comp3ToInt ( int memAddress ) {
	// converting BCD to integer 
	// http://www.3480-3590-data-conversion.com/article-bcd-binary.html
	char byteOne, byteTwo, byteThree, byteFour, byteFive;
	byteOne = memAddress[0];
	byteTwo = memAddress[1];
	byteThree = memAddress[2];
	byteFour = memAddress[3];
	byteFive = memAddress[4];
	return 0;
}

__global__ char smallInt ( char in ) {
	return in;
}

__global__ void decodeRecord ( int numOfCores, int recordNum ) {
}
