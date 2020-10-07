# HFFD
Host File Fast Decode
## What is HFFD for?
HFFD reads mainframe host files encoded in formats like EBCDIC to Unicode via CUDA.
## Usage
To prepare the datasets and CUDA code the `generateHFFD.sh` is used. You need to set some environment variables:
```
export HFFD_TABLES="table1,table2" # name of the host files without extension
export RAWDATA="<path_to_host_files>"
export SAXON_HOME="/usr/local/xslt"
export SAXON="${SAXON_HOME}/saxon-he-10.2.jar"                                                                
export CUDA_HOME="<path_to_cuda>"
export DATA_MOEL="<path_to_xml>"
```
To automate this I'm using a simple `source .hffd.env` containing the local settings for CUDA, XSLT and datasets.

Run the code generation and data preparation by calling
```
./generateHFFD.sh
```
It will calculate the record size of each table by reading the related data model. Based on the record size (in Byte) it will evaluate if the file size is a factor of the record size. In the next step it will split the hostfile in chunks with the size of the defined chunk size.

The CUDA code generator will get the data structure from the data model XML and write the output to `src/cuda/record.cu`.
```CUDA
recordAddress = (threadIdx * RECORDLENGTH);
outputAddress = (threadIdx * OUTPUTRECORDLENGTH);
// DECIMAL: POLNR
bcdIntegerLength = 11;
comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, 6, 8, outputMemAddress, outputAddress, 0 );
  recordAddress = recordAddress + 6;
  outputAddress = outputAddress + 9;
  outputMemAddress[outputAddress - 1] = DELIMITER;
```
*Example of the generated CUDA code* 

Every GPU core starts with a record address calculated by it's own thread ID and the records length. From this address on the core reads the bytes needed for the decoding and calling specific function handling this data type. The result will be written to another memory block.
```
10975159;1;      ;2;      ;;       ;575962; ;1;      ;
```
*Example output of a decoded record*

At the end of the output memory block the core will write a character defined by the `DELIMITER`. This will be written also by the function itself. So in the final result there will be two columns instead of one for a field sometimes. This is to prevent memory access collision for the cores.  

## Behind the scene 
HFFD is written in C/CUDA. A hostfile is copied to the GPU memory and the CUDA kernel is configured to decode the types following the variable definition from the Cobol Copybook. 

Additionally it is able to compare two versions of a given hostfile and write only the records containing differences or only the variables which are different.
## Configuring the kernel code
The code generation will be able to create the CUDA code from a Copybook direct. It will read the variable definition, generate the CUDA code and compile the code to PTX. 
## Output format
The output format is always comma separated CSV with a linebreak. At the moment the encoding of the output is UTF-8. Strings are in quotes. Quotes and commas are escaped by a backslash. A CSV header is always given representing the name of the variable from the Copybook.

To achieve the maximum performance from the GPU cores between every field, there is another comma separated field filled with spaces (0x20) to cover the fixed width on both sides (input and output). The resulting CSV file size results in a little bit more than the original hostfile. But is significant smaller after compression even with the simplest zip algorithm.

For future releases it is planned to support formats like parquet and avro.

## API
HFFD offers a minimal library with all relevant functions:

- decodeHF(inputFp,outputFp)
- getDeltaRecords(inputCurrentFp,inputComparedToFp,outputFp)
- getDeltaVariables(inputCurrentFp,inputComparedToFp,outputFp)

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

## Code generating
The CUDA code will generated by a XSLT template. The template pareses the Copybook and writes the file cuda/hffd.cu. It translates the Copybook variable definition to the struct "recordData" and generates the content of the CUDA function "decodeRecord".  

## Compile
Complie with

`nvcc -I /Developer/NVIDIA/CUDA-9.0/samples/common/inc -o ../hffd.o src/hffd.cu`

## Performance
To demonstrate the proof of performance there is a hostfile in the sample directory with 13000 records and around 1,5 MByte filesize. On a Macbook Pro with a "GeForce GT 650M" and one gigabyte of GPU-memory it needs 0.001278 to decode the hostfile. The 650M is - compared to a state of the art 1080ti - very limited in on-device memory bandwith (30G/s vs. 600G/s) and the number of cores (384 vs. 3584). Through the limiting factor is the bandwidth, it can assumed that the same task on a 1080ti will need the same amount of time for a file 20 times bigger.  
