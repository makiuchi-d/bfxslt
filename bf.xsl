<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version="1.0">
  <xsl:output method="text" encoding="utf-8"/>

  <xsl:template match="/bf">
    <xsl:variable name="input" select="input"/>
    <xsl:apply-templates select="code/*[1]">
      <xsl:with-param name="ptr" select="0"/>
      <xsl:with-param name="mem"><_0>0</_0></xsl:with-param>
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ">" move ptr to the right -->
  <xsl:template match="right">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr + 1"/>
      <xsl:with-param name="mem" select="$mem"/>
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "<" move ptr to the left -->
  <xsl:template match="left">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="ptr" select="$ptr - 1"/>
      <xsl:with-param name="mem" select="$mem"/>
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "+" increment -->
  <xsl:template match="inc">
    <xsl:param name="ptr" />
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

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
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "-" decrement -->
  <xsl:template match="dec">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

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
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "[" loop -->
  <xsl:template match="loop">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>
    <xsl:variable name="val" select="sum(exsl:node-set($mem)/*[name()=$key])"/>

    <xsl:choose>
      <xsl:when test="$val != 0">
        <xsl:apply-templates select="*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem" select="$mem"/>
          <xsl:with-param name="input" select="$input"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="following-sibling::*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem" select="$mem"/>
          <xsl:with-param name="input" select="$input"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- "]" loop end -->
  <xsl:template match="end">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

    <xsl:apply-templates select="parent::node()">
      <xsl:with-param name="ptr" select="$ptr"/>
      <xsl:with-param name="mem" select="$mem"/>
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "." print -->
  <xsl:template match="print">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

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
      <xsl:with-param name="input" select="$input"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "," read -->
  <xsl:template match="read">
    <xsl:param name="ptr"/>
    <xsl:param name="mem"/>
    <xsl:param name="input"/>

    <xsl:variable name="key" select="concat('_', $ptr)"/>

    <xsl:choose>
      <xsl:when test="string-length($input)=0">
        <xsl:apply-templates select="following-sibling::*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem">
            <xsl:call-template name="write-val">
              <xsl:with-param name="mem" select="$mem"/>
              <xsl:with-param name="key" select="$key"/>
              <xsl:with-param name="val" select="255"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="input" select="$input"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="c" select="substring($input, 1, 1)"/>
        <xsl:variable name="input" select="substring($input, 2)"/>

        <xsl:variable name="val">
          <xsl:choose>
            <xsl:when test="$c='&#9;'">9</xsl:when>
            <xsl:when test="$c='&#10;'">10</xsl:when>
            <xsl:when test="$c='&#13;'">13</xsl:when>
            <xsl:when test="$c=' '">32</xsl:when>
            <xsl:when test="$c='!'">33</xsl:when>
            <xsl:when test="$c='&quot;'">34</xsl:when>
            <xsl:when test="$c='#'">35</xsl:when>
            <xsl:when test="$c='$'">36</xsl:when>
            <xsl:when test="$c='%'">37</xsl:when>
            <xsl:when test="$c='&amp;'">38</xsl:when>
            <xsl:when test='$c="&apos;"'>39</xsl:when>
            <xsl:when test="$c='('">40</xsl:when>
            <xsl:when test="$c=')'">41</xsl:when>
            <xsl:when test="$c='*'">42</xsl:when>
            <xsl:when test="$c='+'">43</xsl:when>
            <xsl:when test="$c=','">44</xsl:when>
            <xsl:when test="$c='-'">45</xsl:when>
            <xsl:when test="$c='.'">46</xsl:when>
            <xsl:when test="$c='/'">47</xsl:when>
            <xsl:when test="$c='0'">48</xsl:when>
            <xsl:when test="$c='1'">49</xsl:when>
            <xsl:when test="$c='2'">50</xsl:when>
            <xsl:when test="$c='3'">51</xsl:when>
            <xsl:when test="$c='4'">52</xsl:when>
            <xsl:when test="$c='5'">53</xsl:when>
            <xsl:when test="$c='6'">54</xsl:when>
            <xsl:when test="$c='7'">55</xsl:when>
            <xsl:when test="$c='8'">56</xsl:when>
            <xsl:when test="$c='9'">57</xsl:when>
            <xsl:when test="$c=':'">58</xsl:when>
            <xsl:when test="$c=';'">59</xsl:when>
            <xsl:when test="$c='&lt;'">60</xsl:when>
            <xsl:when test="$c='='">61</xsl:when>
            <xsl:when test="$c='&gt;'">62</xsl:when>
            <xsl:when test="$c='?'">63</xsl:when>
            <xsl:when test="$c='@'">64</xsl:when>
            <xsl:when test="$c='A'">65</xsl:when>
            <xsl:when test="$c='B'">66</xsl:when>
            <xsl:when test="$c='C'">67</xsl:when>
            <xsl:when test="$c='D'">68</xsl:when>
            <xsl:when test="$c='E'">69</xsl:when>
            <xsl:when test="$c='F'">70</xsl:when>
            <xsl:when test="$c='G'">71</xsl:when>
            <xsl:when test="$c='H'">72</xsl:when>
            <xsl:when test="$c='I'">73</xsl:when>
            <xsl:when test="$c='J'">74</xsl:when>
            <xsl:when test="$c='K'">75</xsl:when>
            <xsl:when test="$c='L'">76</xsl:when>
            <xsl:when test="$c='M'">77</xsl:when>
            <xsl:when test="$c='N'">78</xsl:when>
            <xsl:when test="$c='O'">79</xsl:when>
            <xsl:when test="$c='P'">80</xsl:when>
            <xsl:when test="$c='Q'">81</xsl:when>
            <xsl:when test="$c='R'">82</xsl:when>
            <xsl:when test="$c='S'">83</xsl:when>
            <xsl:when test="$c='T'">84</xsl:when>
            <xsl:when test="$c='U'">85</xsl:when>
            <xsl:when test="$c='V'">86</xsl:when>
            <xsl:when test="$c='W'">87</xsl:when>
            <xsl:when test="$c='X'">88</xsl:when>
            <xsl:when test="$c='Y'">89</xsl:when>
            <xsl:when test="$c='Z'">90</xsl:when>
            <xsl:when test="$c='['">91</xsl:when>
            <xsl:when test="$c='\'">92</xsl:when>
            <xsl:when test="$c=']'">93</xsl:when>
            <xsl:when test="$c='^'">94</xsl:when>
            <xsl:when test="$c='_'">95</xsl:when>
            <xsl:when test="$c='`'">96</xsl:when>
            <xsl:when test="$c='a'">97</xsl:when>
            <xsl:when test="$c='b'">98</xsl:when>
            <xsl:when test="$c='c'">99</xsl:when>
            <xsl:when test="$c='d'">100</xsl:when>
            <xsl:when test="$c='e'">101</xsl:when>
            <xsl:when test="$c='f'">102</xsl:when>
            <xsl:when test="$c='g'">103</xsl:when>
            <xsl:when test="$c='h'">104</xsl:when>
            <xsl:when test="$c='i'">105</xsl:when>
            <xsl:when test="$c='j'">106</xsl:when>
            <xsl:when test="$c='k'">107</xsl:when>
            <xsl:when test="$c='l'">108</xsl:when>
            <xsl:when test="$c='m'">109</xsl:when>
            <xsl:when test="$c='n'">110</xsl:when>
            <xsl:when test="$c='o'">111</xsl:when>
            <xsl:when test="$c='p'">112</xsl:when>
            <xsl:when test="$c='q'">113</xsl:when>
            <xsl:when test="$c='r'">114</xsl:when>
            <xsl:when test="$c='s'">115</xsl:when>
            <xsl:when test="$c='t'">116</xsl:when>
            <xsl:when test="$c='u'">117</xsl:when>
            <xsl:when test="$c='v'">118</xsl:when>
            <xsl:when test="$c='w'">119</xsl:when>
            <xsl:when test="$c='x'">120</xsl:when>
            <xsl:when test="$c='y'">121</xsl:when>
            <xsl:when test="$c='z'">122</xsl:when>
            <xsl:when test="$c='{'">123</xsl:when>
            <xsl:when test="$c='|'">124</xsl:when>
            <xsl:when test="$c='}'">125</xsl:when>
            <xsl:when test="$c='~'">126</xsl:when>
            <xsl:otherwise>255</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="mem">
          <xsl:call-template name="write-val">
            <xsl:with-param name="mem" select="$mem"/>
            <xsl:with-param name="key" select="$key"/>
            <xsl:with-param name="val" select="$val"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:apply-templates select="following-sibling::*[1]">
          <xsl:with-param name="ptr" select="$ptr"/>
          <xsl:with-param name="mem" select="$mem"/>
          <xsl:with-param name="input" select="$input"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
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
