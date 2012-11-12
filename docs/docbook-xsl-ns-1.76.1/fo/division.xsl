<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************
     $Id: division.xsl 8320 2009-03-12 17:43:44Z mzjn $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template name="division.title">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="$node" mode="object.title.markup"/>
  </xsl:variable>

  <xsl:if test="$passivetex.extensions != 0">
    <fotex:bookmark xmlns:fotex="http://www.tug.org/fotex"
                    fotex-bookmark-level="1"
                    fotex-bookmark-label="{$id}">
      <xsl:value-of select="$title"/>
    </fotex:bookmark>
  </xsl:if>

  <fo:block keep-with-next.within-column="always"
            hyphenate="false">
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:outline-level">
        <xsl:choose>
          <xsl:when test="count($node/ancestor::*) > 0">
            <xsl:value-of select="count($node/ancestor::*)"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
      <xsl:attribute name="axf:outline-title">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$title"/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:set">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="preamble"
                select="*[not(self::d:book or self::d:set or self::d:setindex)]"/>

  <xsl:variable name="content" select="d:book|d:set|d:setindex"/>

  <xsl:variable name="titlepage-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'titlepage'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="lot-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'lot'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$preamble">
    <fo:page-sequence hyphenate="{$hyphenate}"
                      master-reference="{$titlepage-master-reference}">
      <xsl:attribute name="language">
        <xsl:call-template name="l10n.language"/>
      </xsl:attribute>
      <xsl:attribute name="format">
        <xsl:call-template name="page.number.format">
          <xsl:with-param name="master-reference" 
                          select="$titlepage-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="initial-page-number">
        <xsl:call-template name="initial.page.number">
          <xsl:with-param name="master-reference" 
                          select="$titlepage-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="force-page-count">
        <xsl:call-template name="force.page.count">
          <xsl:with-param name="master-reference" 
                          select="$titlepage-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="hyphenation-character">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-character'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-push-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-remain-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="running.head.mode">
        <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="." mode="running.foot.mode">
        <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
      </xsl:apply-templates>

      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="set.flow.properties">
          <xsl:with-param name="element" select="local-name(.)"/>
          <xsl:with-param name="master-reference" 
                          select="$titlepage-master-reference"/>
        </xsl:call-template>

        <fo:block id="{$id}">
          <xsl:call-template name="set.titlepage"/>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="contains($toc.params, 'toc')">
    <fo:page-sequence hyphenate="{$hyphenate}"
                      master-reference="{$lot-master-reference}">
      <xsl:attribute name="language">
        <xsl:call-template name="l10n.language"/>
      </xsl:attribute>
      <xsl:attribute name="format">
        <xsl:call-template name="page.number.format">
          <xsl:with-param name="element" select="'toc'"/>
          <xsl:with-param name="master-reference"
                          select="$lot-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="initial-page-number">
        <xsl:call-template name="initial.page.number">
          <xsl:with-param name="master-reference"
                          select="$lot-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="force-page-count">
        <xsl:call-template name="force.page.count">
          <xsl:with-param name="master-reference"
                          select="$lot-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="hyphenation-character">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-character'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-push-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-remain-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="running.head.mode">
        <xsl:with-param name="master-reference" select="$lot-master-reference"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="." mode="running.foot.mode">
        <xsl:with-param name="master-reference" select="$lot-master-reference"/>
      </xsl:apply-templates>

      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="set.flow.properties">
          <xsl:with-param name="element" select="local-name(.)"/>
          <xsl:with-param name="master-reference" 
                          select="$lot-master-reference"/>
        </xsl:call-template>

        <xsl:call-template name="set.toc"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:apply-templates select="$content"/>
</xsl:template>

<xsl:template match="d:set/d:setinfo"></xsl:template>
<xsl:template match="d:set/d:title"></xsl:template>
<xsl:template match="d:set/d:subtitle"></xsl:template>
<xsl:template match="d:set/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:book">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="preamble"
                select="d:title|d:subtitle|d:titleabbrev|d:bookinfo|d:info"/>

  <xsl:variable name="content"
                select="node()[not(self::d:title or self::d:subtitle
                            or self::d:titleabbrev
                            or self::d:info
                            or self::d:bookinfo)]"/>

  <xsl:variable name="titlepage-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'titlepage'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="front.cover"/>

  <xsl:if test="$preamble">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$titlepage-master-reference"/>
      <xsl:with-param name="content">
        <fo:block id="{$id}">
          <xsl:call-template name="book.titlepage"/>
        </fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:apply-templates select="d:dedication" mode="dedication"/>
  <xsl:apply-templates select="d:acknowledgements" mode="acknowledgements"/>

  <xsl:call-template name="make.book.tocs"/>

  <xsl:apply-templates select="$content"/>

  <xsl:call-template name="back.cover"/>

</xsl:template>

<xsl:template match="d:book/d:bookinfo"></xsl:template>
<xsl:template match="d:book/d:info"></xsl:template>
<xsl:template match="d:book/d:title"></xsl:template>
<xsl:template match="d:book/d:subtitle"></xsl:template>
<xsl:template match="d:book/d:titleabbrev"></xsl:template>

<!-- Placeholder templates -->
<xsl:template name="front.cover"/>
<xsl:template name="back.cover"/>

