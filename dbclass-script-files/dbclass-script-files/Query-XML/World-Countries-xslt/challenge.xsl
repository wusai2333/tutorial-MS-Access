<!-- Q1 -->
<!-- Create a table using HTML constructs that lists all countries that have more than 3 languages. Each row should contain the country name in bold, population, area, and number of languages. Sort the rows in descending order of number of languages. No header is needed for the table, but use <table border="1"> to make it format nicely, should you choose to check your result in a browser. (Hint: You may find the data-type and order attributes of <xsl:sort> to be useful.)  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="//countries">
        <html>
        <table border = "1">
            <th>Country Name</th>
            <th>Population</th>
            <th>Area</th>
            <th>Number of Languages</th>
            <xsl:for-each select="country[count(language) > 3]">
            <xsl:sort order="descending" select="count(language)"/>
                <tr>
                <td><b><xsl:value-of select="@name"/></b></td>
                <td><xsl:value-of select="@population"/></td>
                <td><xsl:value-of select="@area"/></td>
                <td><xsl:value-of select="count(language)"/></td>
                </tr>
            </xsl:for-each>
        </table>
        </html>
    </xsl:template>
    <xsl:template match="text()"/> 
</xsl:stylesheet>

<!-- Q2 -->
<!-- Create an alternate version of the countries database: for each country, include its name and population as sublements, and the number of languages and number of cities as attributes (called "languages" and "cities" respectively).  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match='/'>
    <countries>
      <xsl:apply-templates />
    </countries>
    </xsl:template>
    <xsl:template match="country">
       <country languages="count(language)" cities="{count(city)}">
       <name><xsl:value-of select="@name"/></name>
       <population><xsl:value-of select="@population"/></population>
       </country>
    </xsl:template>
    <xsl:template match="text()"/> 
</xsl:stylesheet>