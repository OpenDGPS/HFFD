#include <stdio.h>
#include <stdlib.h>
#include "cuda/record.cu"

#define BINARYSIZE RECORDLENGTH * NUMOFRECORDS 
#define OUTPUTBINARYSIZE OUTPUTRECORDLENGTH * NUMOFRECORDS
#define NUMOFCORES 130


int decodeHF ( void ) {
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
	if((ptr_fp = fopen("sample/sample-hostfile-1000.bin", "rb"))==NULL)
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

	dim3 blocksPerGrid(100,1,1); //use only one block
	dim3 threadsPerBlock(NUMOFCORES,1,1); //use N threads in the block myKernel<<<blocksPerGrid, threadsPerBlock>>>(result);
    
    checkCudaErrors(cudaMalloc((uint8_t**)&d_hostfile, (BINARYSIZE)));
    checkCudaErrors(cudaMemcpy(d_hostfile, ptr_hostfile, (BINARYSIZE), cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMalloc((uint8_t**)&d_output, OUTPUTBINARYSIZE));
    checkCudaErrors(cudaMemcpy(d_output, ptr_output, OUTPUTBINARYSIZE, cudaMemcpyHostToDevice));
 	// start the i86 opcode interpreter on the GPU   
	cudaEventRecord(start);
    decodeRecord<<<blocksPerGrid, threadsPerBlock>>>(1,1, d_hostfile, d_output); // numofcores and recordnum
	cudaEventRecord(stop);
    
    // checkCudaErrors(cudaMemcpy(ptr_hostfileCopy, d_hostfile, (TOTALBINARYSIZE), cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaMemcpy(ptr_output, d_output, OUTPUTBINARYSIZE, cudaMemcpyDeviceToHost));

    checkCudaErrors(cudaFree(d_hostfile));
    checkCudaErrors(cudaFree(d_output));
	cudaEventSynchronize(stop);

	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);


	// for ( int i = (1560000 - 1560); i < 1560000; i++ ) {
	for ( int i = 0; i < 1820; i++ ) {
		if ( (i % 140) == 0 ) printf("\n%d\t", i);
		printf("%02x ", ptr_output[i]);
	}
	printf("\n");

	FILE *out = fopen("../result.bin", "wb");
	if ( out != NULL ) {
		const size_t wrote = fwrite(ptr_output, OUTPUTBINARYSIZE, 1, out);
		printf("Datei geschrieben: %lu\n", wrote);
	}

	printf("used time in sec: %f\n", milliseconds / 1000);
	
	free(ptr_output);
	return 0;
}

int getDeltaRecords ( char* inputMasterFileName, char* inputReferenceFileName, char* outputFileName ) {
  return 0;
}

int getDeltaVariables ( char* inputMasterFileName, char* inputReferenceFileName, char* outputFileName ) {
  return 0;
}

int main ( void ) {
	printf("Starting kernel %d.\n", OUTPUTBINARYSIZE);
	decodeHF();
	printf("Kernel stopped.\n");
  return 0;
}
