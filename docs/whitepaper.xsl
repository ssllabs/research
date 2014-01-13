<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:d="http://docbook.org/ns/docbook"
    exclude-result-prefixes="d" version="1.0">

    <xsl:import href="./docbook-xsl-ns-1.76.1/fo/docbook.xsl"/>

    <xsl:param name="local.l10n.xml" select="document('')"/>
    <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
        <l:l10n language="en">
            <l:context name="title-numbered">
                <l:template name="chapter" text="Chapter %n: %t"/>
                <l:template name="appendix" text="Appendix %n: %t"/>
            </l:context>
        </l:l10n>
    </l:i18n>

    <!-- Specify font families for the entire document -->
    <xsl:param name="fd.mono.font.family">Courier</xsl:param>
    <xsl:param name="fd.body.font.family">PT Serif</xsl:param>
    <xsl:param name="fd.title.font.family">Arimo</xsl:param>

    <!-- The following must be enabled to prevent a FOP exception, not sure why -->
    <xsl:param name="fop1.extensions">1</xsl:param>

    <xsl:param name="admon.graphics">0</xsl:param>

    <!-- Page formatting -->
    <xsl:param name="paper.type">A4</xsl:param>
    <!--
    <xsl:param name="page.width.portrait">7.50in</xsl:param>
    <xsl:param name="page.height.portrait">9.25in</xsl:param>
    -->
    <xsl:param name="page.margin.inner">1.0in</xsl:param>
    <xsl:param name="page.margin.outer">1.0in</xsl:param>

    <xsl:param name="page.margin.top">2.4cm</xsl:param>
    <xsl:param name="body.margin.top">0.4cm</xsl:param>
    <xsl:param name="region.before.extent">0cm</xsl:param>

    <xsl:param name="region.after.extent">0.4cm</xsl:param>
    <xsl:param name="body.margin.bottom">1.0cm</xsl:param>
    <xsl:param name="page.margin.bottom">2.0cm</xsl:param>

    <xsl:param name="double.sided">0</xsl:param>

    <!-- Body text -->
    <xsl:param name="body.font.family">
        <xsl:value-of select="$fd.body.font.family"/>
    </xsl:param>
    <xsl:param name="body.font.master">11</xsl:param>
    <xsl:param name="body.start.indent">0pt</xsl:param>
    <xsl:param name="body.space-before.optimum">10pt</xsl:param>
    <xsl:param name="line-height">1.5</xsl:param>

    <xsl:param name="default.table.width">100%</xsl:param>

    <xsl:param name="xref.with.number.and.title" select="0"/>

    <!--
    <xsl:attribute-set name="table.table.properties">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>        
    </xsl:attribute-set>
-->


    <!-- Titles -->
    <xsl:param name="title.font.family">
        <xsl:value-of select="$fd.title.font.family"/>
    </xsl:param>

    <!-- Do not auto-label chapters -->
    <xsl:param name="chapter.autolabel" select="1"/>
    <xsl:param name="appendix.autolabel" select="1"/>
    <xsl:param name="component.label.includes.part.label" select="1"/>

    <!-- Monospaced text -->
    <xsl:attribute-set name="monospace.verbatim.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.mono.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="start-indent">0.15in</xsl:attribute>
        <xsl:attribute name="end-indent">0.05in</xsl:attribute>
    </xsl:attribute-set>

    <!-- Quotations -->
    <xsl:attribute-set name="blockquote.properties">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <!-- Variable lists: render as blocks -->
    <xsl:param name="variablelist.term.break.after">0</xsl:param>
    <xsl:param name="variablelist.as.blocks">1</xsl:param>

    <!-- Variable lists: make the term bold -->
    <xsl:template match="d:varlistentry/d:term">
        <fo:inline font-weight="bold">
            <xsl:call-template name="simple.xlink">
                <xsl:with-param name="content">
                    <xsl:apply-templates/>
                </xsl:with-param>
            </xsl:call-template>
        </fo:inline>
        <xsl:choose>
            <xsl:when test="not(following-sibling::term)"/>
            <!-- do nothing -->
            <xsl:otherwise>
                <!-- * if we have multiple terms in the same varlistentry, generate -->
                <!-- * a separator (", " by default) and/or an additional line -->
                <!-- * break after each one except the last -->
                <fo:inline>
                    <xsl:value-of select="$variablelist.term.separator"/>
                </fo:inline>
                <xsl:if test="not($variablelist.term.break.after = '0')">
                    <fo:block/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    <xsl:attribute-set name="formal.object.properties">
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="background-color">#ffffff</xsl:attribute>
    </xsl:attribute-set>
    -->

    <!-- Side bar -->
    <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="background-color">#ffffff</xsl:attribute>
        <xsl:attribute name="padding-left">12pt</xsl:attribute>
        <xsl:attribute name="padding-right">12pt</xsl:attribute>
        <xsl:attribute name="padding-top">6pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">6pt</xsl:attribute>
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="list.block.properties">
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sidebar.title.properties">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.2cm</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0.2cm</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.2cm</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.2cm</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.2cm</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.2cm</xsl:attribute>
    </xsl:attribute-set>

    <!-- User input -->
    <xsl:template match="d:userinput">
        <xsl:param name="content">
            <xsl:apply-templates/>
        </xsl:param>
        <fo:inline font-family="{$fd.mono.font.family}" font-weight="bold" font-size="100%">
            <xsl:copy-of select="$content"/>
        </fo:inline>
    </xsl:template>

    <!-- Inline -->
    <xsl:template name="inline.monoseq">
        <xsl:param name="content">
            <xsl:apply-templates/>
        </xsl:param>
        <fo:inline font-family="{$fd.mono.font.family}" font-size="90%">
            <xsl:copy-of select="$content"/>
        </fo:inline>
    </xsl:template>

    <!-- Shade programlistings -->
    <!--
