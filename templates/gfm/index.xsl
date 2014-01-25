<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:git="http://xml.phpdox.net/gitlog#"
                xmlns:pdx="http://xml.phpdox.net/src#">

    <xsl:import href="components.xsl" />

    <xsl:output method="text" encoding="UTF-8" doctype-system="about:legacy-compat" />

    <xsl:template match="/">
                <xsl:call-template name="nav" />
                <xsl:call-template name="index" />
                <a name="mainstage"></a>
                <xsl:choose>
                    <xsl:when test="//pdx:enrichment[@type='phploc']">
                        <xsl:call-template name="phploc" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="missing" />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="footer" />
            </body>
        </html>
    </xsl:template>

    <xsl:template name="index">
        <a name="index"></a>
        <a name="projectinfo"></a>
        # <xsl:value-of select="$project" />
        ## Software Documentation

        Welcome to the Software Documentation homepage.
        <a name="buildinfo"></a>
        ### Build

        <xsl:value-of select="//pdx:enrichment[@type='build']/pdx:date/@rfc" />
        ### VCS Info

        <xsl:variable name="current" select="//pdx:enrichment[@type='git']/git:current" />
        tag: <xsl:value-of select="$current/@describe" /><br/>
        branch: <xsl:value-of select="$current/@branch" />

        # Used Enrichers

        <xsl:for-each select="//pdx:enrichment[@type='build']//pdx:enricher">
            <xsl:sort select="@type" />
            <xsl:value-of select="@type" /><xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="missing">
        **Warning:** PHPLoc enrichment not enabled or phploc.xml not found.
        <xsl:call-template name="phploc" />
    </xsl:template>

    <xsl:template name="phploc">
        <xsl:variable name="phploc" select="//pdx:enrichment[@type='phploc']" />
        ## Structure

        | Namespaces          | <xsl:value-of select="$phploc/pdx:namespaces" />         | |
        | Interfaces          | <xsl:value-of select="$phploc/pdx:interfaces" />         | |
        | Traits              | <xsl:value-of select="$phploc/pdx:traits" />             | |
        | Classes             | <xsl:value-of select="$phploc/pdx:classes" />            | |
        | Abstract Classes    | <xsl:value-of select="$phploc/pdx:abstractClasses" />    | (<xsl:value-of select="format-number($phploc/pdx:abstractClasses div $phploc/pdx:classes * 100, '0.##')" />%)     |
        | Concrete Classes    | <xsl:value-of select="$phploc/pdx:concreteClasses" />    | (<xsl:value-of select="format-number($phploc/pdx:concreteClasses div $phploc/pdx:classes * 100,'0.##')" />%)      |
        | Methods             | <xsl:value-of select="$phploc/pdx:methods" />            | |
        | Scope               | | |
        | Non-Static Methods  | <xsl:value-of select="$phploc/pdx:nonStaticMethods" />   | (<xsl:value-of select="format-number($phploc/pdx:nonStaticMethods div $phploc/pdx:methods * 100,'0.##')" />%)     |
        | Static Methods      | <xsl:value-of select="$phploc/pdx:staticMethods" />      | (<xsl:value-of select="format-number($phploc/pdx:staticMethods div $phploc/pdx:methods * 100,'0.##')" />%)        |
        | Visibility          | | |
        | Public Method       | <xsl:value-of select="$phploc/pdx:publicMethods" />      | (<xsl:value-of select="format-number($phploc/pdx:publicMethods div $phploc/pdx:methods * 100,'0.##')" />%)        |
        | Non-Public Methods  | <xsl:value-of select="$phploc/pdx:nonPublicMethods" />   | (<xsl:value-of select="format-number($phploc/pdx:nonPublicMethods div $phploc/pdx:methods * 100,'0.##')" />%)     |
        | Functions           | <xsl:value-of select="$phploc/pdx:functions" />          | |
        | Named Functions     | <xsl:value-of select="$phploc/pdx:namedFunctions" />     | (<xsl:value-of select="format-number($phploc/pdx:namedFunctions div $phploc/pdx:functions * 100,'0.##')" />%)     |
        | Anonymous Functions | <xsl:value-of select="$phploc/pdx:anonymousFunctions" /> | (<xsl:value-of select="format-number($phploc/pdx:anonymousFunctions div $phploc/pdx:functions * 100,'0.##')" />%) |
        | Constants           | <xsl:value-of select="$phploc/pdx:constants" />          | |
        | Global Constants    | <xsl:value-of select="$phploc/pdx:globalConstants" />    | (<xsl:value-of select="format-number($phploc/pdx:globalConstants div $phploc/pdx:constants * 100,'0.##')" />%)    |
        | Class Constants     | <xsl:value-of select="$phploc/pdx:classConstants" />     | (<xsl:value-of select="format-number($phploc/pdx:classConstants div $phploc/pdx:constants * 100,'0.##')" />%)     |

        ## Tests

        | Classes | <xsl:value-of select="$phploc/pdx:testClasses" /> | |
        | Methods | <xsl:value-of select="$phploc/pdx:testMethods" /> | |

        ## Size

        | Lines of Code (LOC) | <xsl:value-of select="$phploc/pdx:loc" /> | |
        | Comment Lines of Code (CLOC) | <xsl:value-of select="$phploc/pdx:cloc" /> | (<xsl:value-of select="format-number($phploc/pdx:cloc div $phploc/pdx:loc * 100,'0.##')" />%) |
        | Non-Comment Lines of Code (NCLOC) | <xsl:value-of select="$phploc/pdx:ncloc" /> | (<xsl:value-of select="format-number($phploc/pdx:ncloc div $phploc/pdx:loc * 100,'0.##')" />%) |
        | Logical Lines of Code (LLOC) | <xsl:value-of select="$phploc/pdx:lloc" /> | (<xsl:value-of select="format-number($phploc/pdx:lloc div $phploc/pdx:loc * 100,'0.##')" />%) |
        | Classes | <xsl:value-of select="$phploc/pdx:llocClasses" /> | (<xsl:value-of select="format-number($phploc/pdx:llocClasses div $phploc/pdx:lloc * 100,'0.##')" />%) |
        | Average Class Length | <xsl:value-of select="round($phploc/pdx:llocByNoc)" /> | |
        | Average Method Length | <xsl:value-of select="round($phploc/pdx:llocByNom)" /> | |
        | Functions | <xsl:value-of select="$phploc/pdx:llocFunctions" /> | (<xsl:value-of select="format-number($phploc/pdx:llocFunctions div $phploc/pdx:lloc * 100,'0.##')" />%) | |
        | Average Function Length | <xsl:value-of select="round($phploc/pdx:llocByNof)" /> | |
        | Not in classes or functions | <xsl:value-of select="$phploc/pdx:llocGlobal" /> | (<xsl:value-of select="format-number($phploc/pdx:llocGlobal div $phploc/pdx:lloc * 100,'0.##')" />%) |

        ## Complexity

        | Cyclomatic Complexity / LLOC | <xsl:value-of select="format-number($phploc/pdx:ccnByLloc, '0.##')" /> | |
        | Cyclomatic Complexity / Number of Methods | <xsl:value-of select="format-number($phploc/pdx:ccnByNom, '0.##')" /> | |

        ## Dependencies

        | Global Accesses | <xsl:value-of select="$phploc/pdx:globalAccesses" /> | |
        | Global Constants | <xsl:value-of select="$phploc/pdx:globalConstantAccesses" /> | (<xsl:value-of select="format-number($phploc/pdx:globalConstantAccesses div $phploc/pdx:globalAccesses * 100,'0.##')" />%) |
        | Global Variables | <xsl:value-of select="$phploc/pdx:globalVariableAccesses" /> | (<xsl:value-of select="format-number($phploc/pdx:globalVariableAccesses div $phploc/pdx:globalAccesses * 100,'0.##')" />%) |
        | Super-Global Variables | <xsl:value-of select="$phploc/pdx:superGlobalVariableAccesses" /> | (<xsl:value-of select="format-number($phploc/pdx:superGlobalVariableAccesses div $phploc/pdx:globalAccesses * 100,'0.##')" />%) |
        | Attribute Accesses | <xsl:value-of select="$phploc/pdx:attributeAccesses" /> | |
        | Non-Static | <xsl:value-of select="$phploc/pdx:instanceAttributeAccesses" /> | (<xsl:value-of select="format-number($phploc/pdx:instanceAttributeAccesses div $phploc/pdx:attributeAccesses * 100,'0.##')" />%) |
        | Static | <xsl:value-of select="$phploc/pdx:staticAttributeAccesses" /> | (<xsl:value-of select="format-number($phploc/pdx:staticAttributeAccesses div $phploc/pdx:attributeAccesses * 100,'0.##')" />%) |
        | Method Calls | <xsl:value-of select="$phploc/pdx:methodCalls" /> | |
        | Non-Static | <xsl:value-of select="$phploc/pdx:instanceMethodCalls" /> | (<xsl:value-of select="format-number($phploc/pdx:instanceMethodCalls div $phploc/pdx:methodCalls * 100,'0.##')" />%) |
        | Static | <xsl:value-of select="$phploc/pdx:staticMethodCalls" /> | (<xsl:value-of select="format-number($phploc/pdx:staticMethodCalls div $phploc/pdx:methodCalls * 100,'0.##')" />%) |
    </xsl:template>

</xsl:stylesheet>