<!-- ================================================================= -->
<xsl:template name="make.book.tocs">

  <xsl:variable name="lot-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'lot'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="contains($toc.params, 'toc')">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'TableofContents'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="division.toc">
          <xsl:with-param name="toc.title.p" 
                          select="contains($toc.params, 'title')"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="contains($toc.params,'figure') and .//d:figure">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'ListofFigures'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list.of.titles">
          <xsl:with-param name="titles" select="'figure'"/>
          <xsl:with-param name="nodes" select=".//d:figure"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="contains($toc.params,'table') and .//d:table">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'ListofTables'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list.of.titles">
          <xsl:with-param name="titles" select="'table'"/>
          <xsl:with-param name="nodes" select=".//d:table"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="contains($toc.params,'example') and .//d:example">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'ListofExample'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list.of.titles">
          <xsl:with-param name="titles" select="'example'"/>
          <xsl:with-param name="nodes" select=".//d:example"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="contains($toc.params,'equation') and 
                 .//d:equation[d:title or d:info/d:title]">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'ListofEquations'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list.of.titles">
          <xsl:with-param name="titles" select="'equation'"/>
          <xsl:with-param name="nodes" 
                          select=".//d:equation[d:title or d:info/d:title]"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="contains($toc.params,'procedure') and 
                 .//d:procedure[d:title or d:info/d:title]">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference"
                      select="$lot-master-reference"/>
      <xsl:with-param name="element" select="'toc'"/>
      <xsl:with-param name="gentext-key" select="'ListofProcedures'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list.of.titles">
          <xsl:with-param name="titles" select="'procedure'"/>
          <xsl:with-param name="nodes" 
                          select=".//d:procedure[d:title or d:info/d:title]"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
<!-- ==================================================================== -->

<xsl:template match="d:part">
  <xsl:if test="not(d:partintro)">
    <xsl:apply-templates select="." mode="part.titlepage.mode"/>
    <xsl:call-template name="generate.part.toc"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:part" mode="part.titlepage.mode">
  <!-- done this way to force the context node to be the part -->
  <xsl:param name="additional.content"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="titlepage-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'titlepage'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$titlepage-master-reference}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>
    <xsl:attribute name="format">
      <xsl:call-template name="page.number.format">
        <xsl:with-param name="master-reference" 
                        select="$titlepage-master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="initial-page-number">
      <xsl:call-template name="initial.page.number">
        <xsl:with-param name="master-reference" 
                        select="$titlepage-master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="force-page-count">
      <xsl:call-template name="force.page.count">
        <xsl:with-param name="master-reference" 
                        select="$titlepage-master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="hyphenation-character">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-character'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-push-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-remain-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <xsl:call-template name="set.flow.properties">
        <xsl:with-param name="element" select="local-name(.)"/>
        <xsl:with-param name="master-reference" 
                        select="$titlepage-master-reference"/>
      </xsl:call-template>

      <fo:block id="{$id}">
        <xsl:call-template name="part.titlepage"/>
      </fo:block>
      <xsl:copy-of select="$additional.content"/>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="d:part/d:docinfo|d:partinfo"></xsl:template>
<xsl:template match="d:part/d:info"></xsl:template>
<xsl:template match="d:part/d:title"></xsl:template>
<xsl:template match="d:part/d:subtitle"></xsl:template>
<xsl:template match="d:part/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="generate.part.toc">
  <xsl:param name="part" select="."/>

  <xsl:variable name="lot-master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass" select="'lot'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="node" select="$part"/>
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="d:reference|
                                     d:preface|
                                     d:chapter|
                                     d:appendix|
                                     d:article|
                                     d:bibliography|
                                     d:glossary|
                                     d:index"/>

  <xsl:if test="count($nodes) &gt; 0 and contains($toc.params, 'toc')">
    <fo:page-sequence hyphenate="{$hyphenate}"
                      master-reference="{$lot-master-reference}">
      <xsl:attribute name="language">
        <xsl:call-template name="l10n.language"/>
      </xsl:attribute>
      <xsl:attribute name="format">
        <xsl:call-template name="page.number.format">
          <xsl:with-param name="element" select="'toc'"/>
          <xsl:with-param name="master-reference" 
                          select="$lot-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="initial-page-number">
        <xsl:call-template name="initial.page.number">
          <xsl:with-param name="element" select="'toc'"/>
          <xsl:with-param name="master-reference" 
                          select="$lot-master-reference"/>
         </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="force-page-count">
        <xsl:call-template name="force.page.count">
          <xsl:with-param name="master-reference" 
                          select="$lot-master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="hyphenation-character">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-character'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-push-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-remain-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="$part" mode="running.head.mode">
        <xsl:with-param name="master-reference" select="$lot-master-reference"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="$part" mode="running.foot.mode">
        <xsl:with-param name="master-reference" select="$lot-master-reference"/>
      </xsl:apply-templates>

      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="set.flow.properties">
          <xsl:with-param name="element" select="local-name(.)"/>
          <xsl:with-param name="master-reference" 
                          select="$lot-master-reference"/>
        </xsl:call-template>

        <xsl:call-template name="division.toc">
          <xsl:with-param name="toc-context" select="$part"/>
          <xsl:with-param name="toc.title.p" 
                          select="contains($toc.params, 'title')"/>
        </xsl:call-template>

      </fo:flow>
    </fo:page-sequence>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:part/d:partintro">
  <xsl:apply-templates select=".." mode="part.titlepage.mode">
    <xsl:with-param name="additional.content">
      <xsl:if test="d:title">
        <xsl:call-template name="partintro.titlepage"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:apply-templates>

  <xsl:call-template name="generate.part.toc">
    <xsl:with-param name="part" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:partintro/d:title"></xsl:template>
<xsl:template match="d:partintro/d:subtitle"></xsl:template>
<xsl:template match="d:partintro/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:book" mode="division.number">
  <xsl:number from="d:set" count="d:book" format="1."/>
</xsl:template>

<xsl:template match="d:part" mode="division.number">
  <xsl:number from="d:book" count="d:part" format="I."/>
</xsl:template>

</xsl:stylesheet>