<xsl:param name="shade.verbatim" select="1"/>
<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="background-color">#f7f7f7</xsl:attribute>
  <xsl:attribute name="border-color">#eeeeee</xsl:attribute>
  <xsl:attribute name="padding">2pt</xsl:attribute>
  <xsl:attribute name="border-width">1pt</xsl:attribute>
  <xsl:attribute name="border-style">solid</xsl:attribute>
</xsl:attribute-set>
-->

    <!-- Header column widths. -->
    <xsl:param name="footer.column.widths">1 1 1</xsl:param>

    <!-- Remove whitespace after blockquote elements, because it
     always contains a <para>, which has its own whitespace. -->
    <xsl:attribute-set name="blockquote.properties">
        <xsl:attribute name="margin-left">0.5in</xsl:attribute>
        <xsl:attribute name="margin-right">0.5in</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Paragraph spacing. -->
    <xsl:attribute-set name="normal.para.spacing">
        <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- List item spacing -->
    <xsl:attribute-set name="list.item.spacing">
        <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- List block spacing -->
    <xsl:attribute-set name="list.block.spacing">
        <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="margin-left">0.15in</xsl:attribute>
    </xsl:attribute-set>

    <!-- Section spacing was 0.8 em -->
    <xsl:attribute-set name="section.title.properties">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before.minimum">1.6em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">1.6em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">1.6em</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.0em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.0em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.level1.properties">
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">1.4em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">1.4em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">1.4em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.level4.properties">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">1.0em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">1.0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Change admonition font -->
    <xsl:attribute-set name="admonition.title.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="admonition.properties">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Add rules to admonitions -->
    <xsl:template name="nongraphical.admonition">
        <xsl:variable name="id">
            <xsl:call-template name="object.id"/>
        </xsl:variable>

        <fo:block space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em"
            start-indent="0.50in" end-indent="0.50in" border-left="4pt solid #a70b16"
            padding-left="8pt" padding-top="2pt" padding-bottom="0pt" space-after.minimum="1em"
            space-after.optimum="1em" space-after.maximum="1em" id="{$id}">
            <xsl:if test="$admon.textlabel != 0 or title">
                <fo:block keep-with-next="always"
                    xsl:use-attribute-sets="admonition.title.properties">
                    <xsl:apply-templates select="." mode="object.title.markup"/>
                </fo:block>
            </xsl:if>

            <fo:block xsl:use-attribute-sets="admonition.properties">
                <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <!-- Header styling -->
    <!--
    <xsl:attribute-set name="header.content.properties">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-family"><xsl:value-of select="$fd.title.font.family" /></xsl:attribute>
        <xsl:attribute name="line-height">20pt</xsl:attribute>
    </xsl:attribute-set>
    -->

    <!-- Footer styling -->
    <xsl:attribute-set name="footer.content.properties">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.title.font.family"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Footnote -->
    <xsl:attribute-set name="footnote.properties">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="line-height">10pt</xsl:attribute>
        <xsl:attribute name="font-family">Minion</xsl:attribute>
        <xsl:attribute name="space-after.optimum">5.3em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Added to prevent chapters to have a TOC when standalone. -->
    <xsl:param name="generate.toc">nop</xsl:param>

    <!-- Table cell padding -->
    <xsl:attribute-set name="table.cell.padding">
        <xsl:attribute name="padding-left">6pt</xsl:attribute>
        <xsl:attribute name="padding-right">6pt</xsl:attribute>
        <xsl:attribute name="padding-top">3pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table and figure title -->
    <xsl:attribute-set name="formal.title.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.4em</xsl:attribute>
        <xsl:attribute name="keep-together">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="formal.object.properties">
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table text at 9pt, headings bold. -->
    <xsl:template name="table.cell.block.properties">
        <xsl:if test="ancestor::d:thead or ancestor::d:tfoot">
            <xsl:attribute name="font-weight">bold</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.title.font.family"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:param name="default.table.frame">topbot</xsl:param>
    <xsl:param name="table.frame.border.thickness">0.5pt</xsl:param>

    <!-- Modified the template below to fix cell borders -->
    <xsl:template name="table.cell.properties">
        <xsl:param name="bgcolor.pi" select="''"/>
        <xsl:param name="rowsep.inherit" select="1"/>
        <xsl:param name="colsep.inherit" select="1"/>
        <xsl:param name="col" select="1"/>
        <xsl:param name="valign.inherit" select="''"/>
        <xsl:param name="align.inherit" select="''"/>
        <xsl:param name="char.inherit" select="''"/>

        <!-- Added -->
        <xsl:attribute name="border">0.0pt solid black</xsl:attribute>
        <xsl:if test="ancestor::d:thead or ancestor::d:tfoot">
            <xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
            <xsl:attribute name="padding-top">5pt</xsl:attribute>
            <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
        </xsl:if>
        <!-- /Added -->

        <xsl:choose>
            <xsl:when test="ancestor::d:tgroup">
                <!-- Removed
                <xsl:if test="$bgcolor.pi != ''">
                    <xsl:attribute name="background-color">
                        <xsl:value-of select="$bgcolor.pi"/>
                    </xsl:attribute>
                </xsl:if>
                
                <xsl:if test="$rowsep.inherit &gt; 0">
                    <xsl:call-template name="border">
                        <xsl:with-param name="side" select="'bottom'"/>
                    </xsl:call-template>
                </xsl:if>
                
                <xsl:if test="$colsep.inherit &gt; 0 and 
                    $col &lt; (ancestor::d:tgroup/@cols|ancestor::d:entrytbl/@cols)[last()]">
                    <xsl:call-template name="border">
                        <xsl:with-param name="side" select="'right'"/>
                    </xsl:call-template>
                </xsl:if>
                -->

                <xsl:if test="$valign.inherit != ''">
                    <xsl:attribute name="display-align">
                        <xsl:choose>
                            <xsl:when test="$valign.inherit='top'">before</xsl:when>
                            <xsl:when test="$valign.inherit='middle'">center</xsl:when>
                            <xsl:when test="$valign.inherit='bottom'">after</xsl:when>
                            <xsl:otherwise>
                                <xsl:message>
                                    <xsl:text>Unexpected valign value: </xsl:text>
                                    <xsl:value-of select="$valign.inherit"/>
                                    <xsl:text>, center used.</xsl:text>
                                </xsl:message>
                                <xsl:text>center</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="$align.inherit = 'char' and $char.inherit != ''">
                        <xsl:attribute name="text-align">
                            <xsl:value-of select="$char.inherit"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$align.inherit != ''">
                        <xsl:attribute name="text-align">
                            <xsl:value-of select="$align.inherit"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <!-- HTML table -->
                <!-- Removed
                <xsl:variable name="border" 
                    select="(ancestor::d:table |
                    ancestor::d:informaltable)[last()]/@border"/>
                <xsl:if test="$border != '' and $border != 0">
                    <xsl:attribute name="border">
                        <xsl:value-of select="$table.cell.border.thickness"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$table.cell.border.style"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$table.cell.border.color"/>
                    </xsl:attribute>
                </xsl:if>
                -->
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Adjust index dividing title properties: no bold, more space after. -->
    <xsl:attribute-set name="index.div.title.properties">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.5em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="processing-instruction('linebreak')">
        <fo:block/>
    </xsl:template>

    <xsl:template name="header.content">
        <!-- No page headers -->
    </xsl:template>

    <xsl:template name="head.sep.rule">
        <!-- No rule  -->
    </xsl:template>  

    <!-- No foot rule on the title page -->
    <xsl:template name="foot.sep.rule">
        <xsl:param name="pageclass"/>
        <xsl:param name="sequence"/>
        <xsl:param name="gentext-key"/>

        <xsl:if test="$header.rule != 0">
            <xsl:choose>
                <xsl:when test="$pageclass = 'titlepage'">
                    <!-- off -->
                </xsl:when>

                <xsl:when test="$pageclass = 'body' and $sequence = 'first'"> </xsl:when>

                <xsl:otherwise>
                    <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
                    <xsl:attribute name="border-top-style">solid</xsl:attribute>
                    <xsl:attribute name="border-top-color">black</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="footer.content">
        <xsl:param name="pageclass" select="''"/>
        <xsl:param name="sequence" select="''"/>
        <xsl:param name="position" select="''"/>
        <xsl:param name="gentext-key" select="''"/>

        <fo:block>
            <!-- pageclass can be front, body, back (and 'lot', apparently ?!)-->
            <!-- sequence can be odd, even, first, blank -->
            <!-- position can be left, center, right -->
            <xsl:choose>
                <xsl:when
                    test="($pageclass = 'titlepage') or ($pageclass = 'body' and $sequence = 'first')">
                    <!-- nop; no footer on title pages -->
                </xsl:when>

                <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='left'">
                    <fo:page-number/>
                </xsl:when>

                <xsl:when
                    test="$double.sided != 0 and ($sequence = 'odd' or sequence = 'first') and $position = 'left'">
                    <fo:retrieve-marker retrieve-class-name="section.head.marker"
                        retrieve-position="first-including-carryover"
                        retrieve-boundary="page-sequence"/>
                </xsl:when>

                <xsl:when
                    test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position = 'right'">
                    <fo:page-number/>
                </xsl:when>

                <xsl:when
                    test="$double.sided != 0 and ($sequence = 'even' or $sequence = 'first') and $position = 'right' and $pageclass != 'lot'">
                    <xsl:apply-templates select="." mode="object.title.markup"/>
                </xsl:when>

                <xsl:when test="$double.sided = 0 and $position='center'">
                    <fo:page-number/>
                </xsl:when>

                <xsl:when test="$sequence = 'blank'">
                    <xsl:choose>
                        <xsl:when test="$double.sided != 0 and $position = 'left'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:when test="$double.sided = 0 and $position = 'center'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- nop -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <!-- nop -->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <!-- Break after TOC. -->
    <xsl:template name="component.toc.separator">
        <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" break-after="page"/>
    </xsl:template>
       
    <!-- Style abstract. -->
    <xsl:template match="d:abstract" mode="article.titlepage.recto.auto.mode">
        <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
            xsl:use-attribute-sets="article.titlepage.recto.style" space-before="5.0em"
            space-after="1.0em" text-align="justify" margin-left="0.5in" margin-right="0.5in"
            font-family="{$body.fontset}">
            <xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="article.titlepage.before.verso">

        <fo:block-container absolute-position="fixed" top="240mm">
            <fo:table table-layout="fixed" width="100%" break-after="page">
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell display-align="center">
                            <fo:block text-align="center" font-size="60pt" line-height="35pt">
                                <fo:basic-link external-destination="url(https://www.ssllabs.com)">
                                    <fo:external-graphic content-width="4.5cm"
                                        src="url(ssl-labs-logo.svg)"/>
                                </fo:basic-link>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center">
                            <fo:block text-align="center" font-size="10pt" font-weight="normal">
                                <fo:basic-link external-destination="url(https://www.ssllabs.com)"
                                    >www.ssllabs.com</fo:basic-link>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block-container>

        <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" break-after="page"/>

    </xsl:template>

    <!-- Do not show the URLs we link to. This feature may be appropriate for print, though. -->
    <xsl:param name="ulink.show" select="0"/>
    <xsl:param name="ulink.footnotes" select="1"/>

    <xsl:attribute-set name="xref.properties">
        <!--
        <xsl:attribute name="font-family">
            <xsl:value-of select="$fd.mono.font.family" />
        </xsl:attribute>
        <xsl:attribute name="font-size">24pt</xsl:attribute>
        -->
        <xsl:attribute name="color">#000080</xsl:attribute>
        <!--        
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
        -->
    </xsl:attribute-set>

   

</xsl:stylesheet>
