#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#include <helper_cuda.h>

struct recordData
{
	uint32_t 	RECID;
	char		SYSTEMID[4];
	uint32_t	MANDID;
	char 		NAME[40];
};


// 03 RECID        PIC 9(05) COMP-3 VALUE ZERO.
// 03 MANDID       PIC 9(05) COMP-3 VALUE 10010.
// 03 POLNR        PIC 9(11) COMP-3 VALUE 0100001.
__global__ int comp3ToInt ( int memAddress, int length, int *currentRecordAttr ) {
	// converting BCD to integer 
	// http://www.3480-3590-data-conversion.com/article-bcd-binary.html
	char byteOne, byteTwo, byteThree, byteFour, byteFive;
	byteOne 	= memAddress[0];
	byteTwo 	= memAddress[1];
	byteThree 	= memAddress[2];
	byteFour 	= memAddress[3];
	byteFive 	= memAddress[4];
	return 0;
}

// 03 SYSTEMID     PIC X(04) VALUE 'S085'.
// 03 NAME         PIC X(40) VALUE 'MAX MUSTER'.
__global__ int charToCharArray ( int memAddress, int length ) {
	// converting ebcdic to ascii
	// https://stackoverflow.com/questions/7734275/c-code-to-convert-ebcdic-printables-to-ascii-in-place
	return 0;
}

__global__ char smallInt ( char in ) {
	return in;
}

__global__ void writeRecordToMemory ( int *currentRecord ) {
	return 0;
}

__global__ void decodeRecord ( int numOfCores, int recordNum ) {
	int inMemAddressBase;
	struct recordData theRecord;
	comp3ToInt ( inMemAddressBase, 5, &theRecord.RECID );
		inMemAddressBase = inMemAddressBase + 5; 
	charToCharArray ( inMemAddressBase, 4, &theRecord.SYSTEMID );
		inMemAddressBase = inMemAddressBase + 4; 
	comp3ToInt ( inMemAddressBase, 5, &theRecord.MANDID );
		inMemAddressBase = inMemAddressBase + 5; 
	charToCharArray ( inMemAddressBase, 40, &theRecord.NAME );
		inMemAddressBase = inMemAddressBase + 40; 
	comp3ToInt ( inMemAddressBase, 11, &theRecord.MANDID );
		inMemAddressBase = inMemAddressBase + 11; 
}
