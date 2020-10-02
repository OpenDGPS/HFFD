#include <stdio.h>
#include <stdlib.h>
#include "cuda/record.cu"


// 1317133


int getDeltaRecords ( char* inputMasterFileName, char* inputReferenceFileName, char* outputFileName ) {
  return 0;
}

int getDeltaVariables ( char* inputMasterFileName, char* inputReferenceFileName, char* outputFileName ) {
  return 0;
}

int main ( int argc, char **argv ) {
	printf("Starting kernel %d.\n", OUTPUTBINARYSIZE);
	uint8_t *ptr_hostfile;
	uint8_t *ptr_output;
	FILE *ptr_fp;
    uint8_t *d_hostfile;
    uint8_t *d_output;
	ptr_hostfile = (uint8_t *)malloc(BINARYSIZE);
	ptr_output = (uint8_t *)malloc(OUTPUTBINARYSIZE);
	if ( !ptr_hostfile ) {
		printf("Memory allocation error!\n");
		exit(1);
	} 
	if (argc < 2) {
		free(ptr_hostfile);
		free(ptr_output);
		printf("No input file.\n");
		exit(1);
	}
	if((ptr_fp = fopen(argv[1], "rb"))==NULL)
	{
		printf("Unable to open the file!\n");
		exit(1);
	}

	if(fread(ptr_hostfile, BINARYSIZE * sizeof( uint8_t ), 1, ptr_fp) != 1)
	{
		printf( "Read error!\n" );
		exit( 1 );
	}

	fclose(ptr_fp);
//	free(ptr_hostfile);

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	dim3 blocksPerGrid(BLOCKSPERGRID,1,1); //use only one block
	dim3 threadsPerBlock(NUMOFCORES,1,1); //use N threads in the block myKernel<<<blocksPerGrid, threadsPerBlock>>>(result);
    
    checkCudaErrors(cudaMalloc((uint8_t**)&d_hostfile, (BINARYSIZE)));
    checkCudaErrors(cudaMemcpy(d_hostfile, ptr_hostfile, (BINARYSIZE), cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMalloc((uint8_t**)&d_output, OUTPUTBINARYSIZE));
    checkCudaErrors(cudaMemcpy(d_output, ptr_output, OUTPUTBINARYSIZE, cudaMemcpyHostToDevice));
 	// start the i86 opcode interpreter on the GPU   
	cudaEventRecord(start);
    decodeRecord<<<blocksPerGrid, threadsPerBlock>>>( d_hostfile, d_output ); // numofcores and recordnum
	cudaEventRecord(stop);
    
    // checkCudaErrors(cudaMemcpy(ptr_hostfileCopy, d_hostfile, (TOTALBINARYSIZE), cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(ptr_output, d_output, OUTPUTBINARYSIZE, cudaMemcpyDeviceToHost));

    checkCudaErrors(cudaFree(d_hostfile));
    checkCudaErrors(cudaFree(d_output));
	cudaEventSynchronize(stop);

	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	printf("used time in sec: %f\n", milliseconds / 1000);
/*

	for ( int i = 0; i < (OUTPUTRECORDLENGTH * 10); i++ ) {
		if ( (i % OUTPUTRECORDLENGTH) == 0 ) printf("\n%d\t", i);
		printf("%02x ", ptr_output[i]);
	}
	printf("\n");
*/
	if (argc < 3) {
		free(ptr_output);
		printf("No output file.\n");
		exit(0);
	}

	FILE *out = fopen(argv[2], "wb");
	if ( out != NULL ) {
		const size_t wrote = fwrite(ptr_output, OUTPUTBINARYSIZE, 1, out);
		printf("Datei geschrieben: %lu\n", wrote);
	}

	
	free(ptr_output);
	printf("Kernel stopped.\n");
  return 0;
}
