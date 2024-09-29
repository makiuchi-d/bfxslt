<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0">
  <xsl:output method="html" encoding="utf-8"/>

  <xsl:template match="/bf">
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="ptr" select="0"/>
      <xsl:with-param name="mem"><_0>0</_0></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ">" move ptr right -->
  <xsl:template match="mvr">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr + 1"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "<" move ptr left -->
  <xsl:template match="mvl">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr - 1"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "+" increment -->
  <xsl:template match="inc">
    <xsl:param name="ptr" />
    <xsl:param name="mem"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>
    <xsl:variable name="val" select="sum($mem/*[name()=$key])"/>

    <xsl:variable name="mem">
      <xsl:for-each select="$mem/*[name()!=$key]">
        <xsl:copy-of select="."/>
      </xsl:for-each>
      <xsl:element name="{$key}">
        <xsl:value-of select="$val + 1"/>
      </xsl:element>
    </xsl:variable>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "-" decrement -->
  <xsl:template match="dec">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>
    <xsl:variable name="val" select="sum($mem/*[name()=$key])"/>

    <xsl:variable name="mem">
      <xsl:for-each select="$mem/*[name()!=$key]">
        <xsl:copy-of select="."/>
      </xsl:for-each>
      <xsl:element name="{$key}">
        <xsl:value-of select="$val - 1"/>
      </xsl:element>
    </xsl:variable>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "[" loop -->
  <xsl:template match="loop">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>
    <xsl:variable name="val" select="sum($mem/*[name()=$key])"/>

    <xsl:choose>
      <xsl:when test="$val != 0">
        <xsl:apply-templates select="*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem" select="$mem"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="following-sibling::*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem" select="$mem"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- "]" loop end -->
  <xsl:template match="end">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:apply-templates select="parent::node()">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "." print -->
  <xsl:template match="print">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>
    <xsl:variable name="val" select="sum($mem/*[name()=$key])"/>
    <xsl:value-of select="codepoints-to-string(xs:integer($val))" />

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
