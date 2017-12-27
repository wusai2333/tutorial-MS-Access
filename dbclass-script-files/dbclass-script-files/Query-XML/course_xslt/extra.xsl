<!-- Q1 -->
<!-- Return all courses with enrollment greater than 500. Retain the structure of Course elements from the original data. -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="//Course[@Enrollment > 500]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()"/> 
</xsl:stylesheet>

<!-- Q2 -->
<!-- Remove from the data all courses with enrollment greater than 60, or with no enrollment listed. Otherwise the structure of the data should be the same. -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="*|@*|text()">
         <xsl:copy>
             <xsl:apply-templates select="*|@*|text()"/>
         </xsl:copy>
    </xsl:template>
    <xsl:template match="//Course[@Enrollment &gt; 60]"/>
    <xsl:template match="//Course[count(@Enrollment) &lt; 1]"/>
    
</xsl:stylesheet>