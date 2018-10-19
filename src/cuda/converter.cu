
__device__ static const unsigned char e2a[256] = {
          0,  1,  2,  3,156,  9,134,127,151,141,142, 11, 12, 13, 14, 15,
         16, 17, 18, 19,157,133,  8,135, 24, 25,146,143, 28, 29, 30, 31,
        128,129,130,131,132, 10, 23, 27,136,137,138,139,140,  5,  6,  7,
        144,145, 22,147,148,149,150,  4,152,153,154,155, 20, 21,158, 26,
         32,160,161,162,163,164,165,166,167,168, 91, 46, 60, 40, 43, 33,
         38,169,170,171,172,173,174,175,176,177, 93, 36, 42, 41, 59, 94,
         45, 47,178,179,180,181,182,183,184,185,124, 44, 37, 95, 62, 63,
        186,187,188,189,190,191,192,193,194, 96, 58, 35, 64, 39, 61, 34,
        195, 97, 98, 99,100,101,102,103,104,105,196,197,198,199,200,201,
        202,106,107,108,109,110,111,112,113,114,203,204,205,206,207,208,
        209,126,115,116,117,118,119,120,121,122,210,211,212,213,214,215,
        216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,
        123, 65, 66, 67, 68, 69, 70, 71, 72, 73,232,233,234,235,236,237,
        125, 74, 75, 76, 77, 78, 79, 80, 81, 82,238,239,240,241,242,243,
         92,159, 83, 84, 85, 86, 87, 88, 89, 90,244,245,246,247,248,249,
         48, 49, 50, 51, 52, 53, 54, 55, 56, 57,250,251,252,253,254,255
};

__device__ void comp3ToInt ( uint8_t *inputMemAddress, int fieldBaseAddress, int length, uint32_t *currentRecordAttr ) {
	// converting BCD to integer 
	// http://www.3480-3590-data-conversion.com/article-bcd-binary.html
	// return 0;
	currentRecordAttr[0] = inputMemAddress[fieldBaseAddress];
}

__device__ void comp3ToSignedInt ( int memAddress, int length, int *currentRecordAttr ) {
	// return 0;
}

__device__ void charToCharArray ( uint8_t *inputMemAddress, int fieldBaseAddress, int length, uint32_t *currentRecordAttr  ) {
	// converting ebcdic to ascii
	// https://stackoverflow.com/questions/7734275/c-code-to-convert-ebcdic-printables-to-ascii-in-place
	// return 0;

	currentRecordAttr[0] = e2a[inputMemAddress[fieldBaseAddress]];
}

__device__ void smallInt ( char in ) {
	// return in;
}
