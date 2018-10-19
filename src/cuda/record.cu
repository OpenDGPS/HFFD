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

struct recordData
{
	// 03 RECID        PIC 9(05) COMP-3 VALUE ZERO.
	uint32_t 	RECID;
	// 03 SYSTEMID     PIC X(04) VALUE 'S085'.
	char		SYSTEMID[4];
	// 03 MANDID       PIC 9(05) COMP-3 VALUE 10010.
	uint32_t	MANDID;
	// 03 NAME         PIC X(40) VALUE 'MAX MUSTER'.
	char 		NAME[40];
	// 03 POLNR        PIC 9(11) COMP-3 VALUE 0100001.
	uint32_t 	POLNR;
	// 03 RISPA        PIC 9(03) COMP-3 VALUE 207.
	uint32_t 	RISPA;
	// 03 WAEHR        PIC X(03) VALUE 'EUR'.
	char 		WAEHR[3];
	// 03 PRAEMIE      PIC S9(9)V99 COMP-3 VALUE 228.30.
	int32_t		PRAEMIE;
	// 03 INFO         PIC X(50) VALUE 'ICH BIN EIN SATZ.'.
	char 		INFO[50];
	// 03 ENDE         PIC X(03) VALUE LOW-VALUE.
	char 		END[3];
};


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
	comp3ToInt ( inMemAddressBase, 11, &theRecord.POLNR );
		inMemAddressBase = inMemAddressBase + 11; 
	comp3ToInt ( inMemAddressBase, 3, &theRecord.RISPA );
		inMemAddressBase = inMemAddressBase + 3; 
	charToCharArray ( inMemAddressBase, 3, &theRecord.WAEHR );
		inMemAddressBase = inMemAddressBase + 3; 
	comp3ToSignedInt ( inMemAddressBase, 9, &theRecord.PRAEMIE );
		inMemAddressBase = inMemAddressBase + 9; 
	charToCharArray ( inMemAddressBase, 50, &theRecord.INFO );
		inMemAddressBase = inMemAddressBase + 50; 
	charToCharArray ( inMemAddressBase, 3, &theRecord.ENDE );
		inMemAddressBase = inMemAddressBase + 3; 

}
