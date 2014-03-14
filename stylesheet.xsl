<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="Datasets">
    <xsl:for-each select="Dataset">
      <xsl:value-of select="UTCTime"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="Address"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="UID"/>
      <xsl:if test="not(position() = last())">
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
  </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
