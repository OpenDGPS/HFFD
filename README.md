# HFFD
Host File Fast Decode
## What is HFFD for?
HFFD reads mainframe host files encoded in formats like EBCDIC to Unicode via CUDA.
## How it works
HFFD is written in C/CUDA. A hostfile is copied to the GPU memory and the CUDA kernel is configured to decode the types following the variable definition from the Cobol Copybook. 

Additionally it is able to compare two versions of a given hostfile and write only the records containing differences or only the variables which are different.
## Configuring the kernel code
The code generation will be able to create the CUDA code from a Copybook direct. It will read the variable definition, generate the CUDA code and compile the code to PTX. 
## Output format
The output format is always comma separated CSV with a linebreak. At the moment the encoding of the output is UTF-8. Strings are in quotes. Quotes and commas are escaped by a backslash. A CSV header is always given representing the name of the variable from the Copybook.

To achieve the maximum performance from the GPU cores between every field there is another comma separated field filled with spaces (0x20) to cover the fixed width on both sides (input and output). The resulting CSV file size results in a little bit more than the original hostfile. But is significant smaller after compression even with the simpliest zip algorithm.

For future releases it is planned to support formats like parquet and avro.

## API
HFFD offers a minimal library with all relevant functions:

- decodeHF(*inputFp,*outputFp)
- getDeltaRecords(*inputCurrentFp,*inputComparedToFp,*outputFp)
- getDeltaVariables(*inputCurrentFp,*inputComparedToFp,*outputFp)

### decodeHF
decodeHF gets a file pointer with the content of the original hostfile. It writes the decoded content to the file given by the outputFp. It returns a return code (0 for success or a int for an error code).
### getDeltaRecords
getDeltaRecords gets one file pointer with the content of the hostfile which is the master. The second file contains the reference content. The output file will contain all records from the master file which differs from the same record number of the reference file. Every record will start with a new column which contains a long long unsigned int (128 bit) representing the number of the record in the master hostfile. 

The delta method makes only sense if the records are in the same order. Currently there is no way to find a corresponding record by a key or index.
### getDeltaVariables
getDeltaVariables gets one file pointer with the content of the hostfile which is the master. The second file contains the reference content. The output file will contain all fields from the master file which differs from the same record number of the reference file. Every record will start with a new column which contains a long long unsigned int (128 bit) representing the number of the record in the master hostfile. In difference to getDeltaRecords, all variables not differing from the master will be empty.

The delta method makes only sense if the records are in the same order. Currently there is no way to find a corresponding record by a key or index.

### C interface
The code can be compiled as a library via nvcc.
