<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version="1.0">
  <xsl:output method="text" encoding="utf-8"/>

  <xsl:template match="/bf">
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="ptr" select="0"/>
      <xsl:with-param name="mem"><_0>0</_0></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ">" move ptr to the right -->
  <xsl:template match="right">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr + 1"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "<" move ptr to the left -->
  <xsl:template match="left">
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
    <xsl:variable name="val" select="sum(exsl:node-set($mem)/*[name()=$key])"/>

    <xsl:variable name="mem">
      <xsl:call-template name="write-val">
        <xsl:with-param name="mem" select="$mem"/>
        <xsl:with-param name="key" select="$key"/>
        <xsl:with-param name="val" select="$val + 1"/>
      </xsl:call-template>
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
    <xsl:variable name="val" select="sum(exsl:node-set($mem)/*[name()=$key])"/>

    <xsl:variable name="mem">
      <xsl:call-template name="write-val">
        <xsl:with-param name="mem" select="$mem"/>
        <xsl:with-param name="key" select="$key"/>
        <xsl:with-param name="val" select="$val - 1"/>
      </xsl:call-template>
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
    <xsl:variable name="val" select="sum(exsl:node-set($mem)/*[name()=$key])"/>

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
    <xsl:variable name="val" select="sum(exsl:node-set($mem)/*[name()=$key])"/>

    <xsl:choose>
      <xsl:when test="$val=9"><xsl:text>&#9;</xsl:text></xsl:when> 
      <xsl:when test="$val=10"><xsl:text>&#10;</xsl:text></xsl:when>
      <xsl:when test="$val=13"><xsl:text>&#13;</xsl:text></xsl:when>
      <xsl:when test="$val=32"><xsl:text disable-output-escaping="yes"> </xsl:text></xsl:when>
      <xsl:when test="$val=33">!</xsl:when>
      <xsl:when test="$val=34">&quot;</xsl:when>
      <xsl:when test="$val=35">#</xsl:when>
      <xsl:when test="$val=36">$</xsl:when>
      <xsl:when test="$val=37">%</xsl:when>
      <xsl:when test="$val=38">&amp;</xsl:when>
      <xsl:when test="$val=39">&apos;</xsl:when>
      <xsl:when test="$val=40">(</xsl:when>
      <xsl:when test="$val=41">)</xsl:when>
      <xsl:when test="$val=42">*</xsl:when>
      <xsl:when test="$val=43">+</xsl:when>
      <xsl:when test="$val=44">,</xsl:when>
      <xsl:when test="$val=45">-</xsl:when>
      <xsl:when test="$val=46">.</xsl:when>
      <xsl:when test="$val=47">/</xsl:when>
      <xsl:when test="$val=48">0</xsl:when>
      <xsl:when test="$val=49">1</xsl:when>
      <xsl:when test="$val=50">2</xsl:when>
      <xsl:when test="$val=51">3</xsl:when>
      <xsl:when test="$val=52">4</xsl:when>
      <xsl:when test="$val=53">5</xsl:when>
      <xsl:when test="$val=54">6</xsl:when>
      <xsl:when test="$val=55">7</xsl:when>
      <xsl:when test="$val=56">8</xsl:when>
      <xsl:when test="$val=57">9</xsl:when>
      <xsl:when test="$val=58">:</xsl:when>
      <xsl:when test="$val=59">;</xsl:when>
      <xsl:when test="$val=60">&lt;</xsl:when>
      <xsl:when test="$val=61">=</xsl:when>
      <xsl:when test="$val=62">&gt;</xsl:when>
      <xsl:when test="$val=63">?</xsl:when>
      <xsl:when test="$val=64">@</xsl:when>
      <xsl:when test="$val=65">A</xsl:when>
      <xsl:when test="$val=66">B</xsl:when>
      <xsl:when test="$val=67">C</xsl:when>
      <xsl:when test="$val=68">D</xsl:when>
      <xsl:when test="$val=69">E</xsl:when>
      <xsl:when test="$val=70">F</xsl:when>
      <xsl:when test="$val=71">G</xsl:when>
      <xsl:when test="$val=72">H</xsl:when>
      <xsl:when test="$val=73">I</xsl:when>
      <xsl:when test="$val=74">J</xsl:when>
      <xsl:when test="$val=75">K</xsl:when>
      <xsl:when test="$val=76">L</xsl:when>
      <xsl:when test="$val=77">M</xsl:when>
      <xsl:when test="$val=78">N</xsl:when>
      <xsl:when test="$val=79">O</xsl:when>
      <xsl:when test="$val=80">P</xsl:when>
      <xsl:when test="$val=81">Q</xsl:when>
      <xsl:when test="$val=82">R</xsl:when>
      <xsl:when test="$val=83">S</xsl:when>
      <xsl:when test="$val=84">T</xsl:when>
      <xsl:when test="$val=85">U</xsl:when>
      <xsl:when test="$val=86">V</xsl:when>
      <xsl:when test="$val=87">W</xsl:when>
      <xsl:when test="$val=88">X</xsl:when>
      <xsl:when test="$val=89">Y</xsl:when>
      <xsl:when test="$val=90">Z</xsl:when>
      <xsl:when test="$val=91">[</xsl:when>
      <xsl:when test="$val=92">\</xsl:when>
      <xsl:when test="$val=93">]</xsl:when>
      <xsl:when test="$val=94">^</xsl:when>
      <xsl:when test="$val=95">_</xsl:when>
      <xsl:when test="$val=96">`</xsl:when>
      <xsl:when test="$val=97">a</xsl:when>
      <xsl:when test="$val=98">b</xsl:when>
      <xsl:when test="$val=99">c</xsl:when>
      <xsl:when test="$val=100">d</xsl:when>
      <xsl:when test="$val=101">e</xsl:when>
      <xsl:when test="$val=102">f</xsl:when>
      <xsl:when test="$val=103">g</xsl:when>
      <xsl:when test="$val=104">h</xsl:when>
      <xsl:when test="$val=105">i</xsl:when>
      <xsl:when test="$val=106">j</xsl:when>
      <xsl:when test="$val=107">k</xsl:when>
      <xsl:when test="$val=108">l</xsl:when>
      <xsl:when test="$val=109">m</xsl:when>
      <xsl:when test="$val=110">n</xsl:when>
      <xsl:when test="$val=111">o</xsl:when>
      <xsl:when test="$val=112">p</xsl:when>
      <xsl:when test="$val=113">q</xsl:when>
      <xsl:when test="$val=114">r</xsl:when>
      <xsl:when test="$val=115">s</xsl:when>
      <xsl:when test="$val=116">t</xsl:when>
      <xsl:when test="$val=117">u</xsl:when>
      <xsl:when test="$val=118">v</xsl:when>
      <xsl:when test="$val=119">w</xsl:when>
      <xsl:when test="$val=120">x</xsl:when>
      <xsl:when test="$val=121">y</xsl:when>
      <xsl:when test="$val=122">z</xsl:when>
      <xsl:when test="$val=123">{</xsl:when>
      <xsl:when test="$val=124">|</xsl:when>
      <xsl:when test="$val=125">}</xsl:when>
      <xsl:when test="$val=126">~</xsl:when>
      <xsl:otherwise>&amp;#<xsl:value-of select="$val"/>;</xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="write-val">
    <xsl:param name="mem"/>
    <xsl:param name="key"/>
    <xsl:param name="val"/>

    <xsl:for-each select="exsl:node-set($mem)/*[name()!=$key]">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    <xsl:element name="{$key}">
      <xsl:value-of select="$val"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
