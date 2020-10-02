#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
NC='\033[0m'
declare chunk=10000

errorcounter=0
successcounter=0

# TARGETPATH is used in generateStructures, generateMaps and processItemTemplate as root directory of the generated Talend files
declare TARGETPATH="."
# set the table names via export HFFD_TABLES="table1,table2"
declare -a arr=$HFFD_TABLES 
declare RAWDATA="${TARGETPATH}/sample"
declare SAXON="/usr/local/xslt/saxon-he-10.2.jar"
declare CUDA_HOME="/usr/local/cuda-11.1"
filepostfix="" # "-SHORT"$chunk


echo " " >> error.log

for table in $(echo $arr | sed "s/,/ /g")
do
    blocksize=`java -jar ${SAXON} table-name="$table" sample/tables-datamodel.xml xslt/getRecordLength.xslt`
echo "java -jar ${SAXON} table-name="$table" sample/tables-datamodel.xml xslt/getRecordLength.xslt"
    filesize=`stat -c %s  ${RAWDATA}/$table.bin`

    if [ "$filesize" -eq "0" ]; then
	errorcounter=$((errorcounter+1))
	echo "Error[$errorcounter]:	filesize is zero  for table $table"  >>  error.log
    else
    if [ -z "$blocksize" ]; then
	errorcounter=$((errorcounter+1))
	echo "Error[$errorcounter]:	blocksize empty for  table $table" >> error.log
    else
	re='^[0-9]+$'
	if ! [[ $blocksize =~ $re ]] ; then
	    errorcounter=$((errorcounter+1))

	#   echo "Error[$errorcounter]: blocksize(${blocksize}) is not an int for $table" >> error.log

	else
		if [ $(( $filesize % $blocksize )) -eq 0 ]; then
		    echo "$filesize divisible by $blocksize."


		    echo -e "Resize data file of ${BLUE}"$table"${NC} to "$chunk" records with a blocksize of ${ORANGE}"$blocksize"${NC} each"

		    dd bs=$blocksize if=${RAWDATA}/$table.bin of=${TARGETPATH}/rawdata/$table-$chunk.txt count=$chunk # 2> /dev/null

		    echo -e "Generate CUDA code at ${GREEN}src/cuda/record.cu${NC}"
		    

		    realchunk=$chunk
		    newchunk=`echo $((filesize / blocksize))`
		    # echo "test $newchunk"
		    if [ "$newchunk" -lt "$realchunk" ]; then
		       echo "WARNING: less than $chunk ($newchunk for real) records available!" >> error.log
		       # echo "java -Xmx8192m -jar ${SAXON} table=$table numberofrecords=$newchunk sample/tables-datamodel.xml xslt/generateRecordCUDA.xslt > src/cuda/record.cu"
		       java -Xmx8192m -jar ${SAXON} table=$table numberofrecords=$newchunk sample/tables-datamodel.xml xslt/generateRecordCUDA.xslt > src/cuda/record.cu
		    else
			# echo "java -Xmx8192m -jar ${SAXON} table=$table numberofrecords=$chunk sample/tables-datamodel.xml xslt/generateRecordCUDA.xslt > src/cuda/record.cu"
			java -Xmx8192m -jar ${SAXON} table=$table numberofrecords=$chunk sample/tables-datamodel.xml xslt/generateRecordCUDA.xslt > src/cuda/record.cu
		    fi	

		    echo -e "Compile CUDA code to ${GREEN}../hffd-$table.o${NC}"

		    nvcc -I${CUDA_HOME}/samples/common/inc -o ../hffd-$table.o src/hffd.cu

		    echo -e "Run program ${GREEN}../hffd-$table.o${NC}"

		    echo -e "${RED}"

		    ../hffd-$table.o ${TARGETPATH}/rawdata/$table-$chunk.txt ${TARGETPATH}/decodeddata/$table-$chunk.csv

		    retVal=$?
		    if [ $retVal -ne 0 ]; then
		       errorcounter=$((errorcounter+1))
		       echo "Error[$errorcounter]:	CUDA failed for $table"  >> error.log
		    else
			successcounter=$((successcounter+1))
			echo  "Success[$successcounter]: $table" >> error.log
		    fi
		    
		    echo "Success $table"
		    echo -e "${NC}${BLUE}"

		    head ${TARGETPATH}/decodeddata/$table-$chunk.csv

		    echo -e "${NC}"
		else
			errorcounter=$((errorcounter+1))
			echo "Error[$errorcounter]:	unaligned size $table $filesize / $blocksize" >> error.log
		fi
	   fi
      fi
fi
done


