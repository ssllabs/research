<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:d="http://docbook.org/ns/docbook"
    exclude-result-prefixes="d" version="1.0">

    <xsl:import href="whitepaper.xsl" />
		
    <xsl:param name="fd.body.font.family">Minion</xsl:param>	
    <xsl:param name="fd.title.font.family">Trade Gothic Condensed</xsl:param>
    
    <xsl:param name="body.font.master">13</xsl:param>
    <xsl:param name="line-height">1.3</xsl:param>

    <xsl:attribute-set name="section.title.level1.properties">
        <xsl:attribute name="font-size">20pt</xsl:attribute>        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-size">18pt</xsl:attribute>        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-size">14pt</xsl:attribute>        
    </xsl:attribute-set>
	
</xsl:stylesheet>
