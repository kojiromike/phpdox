<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:pdx="http://xml.phpdox.net/src#"
                xmlns:pdxf="http://xml.phpdox.net/functions"
                xmlns:pu="http://schema.phpunit.de/coverage/1.0"
                exclude-result-prefixes="pdx">

    <xsl:import href="components.xsl" />
    <xsl:import href="functions.xsl" />
    <xsl:import href="synopsis.xsl" />

    <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat" />

    <xsl:variable name="unit" select="/*[1]" />

    <xsl:param name="type" select="'classes'" />
    <xsl:param name="title" select="'Classes'" />

    <xsl:template match="/">
       <xsl:call-template name="nav" />
       <a name="mainstage"></a>
            <xsl:call-template name="breadcrumb" />
            <xsl:call-template name="sidenav" />
            <a name="introduction"></a>
            # <xsl:value-of select="$unit/@namespace" />\<xsl:value-of select="$unit/@name" />
            #### <xsl:value-of select="$unit/pdx:docblock/pdx:description/@compact" />
            <xsl:copy-of select="pdxf:nl2br($unit/pdx:docblock/pdx:description)" />
            <xsl:if test="$unit/pdx:docblock"><xsl:call-template name="docblock" /></xsl:if>

            <a name="synopsis"></a>
            ## Synopsis
            <xsl:call-template name="synopsis">
                <xsl:with-param name="unit" select="$unit" />
            </xsl:call-template>

            <xsl:if test="$unit/pdx:extends|$unit/pdx:extender|$unit/pdx:implements|$unit/pdx:uses">
            ## <a name="hierarchy"></a> Hierarchy
            <xsl:call-template name="hierarchy" />
            </xsl:if>

            <xsl:if test="$unit//pdx:enrichment[@type = 'phpunit']">
            ## <a name="coverage"></a> Coverage
            <xsl:call-template name="coverage" />
            </xsl:if>

            <xsl:if test="$unit//pdx:enrichment[@type='pmd' or @type='checkstyle']">
            <xsl:call-template name="violations">
                <xsl:with-param name="ctx" select="$unit//pdx:enrichments" />
            </xsl:call-template>
            </xsl:if>

            <xsl:if test="//pdx:todo">
            ## <a name="tasks"></a> Tasks
            <xsl:call-template name="tasks" />
            </xsl:if>

            <xsl:if test="//pdx:constant">
            ## <a name="constants"></a> Constants
            <xsl:call-template name="constants" />
            </xsl:if>

            <xsl:if test="//pdx:member">
            ## <a name="members"></a> Members
            <xsl:call-template name="members" />
            </xsl:if>

            <xsl:if test="//pdx:method">
            ## <a name="methods"></a> Methods
            <xsl:call-template name="methods" />
            </xsl:if>

            <xsl:if test="//pdx:enrichment[@type = 'git']">
                ## <a name="history"></a> History
                <xsl:call-template name="git-history" />
            </xsl:if>
        <xsl:call-template name="footer" />
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="breadcrumb">
        <div class="box">
            <ul class="breadcrumb">
                <li><a href="{$base}index.{$extension}">Overview</a></li>
                <li class="separator"><a href="{$base}{$type}.{$extension}"><xsl:value-of select="$title" /></a></li>
                <xsl:if test="$unit/@namespace != ''">
                    <li class="separator"><a href="{$base}{$type}.{$extension}#{translate($unit/@namespace, '\', '_')}"><xsl:value-of select="$unit/@namespace" /></a></li>
                </xsl:if>
                <li class="separator"><xsl:value-of select="$unit/@name" /></li>
            </ul>
        </div>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="sidenav">
        <nav class="box">
            <ul>
                <li><a href="#introduction">Introduction</a></li>
                <li><a href="#synopsis">Synopsis</a></li>
                <xsl:if test="$unit/pdx:extends|$unit/pdx:extender|$unit/pdx:implements|$unit/pdx:uses">
                <li><a href="#hierarchy">Hierarchy</a></li>
                </xsl:if>
                <xsl:if test="$unit//pdx:enrichment[@type = 'phpunit']">
                <li><a href="#coverage">Coverage</a></li>
                </xsl:if>
                <xsl:if test="$unit//pdx:enrichment[@type='pmd' or @type='checkstyle']">
                <li><a href="#violations">Violations</a></li>
                </xsl:if>
                <xsl:if test="//pdx:todo">
                <li><a href="#tasks">Tasks</a></li>
                </xsl:if>
                <xsl:if test="//pdx:constant">
                <li><a href="#constants">Constants</a></li>
                </xsl:if>
                <xsl:if test="//pdx:member">
                <li><a href="#members">Members</a></li>
                </xsl:if>
                <xsl:if test="//pdx:method">
                <li><a href="#methods">Methods</a></li>
                </xsl:if>
                <xsl:if test="//pdx:enrichment[@type = 'git']">
                <li><a href="#history">History</a></li>
                </xsl:if>
            </ul>
        </nav>
    </xsl:template>


    <!-- ######################################################################################################### -->

    <xsl:template name="coverage">

        <table class="styled">
            <tr>
                <xsl:variable name="methods"  select="count($unit/pdx:method|$unit/pdx:constructor|$unit/pdx:destructor)" />
                <xsl:variable name="executed" select="count($unit//pdx:enrichments/pdx:enrichment[@type='phpunit']/pu:coverage[@coverage = '100'])" />
                <td>Methods</td>
                <td class="percent"><xsl:value-of select="format-number($executed div $methods * 100, '0.##')" />%</td>
                <td class="nummeric"><xsl:value-of select="$executed" /> / <xsl:value-of select="$methods" /></td>
            </tr>
            <tr>
                <xsl:variable name="executed"    select="$unit/pdx:enrichments/pdx:enrichment[@type='phpunit']/pu:coverage/@executed" />
                <xsl:variable name="executable"  select="$unit/pdx:enrichments/pdx:enrichment[@type='phpunit']/pu:coverage/@executable" />
                <td>Lines</td>
                <td class="percent"><xsl:value-of select="format-number($executed div $executable * 100, '0.##')" />%</td>
                <td class="nummeric"><xsl:value-of select="$executed" /> / <xsl:value-of select="$executable" /></td>
            </tr>
        </table>
    </xsl:template>

</xsl:stylesheet>