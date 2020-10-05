<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:param name="table-name" select="'AGBASISWERTE'"/>
  <xsl:param name="numberofrecords" select="1000000"/>
  <xsl:template match="/*">
    <xsl:apply-templates select="//table[@name = $table-name]"/>
  </xsl:template>

    <xsl:template match="table"><xsl:value-of select="floor(
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
	    + (count(field[@type = ('TIMESTMP')]) * 26)
            "/>
    </xsl:template>
</xsl:stylesheet>
