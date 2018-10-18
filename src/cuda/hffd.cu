#include <stdio.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>

__global__ char smallInt ( char in ) {
	return in;
}

__global__ void decodeRecord ( int numOfCores, int recordNum ) {
}
