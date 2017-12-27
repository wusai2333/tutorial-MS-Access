<!-- Q1 -->
<!-- Remove from the data all countries with area greater than 40,000 and all countries with no cities listed. Otherwise the structure of the data should be the same. 
 -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="*|@*|text()">
         <xsl:copy>
             <xsl:apply-templates select="*|@*|text()"/>
         </xsl:copy>
    </xsl:template>
    <xsl:template match="//country[@area &gt; 40000]"/>
    <xsl:template match="//country[count(city) &lt; 1]"/>
    
</xsl:stylesheet>