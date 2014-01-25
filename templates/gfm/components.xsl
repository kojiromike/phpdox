<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:pdx="http://xml.phpdox.net/src#"
                xmlns:pdxf="http://xml.phpdox.net/functions"
                xmlns:git="http://xml.phpdox.net/gitlog#"
                exclude-result-prefixes="pdx pdxf">

    <xsl:param name="base" select="''" />
    <xsl:param name="xml" select="''" />
    <xsl:param name="extension" select="'md'" />
    <xsl:param name="project" select="'phpDox generated Project'" />

    <xsl:template name="nav">
        <xsl:variable name="index" select="document(concat($xml,'index.xml'), .)/pdx:index" />
        - [Overview]({$base}index.{$extension}
        <xsl:if test="count($index/pdx:namespace) &gt; 1">
            [Namespaces]({$base}namespaces.{$extension})
        </xsl:if>
        <xsl:if test="count($index//pdx:interface) &gt; 0">
            [Interfaces]({$base}interfaces.{$extension})
        </xsl:if>
        <xsl:if test="count($index//pdx:class) &gt; 0">
            [Classes]({$base}classes.{$extension}
        </xsl:if>
        <xsl:if test="count($index//pdx:trait) &gt; 0">
            [Traits]({$base}traits.{$extension}
        </xsl:if>
        [Reports]({$base}reports.{$extension}
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="footer">
        <xsl:value-of select="//pdx:enrichment[@type = 'build']/pdx:phpdox/@generated" />
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="docblock">
        <xsl:param name="ctx" select="$unit" />

        <xsl:for-each select="$ctx/pdx:docblock">
            <xsl:if test="pdx:author">
                * Author: <xsl:value-of select="pdx:author/@value" />
            </xsl:if>
            <xsl:if test="pdx:copyright">
                * Copyright: <xsl:value-of select="pdx:copyright/@value" />
            </xsl:if>
            <xsl:if test="pdx:license">
                * License: <xsl:value-of select="pdx:license/@name" />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="hierarchy">
        <xsl:param name="dir" select="'classes'" />
        <xsl:if test="$unit/pdx:extends">
            #### Extends
            <xsl:for-each select="$unit/pdx:extends">
                * [<xsl:value-of select="@full" />]({$base}{$dir}/{translate(@full, '\', '_')}.{$extension})
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$unit/pdx:extender">
            #### Extended by
            <xsl:for-each select="$unit/pdx:extender">
                * [<xsl:value-of select="@full" />]({$base}{$dir}/{translate(@full, '\', '_')}.{$extension})
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$unit/pdx:uses">
            #### Uses
            <xsl:for-each select="$unit/pdx:uses">
                * [<xsl:value-of select="@full" />]({$base}traits/{translate(@full, '\', '_')}.{$extension})
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$unit/pdx:implements">
            #### Implements
            <xsl:for-each select="$unit/pdx:implements">
                * [<xsl:value-of select="@full" />]({$base}interfaces/{translate(@full, '\', '_')}.{$extension})
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$unit/pdx:implementor">
            #### Implemented by
            <xsl:for-each select="$unit/pdx:implementor">
                * [<xsl:value-of select="@full" />]({$base}classes/{translate(@full, '\', '_')}.{$extension})
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="violations">
        <xsl:param name="ctx" />

        <xsl:if test="$ctx/pdx:enrichment[@type='pmd' or @type='checkstyle']">
            <a name="violations"></a>
            ## Violations
            <xsl:if test="$ctx/pdx:enrichment[@type='pmd']">
                ### PHPMessDetector
                | Line | Rule | Message |
                | ---- | ---- | ------- |
                <xsl:for-each select="$ctx/pdx:enrichment[@type='pmd']/pdx:violation">
                    <xsl:sort data-type="number" select="@beginline" order="ascending" />
                    | <xsl:choose> <xsl:when test="@beginline = @endline"><xsl:value-of select="@beginline" /></xsl:when> <xsl:otherwise><xsl:value-of select="@beginline" /> - <xsl:value-of select="@endline" /></xsl:otherwise> </xsl:choose> | <a href="{@externalInfoUrl}" target="_blank" title="{@ruleset}"><xsl:value-of select="@rule" /> | <xsl:value-of select="@message" /> |
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$ctx/pdx:enrichment[@type='checkstyle']">
                ### Checkstyle
                | Line | Column | Severity | Message |
                | ---- | ------ | -------- | ------- |
                <xsl:for-each select="$ctx/pdx:enrichment[@type='checkstyle']/pdx:*">
                    <xsl:sort data-type="number" select="@line" order="ascending" />
                    | <xsl:value-of select="@line" /> | <xsl:value-of select="@column" /> | <span title="{@source}"><xsl:value-of select="local-name(.)" /></span> | <xsl:value-of select="@message" /> |
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="tasks">
        <xsl:param name="ctx" select="$unit" />

        <a name="tasks"></a>
        ## Tasks
        | Line | Task |
        | ---- | ---- |
        <xsl:for-each select="$ctx//pdx:todo">
            <xsl:variable name="line">
                <xsl:choose>
                    <xsl:when test="@line"><xsl:value-of select="@line" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="../../@start" />+</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            | <xsl:value-of select="$line" /> | <xsl:value-of select="@value" /> |
        </xsl:for-each>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="constants">
        | Name | Value |
        | ---- | ----- |
        <xsl:for-each select="//pdx:constant">
            | <a name="{@name}"></a><xsl:value-of select="@name" /> | <xsl:value-of select="@value" /> |
        </xsl:for-each>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="members">
        <xsl:if test="//pdx:member[@visibility='private']">
            #### private
            <xsl:for-each select="//pdx:member[@visibility='private']">
                <xsl:sort select="@name" />
                <xsl:call-template name="memberli" />
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="//pdx:member[@visibility='protected']">
            #### protected
            <xsl:for-each select="//pdx:member[@visibility='protected']">
                <xsl:sort select="@name" />
                <xsl:call-template name="memberli" />
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="//pdx:member[@visibility='public']">
            #### public
            <xsl:for-each select="//pdx:member[@visibility='public']">
                <xsl:sort select="@name" />
                <xsl:call-template name="memberli" />
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="memberli">
        * <a name="{@name}"></a>**$<xsl:value-of select="@name" />**
        <xsl:if test="pdx:docblock/pdx:var">
            —
            <xsl:choose>
                <xsl:when test="pdx:docblock/pdx:var/@type = 'object'">
                    <a href="#"><xsl:value-of select="pdx:docblock/pdx:var/pdx:type/@full" /></a>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="pdx:docblock/pdx:var/@type" /></xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="pdx:docblock/pdx:description/@compact != ''"><xsl:value-of select="pdx:docblock/pdx:description/@compact" /></xsl:if>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="methods">
        <xsl:if test="$unit/pdx:method[@visibility='private']">
            #### private
            <xsl:call-template name="method-ul">
                <xsl:with-param name="isParent" select="'false'" />
                <xsl:with-param name="visibility" select="'private'" />
                <xsl:with-param name="ctx" select="$unit" />
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$unit/pdx:method[@visibility='protected']">
            #### protected
            <xsl:call-template name="method-ul">
                <xsl:with-param name="isParent" select="'false'" />
                <xsl:with-param name="visibility" select="'protected'" />
                <xsl:with-param name="ctx" select="$unit" />
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$unit/pdx:method[@visibility='public']">
            #### public
            <xsl:call-template name="method-ul">
                <xsl:with-param name="isParent" select="'false'" />
                <xsl:with-param name="visibility" select="'public'" />
                <xsl:with-param name="ctx" select="$unit" />
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="inheritedMethods">
            <xsl:with-param name="ctx" select="$unit" />
        </xsl:call-template>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="method-ul">
        <xsl:param name="visibility" />
        <xsl:param name="ctx" />
        <xsl:param name="isParent" select="'true'" />
        <xsl:if test="$isParent != 'true'">
            <xsl:for-each select="$unit/pdx:constructor[@visibility = $visibility]|$unit/pdx:destructor[@visibility = $visibility]">
                <xsl:call-template name="method-li" />
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="$ctx/pdx:method[@visibility=$visibility]">
            <xsl:sort select="@name" />
            <xsl:call-template name="method-li" />
        </xsl:for-each>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="method-li">
        * <a name="{@name}"></a>
        <xsl:copy-of select="pdxf:link(parent::*[1], @name, concat(@name, '()'))" />
        <xsl:if test="pdx:docblock/pdx:description/@compact != ''">
            — <xsl:value-of select="pdx:docblock/pdx:description/@compact" />
        </xsl:if>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="inheritedMethods">
        <xsl:param name="ctx" />

        <xsl:for-each select="//pdx:parent">
            <xsl:variable name="parent" select="." />

            <xsl:if test="count($parent/pdx:method) > 0">
                ### Inherited from <xsl:copy-of select="pdxf:link($parent, '', $parent/@full)" />
            </xsl:if>
            <xsl:if test="$parent/pdx:method[@visibility='protected']">
                #### protected
                <xsl:for-each select="$parent/pdx:method[@visibility='protected']">
                    <xsl:sort select="@name" />
                    <xsl:variable name="name" select="@name" />
                    <xsl:if test="not($unit/pdx:mehthod[@name = $name])">
                        <xsl:call-template name="method-li" />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$parent/pdx:method[@visibility='public']">
                #### public
                <xsl:for-each select="$parent/pdx:method[@visibility='public']">
                    <xsl:sort select="@name" />
                    <xsl:variable name="name" select="@name" />
                    <xsl:if test="not($unit/pdx:mehthod[@name = $name])">
                        <xsl:call-template name="method-li" />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="type">
        <xsl:param name="ctx" />
        <xsl:choose>
            <xsl:when test="$ctx/pdx:docblock/pdx:return/@type = 'object'"><xsl:value-of select="$ctx/pdx:docblock/pdx:return/pdx:type/@name" /></xsl:when>
            <xsl:when test="not($ctx/pdx:docblock/pdx:return)">void</xsl:when>
            <xsl:otherwise><xsl:value-of select="$ctx/pdx:docblock/pdx:return/@type" /></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ######################################################################################################### -->

    <xsl:template name="git-history">
        <xsl:for-each select="//pdx:enrichment[@type = 'git']/git:commit">
            <xsl:sort data-type="number" select="git:commiter/@unixtime" order="descending" />
            ### <xsl:value-of select="git:commiter/@time" /> (commit #<xsl:value-of select="substring(@sha1,0,8)" />)

            Author: <xsl:value-of select="git:author/@name" /> (<xsl:value-of select="git:author/@email" />) /
            Committer: <xsl:value-of select="git:commiter/@name" /> (<xsl:value-of select="git:author/@email" />)
            `<xsl:value-of select="git:message" />`
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
