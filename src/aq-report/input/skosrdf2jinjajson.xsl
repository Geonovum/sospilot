<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
    <xsl:output method='text' version='1.0' encoding='UTF-8' indent='yes'/>    
    <xsl:template match="/">
        "<xsl:value-of select="rdf:RDF/skos:ConceptScheme/skos:notation"/>_defs":    {       
            <xsl:for-each select="rdf:RDF/skos:Concept">
                "<xsl:value-of select="./skos:notation"/>" : "<xsl:value-of select="@rdf:about"/>"<xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        
        }
    </xsl:template>
</xsl:stylesheet>