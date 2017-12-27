<!-- Q1 -->
<!-- Create a summarized version of the EE part of the course catalog. For each course in EE, return a Course element, with its Number and Title as attributes, its Description as a subelement, and the last name of each instructor as an Instructor subelement. Discard all information about department titles, chairs, enrollment, and prerequisites, as well as all courses in departments other than EE. (Note: To specify quotes within an already-quoted XPath expression, use quot;.) 
 -->
<?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="//Department[@Code = 'EE']/Course">
            <Course Number ="{data(@Number)}" Title="{Title}">
            <xsl:copy-of select="Description"/>
            <xsl:for-each select="Instructors/*">
                <Instructor><xsl:value-of select="Last_Name"/></Instructor>
            </xsl:for-each>
            </Course>
        </xsl:template>
        <xsl:template match="text()"/> 
    </xsl:stylesheet>
<!-- Q2 -->
<!-- Create an HTML table with one-pixel border that lists all CS department courses with enrollment greater than 200. Each row should contain three cells: the course number in italics, course title in bold, and enrollment. Sort the rows alphabetically by course title. No header is needed. (Note: For formatting, just use "table border=1", and "<b>" and "<i>" tags for bold and italics respectively. To specify quotes within an already-quoted XPath expression, use quot;.) -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="//Department[@Code = 'CS']">
        <html>
        <table border = "1">
            <th>Course Number</th>
            <th>Course Title</th>
            <th>Enrollment</th>
            <xsl:for-each select="Course[@Enrollment > 200]">
            <xsl:sort select="Title"/>
                <tr>
                <td><i><xsl:value-of select="@Number"/></i></td>
                <td><b><xsl:value-of select="Title"/></b></td>
                <td><xsl:value-of select="@Enrollment"/></td>
                </tr>
            </xsl:for-each>
        </table>
        </html>
    </xsl:template>
    <xsl:template match="text()"/> 
</xsl:stylesheet>