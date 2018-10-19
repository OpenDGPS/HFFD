
__device__ void comp3ToInt ( int memAddress, int length, uint32_t *currentRecordAttr ) {
	// converting BCD to integer 
	// http://www.3480-3590-data-conversion.com/article-bcd-binary.html
	// return 0;
}

__device__ void comp3ToSignedInt ( int memAddress, int length, int *currentRecordAttr ) {
	// return 0;
}

__device__ void charToCharArray ( int memAddress, int length, char *currentRecordAttr  ) {
	// converting ebcdic to ascii
	// https://stackoverflow.com/questions/7734275/c-code-to-convert-ebcdic-printables-to-ascii-in-place
	// return 0;
}

__device__ void smallInt ( char in ) {
	// return in;
}
