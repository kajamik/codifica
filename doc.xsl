<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="//tei:title[@xml:lang='it']"/></title>

                <link rel="stylesheet" type="text/css" href="./src/css/doc.css"/>

                <script src="src/js/app.js"></script>
                <script src="src/js/imageResize.js"></script>
            </head>
            <body>
                <div class="manuscript">
                    <h2>Document Specifications</h2>
                    <xsl:apply-templates select="//tei:teiHeader"/>
                    <div class="viewer">
                        <div class="viewer-gallery">
                            <xsl:apply-templates select="//tei:facsimile"/>
                        </div>
                        <div class="viewer-control">
                            <div class="counter-display">N/N</div>
                            <button id="prev" class="prev">Previous</button>
                            <button id="next" class="next">Next</button>
                        </div>
                    </div>
                    <div class="reading">
                        <xsl:apply-templates select="//tei:body"/>
                    </div>
                </div>

                <footer>
                    <xsl:apply-templates select="//tei:back"/>
                </footer>
            </body>
        </html>
    </xsl:template>

    <!-- Header, file description, ... -->

    <xsl:template match="tei:fileDesc">
        <h3>File Description</h3>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <xsl:element name="div">
            Titolo: <xsl:value-of select="current()/tei:title[@xml:lang='it']"/>
        </xsl:element>
        <xsl:element name="div">
            Titolo originale: <xsl:value-of select="current()/tei:title[@xml:lang='fr']"/>
        </xsl:element>
        <xsl:apply-templates select="tei:respStmt"/>
    </xsl:template>
  
    <xsl:template match="tei:respStmt">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:editionStmt">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:edition">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:publicationStmt">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:sourceStmt">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Image Maps -->

    <xsl:template match="tei:facsimile">
        <xsl:for-each select="current()/tei:surface">
            <xsl:element name="div">
                <xsl:attribute name="class">item</xsl:attribute>
                <xsl:attribute name="data-reading">#<xsl:value-of select="@xml:id"/></xsl:attribute>

                <xsl:element name="img">
                    <xsl:attribute name="id">mappedImage</xsl:attribute>
                    <xsl:attribute name="src">./src/content/<xsl:value-of select="current()/tei:graphic/@url"/></xsl:attribute>
                    <xsl:attribute name="usemap">#map_<xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:element>
                <xsl:element name="map">
                    <xsl:attribute name="name">map_<xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:for-each select="current()/tei:zone">
                        <area shape="rect">
                            <xsl:attribute name="coords"><xsl:value-of select="concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)"/></xsl:attribute>
                            <xsl:attribute name="data-row">#<xsl:value-of select="@xml:id"/></xsl:attribute>
                        </area>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <!-- Front -->

    <xsl:template match="tei:body">
        <div class="reading-body">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='page']">
        <xsl:element name="div">
            <xsl:attribute name="id"><xsl:value-of select="../tei:pb[@n=current()/@n]/@facs"/></xsl:attribute>
            <xsl:attribute name="class">item</xsl:attribute>
            <h2>Foglio <xsl:value-of select="current()/@n"/></h2>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:ab">
        <xsl:element name="div">
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:subst">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:del">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:gap">
        <xsl:element name="del">
            <xsl:attribute name="data-reason"><xsl:value-of select="@reason"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="@extent">
                <xsl:attribute name="data-extent"><xsl:value-of select="@extent"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="data-extent">unknown</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="data-unit"><xsl:value-of select="@unit"/></xsl:attribute>
            [<xsl:value-of select="@reason"/>]
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:add">
        <xsl:choose>
            <xsl:when test="@place='above'">
                <xsl:element name="sup">
                    <xsl:attribute name="data-type">add</xsl:attribute>
                    <xsl:attribute name="data-place">above</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ins">
                    <xsl:attribute name="data-type">add</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:teiHeader//*[@ref!='']|tei:body//*[@ref!='']">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:element name="br"/>
        <xsl:element name="span">
            <xsl:attribute name="id">
                <xsl:value-of select="@facs" />
            </xsl:attribute>
            <xsl:value-of select="concat('[', @n, ']')"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div[@type='translation']">
        <xsl:element name="div">
            <xsl:element name="h2">
                <xsl:text>Translation</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Back -->

    <xsl:template match="tei:back">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='list']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:element name="h2">
            Glossario
        </xsl:element>

        <xsl:element name="ol">
            <xsl:apply-templates select="current()//tei:gloss"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:listPerson">
        <xsl:element name="h2">
            Persone
        </xsl:element>

        <xsl:element name="ol">
            <xsl:apply-templates select="current()//tei:persName"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:listOrg">
        <xsl:element name="h2">
            Istituzioni
        </xsl:element>

        <xsl:element name="ol">
            <xsl:apply-templates select="current()//tei:orgName"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:gloss | tei:note">
        <xsl:element name="li">
            <xsl:attribute name="id"><xsl:value-of select="substring(@target, 2)"/></xsl:attribute>
            <xsl:element name="span">
                <xsl:element name="strong">
                    <xsl:value-of select="//tei:term[@target=current()/@target]"/>:
                </xsl:element>
            </xsl:element>
            <xsl:element name="i">
                (<xsl:value-of select="//tei:term[@xml:id=substring(current()/@target, 2)]"/> in fr.)
            </xsl:element>
            <xsl:value-of select="current()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:persName">
        <xsl:element name="li">
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:element name="span">
                <xsl:element name="strong">
                    <xsl:value-of select="concat(current()/tei:forename, ' ', current()/tei:surname)"/>:
                </xsl:element>
                <xsl:if test="parent::node()/tei:birth">
                    <xsl:apply-templates select="parent::node()/tei:birth"/> - 
                    <xsl:apply-templates select="parent::node()/tei:death"/>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <xsl:element name="li">
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:element name="span">
                <xsl:element name="strong">
                    <xsl:value-of select="current()/tei:name"/>:
                </xsl:element>
                Nascita <xsl:apply-templates select="tei:date"/>
                a <xsl:value-of select="current()/tei:placeName"/>, <xsl:value-of select="current()/tei:country"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:birth">
        <xsl:element name="span">
            <xsl:value-of select="current()/tei:placeName"/>, <xsl:value-of select="current()/tei:country"/> il <xsl:value-of select="current()/tei:date"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:death">
        <xsl:element name="span">
            <xsl:value-of select="current()/tei:placeName"/>, <xsl:value-of select="current()/tei:country"/> il <xsl:value-of select="current()/tei:date"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:hi">
        <xsl:element name="strong">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:date">
        <xsl:element name="span">
            <xsl:attribute name="class">date</xsl:attribute>
            <xsl:value-of select="current()|current()[@when]"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>