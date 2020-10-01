<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:param name="table" select="'TABLE_NAME_FROM_CMD_LINE'"/>
  <xsl:param name="numberofrecords" select="1000000"/>
  <xsl:template match="/*">
    <xsl:apply-templates select="//table[@name = $table]"/>
  </xsl:template>
  <xsl:template match="table">
    <!--
	The following XSLT generates CUDA (.cu) code.
	This XSLT-file is NOT generated. Please don't mix up.
    -->
    <xsl:text>
/*****************************************************************/
/*               THIS FILE WILL BE GENERATED                     */
/*                        DO NOT EDIT!                           */
/*****************************************************************/

#include &lt;stdio.h&gt;
#include &lt;stdint.h&gt;
#include &lt;cuda_runtime.h&gt;
#include &lt;helper_cuda.h&gt;

    </xsl:text>
    <xsl:value-of select="concat('&#10;#define NUMOFRECORDS ',$numberofrecords)"/>
    <xsl:value-of select="concat('&#10;#define RECORDLENGTH ',floor(
        (
        sum(field[@type = 'DECIMAL']/@length) 
        + count(field[@type = 'DECIMAL'])
        ) 
        div 2
        )  
            + sum(field[@type = ('CHAR')]/@length) 
            + (sum(field[@type = ('INTEGER')]/@length)) 
            + (sum(field[@type = ('SMALLINT')]/@length))
            + (sum(field[@type = ('DATE')]/@length) * 2)
            + (sum(field[@type = ('VARCHAR')]/@length))
            + (count(field[@type = ('VARCHAR')]) * 2)
	    + (count(field[@type = ('TIMESTMP')]) * 26))"/>
    <xsl:value-of select="concat('&#10;#define OUTPUTRECORDLENGTH ',(count(field[@type = 'DECIMAL']) * 9) + sum(field[@type = ('CHAR')]/@length) + count(field[@type = ('CHAR')]) + 2 + (count(field[@type = ('INTEGER')]) * 5) )"/>
    <xsl:text> 
#define BINARYSIZE RECORDLENGTH * NUMOFRECORDS 
#define OUTPUTBINARYSIZE OUTPUTRECORDLENGTH * NUMOFRECORDS
#define NUMOFCORES 1024
</xsl:text>
    <xsl:text>
#define BLOCKSPERGRID 1024

#define DELIMITER 0x3b
#define COMMA 0x2c

#include "converter.cu"

__device__ int getGlobalIdx_1D_1D() {
	return blockIdx.x *blockDim.x + threadIdx.x;
}

__device__ int getGlobalIdx_1D_2D() {
	return blockIdx.x * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
}

__global__ void decodeRecord ( uint8_t *inputMemAddress , uint8_t *outputMemAddress ) {
	int recordAddress,outputAddress;
	int threadIdx;
	int bcdIntegerLength = 0;
	threadIdx = getGlobalIdx_1D_2D(); // getGlobalIdx_1D_1D();
	if (threadIdx &lt; NUMOFRECORDS ) {
		recordAddress = (threadIdx * RECORDLENGTH);
		outputAddress = (threadIdx * OUTPUTRECORDLENGTH);

    </xsl:text>
    <xsl:apply-templates select="field"/>
    <xsl:text>
			outputMemAddress[outputAddress] = 0x0d;
			outputMemAddress[outputAddress + 1] = 0x0a;
	}

}
      
    </xsl:text>
  </xsl:template>
  <xsl:template match="field[@type = 'DECIMAL']">
    <xsl:value-of select="concat('&#9;&#9;// DECIMAL: ',@name,'&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;bcdIntegerLength = ',@length,';&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;comp3ToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, ',ceiling(@length div 2),', 8, outputMemAddress, outputAddress, 0 );&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;&#9;recordAddress = recordAddress + ',ceiling(@length div 2),';&#10;')"/>
    <xsl:value-of select="'&#9;&#9;&#9;outputAddress = outputAddress + 9;&#10;'"/>
    <xsl:value-of select="'&#9;&#9;&#9;outputMemAddress[outputAddress - 1] = DELIMITER;&#10;'"/>
  </xsl:template>
  <xsl:template match="field[@type = 'CHAR']">
    <xsl:value-of select="concat('&#9;&#9;// CHAR: ',@name,'&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;charToCharArray ( inputMemAddress, recordAddress, ',@length,', outputMemAddress, outputAddress);&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;&#9;recordAddress = recordAddress + ',@length,';&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;&#9;outputAddress = outputAddress + ',@length + 1,';&#10;')"/>
    <xsl:value-of select="'&#9;&#9;&#9;outputMemAddress[outputAddress - 1] = DELIMITER;&#10;'"/>
  </xsl:template>
  <xsl:template match="field[@type = 'INTEGER']">
    <xsl:value-of select="concat('&#9;&#9;// INTEGER: ',@name,'&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;compToIntSerial ( inputMemAddress, recordAddress, bcdIntegerLength, ',ceiling(@length div 2),', 8, outputMemAddress, outputAddress, 0 );&#10;')"/>
    <xsl:value-of select="concat('&#9;&#9;&#9;recordAddress = recordAddress + ',4,';&#10;')"/>
    <xsl:value-of select="'&#9;&#9;&#9;outputAddress = outputAddress + 5;&#10;'"/>
    <xsl:value-of select="'&#9;&#9;&#9;outputMemAddress[outputAddress - 1] = DELIMITER;&#10;'"/>
  </xsl:template>
</xsl:stylesheet>
