<!-- 
  	XSLT transformation from RFC2629 XML format to XSL-FO
      
    Copyright (c) 2001-2004 Julian F. Reschke (julian.reschke@greenbytes.de)
      
    placed into the public domain
    
    change history:

    2003-11-16  julian.reschke@greenbytes.de

    Initial release.
    
    2003-11-29  julian.reschke@greenbytes.de
    
    Enhance handling of unknown list styles.

    2004-04-04  julian.reschke@greenbytes.de
    
    Update reference section handling.
    
    2004-04-17  julian.reschke@greenbytes.de
    
    Use XSL-WD-1.1-style fo:bookmark and index handling and add postprocessors for
    existing implementations. Unify PDF info generation by using XEP (postprocessors)
    will convert.
    
    2004-04-20  julian.reschke@greenbytes.de

    Add experimental cref support.
    
    2004-06-14  julian.reschke@greenbytes.de
    
    Set correct index-item defaults.
    
    2004-07-18  julian.reschke@greenbytes.de
    
    Add list style=letters.
    
    2004-09-03  julian.reschke@greenbytes.de
    
    Make URLs in text break where they are allowed to break by inserting
    zero-width spaces.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"

    xmlns:ed="http://greenbytes.de/2002/rfcedit"
    xmlns:myns="mailto:julian.reschke@greenbytes.de?subject=rcf2629.xslt"

    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:exslt="http://exslt.org/common"

    exclude-result-prefixes="msxsl exslt myns ed"
>

<xsl:import href="rfc2629.xslt" />

<xsl:output method="xml" version="1.0" />

<xsl:output method="xml" encoding="UTF-8" />

<xsl:attribute-set name="h1-inline">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
	<xsl:attribute name="font-size">14pt</xsl:attribute>
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="space-before">14pt</xsl:attribute>
	<xsl:attribute name="space-after">7pt</xsl:attribute>
</xsl:attribute-set> 

<xsl:attribute-set name="h1-new-page">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
	<xsl:attribute name="font-size">14pt</xsl:attribute>
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="space-after">7pt</xsl:attribute>
  <xsl:attribute name="page-break-before">always</xsl:attribute>
</xsl:attribute-set> 

<xsl:attribute-set name="h2">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
	<xsl:attribute name="font-size">12pt</xsl:attribute>
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="space-before">12pt</xsl:attribute>
	<xsl:attribute name="space-after">6pt</xsl:attribute>
</xsl:attribute-set> 

<xsl:attribute-set name="h3">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
	<xsl:attribute name="font-size">11pt</xsl:attribute>
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="space-before">11pt</xsl:attribute>
	<xsl:attribute name="space-after">3pt</xsl:attribute>
</xsl:attribute-set> 

<xsl:attribute-set name="comment">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
	<xsl:attribute name="background-color">yellow</xsl:attribute>
</xsl:attribute-set> 

<!--<xsl:attribute-set name="p">
	<xsl:attribute name="margin-left">2em</xsl:attribute>
</xsl:attribute-set>  -->

<xsl:attribute-set name="internal-link">
  <xsl:attribute name="color">#000080</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="external-link">
  <xsl:attribute name="color">blue</xsl:attribute>
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="abstract">
  <fo:block xsl:use-attribute-sets="h1-inline" id="{concat($anchor-prefix,'.abstract')}">Abstract</fo:block>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="artwork">
	<fo:block font-family="monospace" font-size="9pt" background-color="#dddddd"
    white-space-treatment="preserve" linefeed-treatment="preserve"
    white-space-collapse="false">
    <xsl:call-template name="showArtwork">
      <xsl:with-param name="mode" select="'fo'" />
      <xsl:with-param name="text" select="." />
      <xsl:with-param name="initial" select="'yes'" />
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="artwork[@src and starts-with(@type,'image/')]">
  <fo:external-graphic scaling-method="integer-pixels" src="url({@src})" />
</xsl:template>

<xsl:template match="author">
  <fo:block space-before="1em">
    <fo:wrapper font-weight="bold"><xsl:value-of select="@fullname" /></fo:wrapper>
    <xsl:if test="@role">
      <fo:wrapper> (<xsl:value-of select="@role" />)</fo:wrapper>
    </xsl:if>
  </fo:block>
  <fo:block><xsl:value-of select="organization" /></fo:block>
	<xsl:for-each select="address/postal/street">
    <fo:block><xsl:value-of select="." /></fo:block>
  </xsl:for-each>
	<xsl:if test="address/postal/city">
    <fo:block><xsl:value-of select="concat(address/postal/city,', ',address/postal/region,' ',address/postal/code)" /></fo:block>
	</xsl:if>
	<xsl:if test="address/postal/country">
    <fo:block><xsl:value-of select="address/postal/country" /></fo:block>
  </xsl:if>
	<xsl:if test="address/phone">
    <fo:block>Phone:&#0160;<fo:basic-link external-destination="url('tel:{translate(address/phone,' ','')}')" xsl:use-attribute-sets="external-link"><xsl:value-of select="address/phone" /></fo:basic-link></fo:block>
  </xsl:if>
	<xsl:if test="address/facsimile">
    <fo:block>Fax:&#0160;<fo:basic-link external-destination="url('tel:{translate(address/facsimile,' ','')}')" xsl:use-attribute-sets="external-link"><xsl:value-of select="address/facsimile" /></fo:basic-link></fo:block>
  </xsl:if>
	<xsl:if test="address/email">
    <fo:block>EMail:&#0160;
      <xsl:choose>
        <xsl:when test="$xml2rfc-linkmailto='no'">
            <xsl:value-of select="address/email" />
        </xsl:when>
        <xsl:otherwise>
          <fo:basic-link external-destination="url('mailto:{address/email}')" xsl:use-attribute-sets="external-link"><xsl:value-of select="address/email" /></fo:basic-link>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:if>
	<xsl:if test="address/uri">
    <fo:block>URI:&#0160;<fo:basic-link external-destination="url('{address/uri}')" xsl:use-attribute-sets="external-link"><xsl:value-of select="address/uri" /></fo:basic-link></fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="back">

	<!-- add references section first, no matter where it appears in the
    source document -->
	<!-- <xsl:apply-templates select="references" />  -->
           
  <xsl:call-template name="insertAuthors" />
  
  <!-- add all other top-level sections under <back> -->
	<xsl:apply-templates select="*[not(self::references)]" />

  <xsl:if test="not($xml2rfc-private)">
  	<!-- copyright statements -->
    <xsl:variable name="copyright"><xsl:call-template name="insertCopyright" /></xsl:variable>
  
    <!-- emit it -->
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:apply-templates select="msxsl:node-set($copyright)/node()" />
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:apply-templates select="exslt:node-set($copyright)/node()" />
      </xsl:when>
      <xsl:otherwise> <!--proceed with fingers crossed-->
        <xsl:variable name="temp" select="$copyright"/>
        <xsl:apply-templates select="$temp/node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  
</xsl:template>


<xsl:template match="figure">
  <fo:block space-before=".5em" space-after=".5em">
    <xsl:if test="not(ancestor::t)">
      <xsl:attribute name="start-indent">2em</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="add-anchor"/>
    <xsl:choose>
      <xsl:when test="@title!='' or @anchor!=''">
        <xsl:variable name="n"><xsl:number level="any" count="figure[@title!='' or @anchor!='']" /></xsl:variable>
        <fo:block id="{$anchor-prefix}.figure.{$n}" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="n"><xsl:number level="any" count="figure[not(@title!='' or @anchor!='')]" /></xsl:variable>
        <fo:block id="{$anchor-prefix}.figure.u.{$n}" />
      </xsl:otherwise>
    </xsl:choose>
  	<xsl:apply-templates />
    <xsl:if test="@title!='' or @anchor!=''">
      <xsl:variable name="n"><xsl:number level="any" count="figure[@title!='' or @anchor!='']" /></xsl:variable>
      <fo:block text-align="center" space-after="1em">Figure <xsl:value-of select="$n"/><xsl:if test="@title!=''">: <xsl:value-of select="@title" /></xsl:if></fo:block>
    </xsl:if>
  </fo:block>
</xsl:template>
            
<xsl:template match="front">

  <xsl:if test="$xml2rfc-topblock!='no'">
  	<!-- collect information for left column -->
      
  	<xsl:variable name="leftColumn">
      <xsl:call-template name="collectLeftHeaderColumn" />  
    </xsl:variable>
  
    <!-- collect information for right column -->
      
    <xsl:variable name="rightColumn">
      <xsl:call-template name="collectRightHeaderColumn" />    
    </xsl:variable>
      
      <!-- insert the collected information -->
      
  	<fo:table width="100%" table-layout="fixed">
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <xsl:choose>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:call-template name="emitheader">
  	         	<xsl:with-param name="lc" select="msxsl:node-set($leftColumn)" />    
      	     	<xsl:with-param name="rc" select="msxsl:node-set($rightColumn)" />    
            </xsl:call-template>
          </xsl:when>    
          <xsl:when test="function-available('exslt:node-set')">
           	<xsl:call-template name="emitheader">
  	         	<xsl:with-param name="lc" select="exslt:node-set($leftColumn)" />    
      	     	<xsl:with-param name="rc" select="exslt:node-set($rightColumn)" />    
            </xsl:call-template>
          </xsl:when>    
          <xsl:otherwise>    
           	<xsl:call-template name="emitheader">
  	         	<xsl:with-param name="lc" select="$leftColumn" />    
      	     	<xsl:with-param name="rc" select="$rightColumn" />    
            </xsl:call-template>
          </xsl:otherwise>    
        </xsl:choose>
  		</fo:table-body>
  	</fo:table>
  </xsl:if>
      
  <fo:block text-align="center" font-weight="bold" font-size="18pt" space-before="3em" space-after="3em">
    <xsl:value-of select="/rfc/front/title" />
    <xsl:if test="/rfc/@docName">
      <fo:block font-size="15pt"><xsl:value-of select="/rfc/@docName" /></fo:block>
    </xsl:if>
 </fo:block>
 
  <!-- Get status info formatted as per RFC2629-->
  <xsl:if test="not($xml2rfc-private)">
    <xsl:variable name="preamble"><xsl:call-template name="insertPreamble" /></xsl:variable>
    
    <!-- emit it -->
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:apply-templates select="msxsl:node-set($preamble)/node()" />
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:apply-templates select="exslt:node-set($preamble)/node()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="temp" select="$preamble"/>
        <xsl:apply-templates select="$temp/node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  
	<xsl:apply-templates select="abstract" />
	<xsl:apply-templates select="note" />

	<xsl:if test="$xml2rfc-toc='yes'">
		<xsl:apply-templates select="/" mode="toc" />
		<!--<xsl:call-template name="insertTocAppendix" />-->
	</xsl:if>

</xsl:template>
   
<xsl:template match="eref[node()]">
  <fo:basic-link external-destination="url('{@target}')" xsl:use-attribute-sets="external-link">
    <xsl:apply-templates />
  </fo:basic-link>
  <fo:footnote>
    <fo:inline font-size="6pt" vertical-align="super"><xsl:number level="any" count="eref[node()]" /></fo:inline>
    <fo:footnote-body>
      <fo:block font-size="8pt" start-indent="2em" text-align="left">
        <fo:inline font-size="6pt" vertical-align="super"><xsl:number level="any" count="eref[node()]" /></fo:inline>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@target" />
      </fo:block>
    </fo:footnote-body>
  </fo:footnote>
</xsl:template>

<xsl:template match="eref[not(node())]">
  <xsl:text>&lt;</xsl:text>
  <fo:basic-link external-destination="url('{@target}')" xsl:use-attribute-sets="external-link">
    <xsl:call-template name="format-uri">
      <xsl:with-param name="s" select="@target"/>
    </xsl:call-template>
  </fo:basic-link>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<!-- processed in a later stage -->
<xsl:template match="iref[not(ancestor::t) and not(parent::section)]">
	<fo:block>
    <xsl:attribute name="id"><xsl:value-of select="$anchor-prefix" />.iref.<xsl:number level="any"/></xsl:attribute>
    <xsl:choose>
      <xsl:when test="@primary='true'">
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem,',primary')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem)"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="iref[parent::section]">
  <!-- processed on section level -->
</xsl:template>

<xsl:template match="iref[ancestor::t and not(parent::section)]">
	<fo:inline>
    <xsl:attribute name="id"><xsl:value-of select="$anchor-prefix" />.iref.<xsl:number level="any"/></xsl:attribute>
    <xsl:choose>
      <xsl:when test="@primary='true'">
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem,',primary')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem)"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<xsl:template match="iref" mode="iref-start">
  <fo:begin-index-range>
    <xsl:attribute name="id"><xsl:value-of select="$anchor-prefix" />.iref.<xsl:number level="any"/></xsl:attribute>
    <xsl:choose>
      <xsl:when test="@primary='true'">
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem,',primary')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="index-key">
          <xsl:value-of select="concat('item=',@item,',subitem=',@subitem)"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </fo:begin-index-range>
</xsl:template>

<xsl:template match="iref" mode="iref-end">
  <fo:end-index-range>
    <xsl:attribute name="ref-id"><xsl:value-of select="$anchor-prefix" />.iref.<xsl:number level="any"/></xsl:attribute>
  </fo:end-index-range>
</xsl:template>

<xsl:template match="list[@style='hanging']" priority="1">
  <!-- find longest label and use it to calculate indentation-->
  <xsl:variable name="l">
    <xsl:for-each select="t">
      <xsl:sort select="string-length(@hangText)" order="descending" data-type="number"/>
      <xsl:if test="position()=1">
        <xsl:value-of select="@hangText" />
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <fo:list-block provisional-distance-between-starts="{string-length($l)}em">
    <xsl:apply-templates />
  </fo:list-block>
</xsl:template>

<xsl:template match="list[@style='hanging']/t" priority="1">
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()"><fo:block><xsl:value-of select="@hangText" /></fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="list[@style='symbols']" priority="1">
  <fo:list-block provisional-distance-between-starts="1.5em">
    <xsl:apply-templates />
  </fo:list-block>
</xsl:template>

<xsl:template match="list[@style='symbols']/t" priority="1">
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()"><fo:block>&#x2022;</fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="list">
  <xsl:if test="@style!='' and @style!='empty' and @style">
    <xsl:message>WARNING: unknown style '<xsl:value-of select="@style"/>' for list, continueing with default format.</xsl:message>
  </xsl:if>
  <fo:list-block provisional-distance-between-starts="2em">
    <xsl:apply-templates />
  </fo:list-block>
</xsl:template>

<xsl:template match="list/t">
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()"><fo:block></fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="list[@style='numbers' or @style='letters']" priority="1">
  <fo:list-block provisional-distance-between-starts="1.5em">
    <xsl:apply-templates />
  </fo:list-block>
</xsl:template>

<xsl:template match="list[@style='numbers']/t" priority="1">
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()"><fo:block><xsl:number/>.</fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="list[@style='letters']/t" priority="1">
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()"><fo:block><xsl:number format="a"/>.</fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="list[starts-with(@style,'format ')]" priority="1">
  <fo:list-block provisional-distance-between-starts="{string-length(@style) - string-length('format ')}em">
    <xsl:apply-templates />
  </fo:list-block>
</xsl:template>

<xsl:template match="list[starts-with(@style,'format ') and (contains(@style,'%c') or contains(@style,'%d'))]/t" priority="1">
  <xsl:variable name="list" select=".." />
  <xsl:variable name="format" select="substring-after(../@style,'format ')" />
  <xsl:variable name="pos">
    <xsl:choose>
      <xsl:when test="$list/@counter">
        <xsl:number level="any" count="list[@counter=$list/@counter or (not(@counter) and @style=concat('format ',$list/@counter))]/t" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="any" count="list[concat('format ',@counter)=$list/@style or (not(@counter) and @style=$list/@style)]/t" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item space-before=".25em" space-after=".25em">
    <fo:list-item-label end-indent="label-end()">
      <fo:block>
        <xsl:choose>
          <xsl:when test="contains($format,'%c')">
            <xsl:value-of select="substring-before($format,'%c')"/><xsl:number value="$pos" format="a" /><xsl:value-of select="substring-after($format,'%c')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($format,'%d')"/><xsl:number value="$pos" format="1" /><xsl:value-of select="substring-after($format,'%d')"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates />
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="middle">
	<xsl:apply-templates />
  <xsl:apply-templates select="../back/references" />
</xsl:template>
               
<xsl:template match="note">
  <xsl:variable name="num"><xsl:number count="note"/></xsl:variable>
  <fo:block xsl:use-attribute-sets="h1-inline" id="{concat($anchor-prefix,'.note.',$num)}"><xsl:value-of select="@title" /></fo:block>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="preamble">
	<fo:block space-after=".5em"><xsl:apply-templates /></fo:block>
</xsl:template>

<xsl:template match="postamble">
	<fo:block space-before=".5em"><xsl:apply-templates /></fo:block>
</xsl:template>

<xsl:template match="reference">

  <xsl:variable name="target">
    <xsl:choose>
      <xsl:when test="@target"><xsl:value-of select="@target" /></xsl:when>
			<xsl:when test="seriesInfo/@name='RFC'"><xsl:value-of select="concat($rfcUrlPrefix,seriesInfo[@name='RFC']/@value,'.txt')" /></xsl:when>
			<xsl:when test="seriesInfo[starts-with(.,'RFC')]">
        <xsl:variable name="rfcRef" select="seriesInfo[starts-with(.,'RFC')]" />
	      <xsl:value-of select="concat($rfcUrlPrefix,substring-after (normalize-space($rfcRef), ' '),'.txt')" />
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
	</xsl:variable>

  <fo:list-item space-after=".5em">
    <fo:list-item-label end-indent="label-end()">
      <fo:block id="{@anchor}">
        <xsl:call-template name="referencename">
          <xsl:with-param name="node" select="." />
        </xsl:call-template>
      </fo:block>
    </fo:list-item-label>
		
    <fo:list-item-body start-indent="body-start()"><fo:block>

      <xsl:for-each select="front/author">
        <xsl:choose>
          <xsl:when test="@surname and @surname!=''">
    				<xsl:choose>
              <xsl:when test="@surname and position()=last() and position()!=1">
                <xsl:value-of select="concat(@initials,' ',@surname)" />
              </xsl:when>
              <xsl:when test="@surname">
                <xsl:value-of select="concat(@surname,', ',@initials)" />
              </xsl:when>
    					<xsl:when test="organization/text()">
                <xsl:value-of select="organization" />
              </xsl:when>
              <xsl:otherwise />
            </xsl:choose>
            <xsl:if test="@role='editor'">
              <xsl:text>, Ed.</xsl:text>
            </xsl:if>
            <xsl:if test="position()!=last() - 1">,&#0160;</xsl:if>
            <xsl:if test="position()=last() - 1"> and </xsl:if>
          </xsl:when>
          <xsl:when test="organization/text()">
            <xsl:value-of select="organization" />
            <xsl:if test="position()!=last() - 1">,&#0160;</xsl:if>
            <xsl:if test="position()=last() - 1"> and </xsl:if>
          </xsl:when>
          <xsl:otherwise />
        </xsl:choose>
      </xsl:for-each>

      <xsl:text>"</xsl:text>
      <xsl:choose>
        <xsl:when test="string-length($target) &gt; 0">
          <fo:basic-link external-destination="url('{$target}')" xsl:use-attribute-sets="external-link"><xsl:value-of select="front/title" /></fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="front/title" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>"</xsl:text>
      
      <xsl:if test="@target">
        <xsl:text>, &lt;</xsl:text>
        <xsl:call-template name="format-uri">
          <xsl:with-param name="s" select="@target"/>
        </xsl:call-template>
        <xsl:text>&gt;</xsl:text>
      </xsl:if>

      <xsl:for-each select="seriesInfo">
        <xsl:text>, </xsl:text>
        <xsl:choose>
          <xsl:when test="not(@name) and not(@value) and ./text()"><xsl:value-of select="." /></xsl:when>
					<xsl:otherwise>
            <xsl:value-of select="@name" />
            <xsl:if test="@value!=''">&#0160;<xsl:value-of select="@value" /></xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="front/date/@year!=''">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="front/date/@month" />&#0160;<xsl:value-of select="front/date/@year" />
      </xsl:if>
      
      <xsl:text>.</xsl:text>
      
      <xsl:for-each select="annotation">
        <fo:block><xsl:apply-templates /></fo:block>
      </xsl:for-each>
      
    </fo:block></fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="references">

  <xsl:variable name="name">
    <xsl:number/>      
  </xsl:variable>

  <!-- insert pseudo section when needed -->
  <xsl:if test="$name='1' and count(/*/back/references)!=1">
    <fo:block id="{$anchor-prefix}.references" xsl:use-attribute-sets="h1-inline">
      <xsl:if test="$name='1'">
        <xsl:attribute name="page-break-before">always</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
      </xsl:if>
      <xsl:variable name="sectionNumber">
        <xsl:call-template name="get-references-section-number"/>
      </xsl:variable>
      <xsl:value-of select="$sectionNumber"/>&#160;&#160;References
    </fo:block>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="count(/*/back/references)=1">
      <fo:block id="{$anchor-prefix}.references" xsl:use-attribute-sets="h1-inline">
        <xsl:attribute name="page-break-before">always</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:call-template name="get-section-number"/>&#160;&#160;
        <xsl:choose>
          <xsl:when test="@title!=''"><xsl:value-of select="@title"/></xsl:when>
          <xsl:otherwise>References</xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$anchor-prefix}.references.{$name}" xsl:use-attribute-sets="h2">
        <xsl:call-template name="get-section-number"/>&#160;&#160;
        <xsl:choose>
          <xsl:when test="@title!=''"><xsl:value-of select="@title"/></xsl:when>
          <xsl:otherwise>References</xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>

  <!-- find longest label and use it to calculate indentation-->
  <xsl:variable name="l">
    <xsl:choose>
      <xsl:when test="$xml2rfc-symrefs!='yes'">[99]</xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="//reference">
          <xsl:sort select="string-length(@anchor)" order="descending" data-type="number"/>
          <xsl:if test="position()=1">
            <xsl:value-of select="@anchor" />
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:list-block provisional-distance-between-starts="{string-length($l) * 0.75}em">
    <xsl:choose>
      <xsl:when test="$xml2rfc-sortrefs='yes'">
        <xsl:apply-templates>
          <xsl:sort select="@anchor" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </fo:list-block>
</xsl:template>

<xsl:template match="rfc">
	<fo:root font-family="serif" font-size="10pt">
    
    <!-- insert PDF information (XEP extension) -->
    <meta-info xmlns="http://www.renderx.com/XSL/Extensions">
      <!-- title -->
      <meta-field name="title" value="{/rfc/front/title}"/>
      <!-- keywords -->
      <xsl:if test="/rfc/front/keyword">
        <xsl:variable name="keyw">
          <xsl:call-template name="get-keywords" />
        </xsl:variable>
        <meta-field name="keywords" value="{$keyw}" />
      </xsl:if>
      <xsl:variable name="auth">
        <xsl:call-template name="get-author-summary" />
      </xsl:variable>
      <meta-field name="author" value="{$auth}" />
    </meta-info>

		<fo:layout-master-set>
      <!-- page sizes as per RFC2223bis-00 -->
			<fo:simple-page-master master-name="first-page" margin-left="1in" margin-right="1in" page-height="11in" page-width="8.5in">
        <fo:region-body margin-bottom="1in" margin-top="1in"/>
   	    <fo:region-after extent="1cm" region-name="footer"/>
      </fo:simple-page-master>
			<fo:simple-page-master master-name="other-pages" margin-left="1in" margin-right="1in" page-height="11in" page-width="8.5in">
        <fo:region-body margin-bottom="1in" margin-top="1in" />
				<fo:region-before extent="1cm" region-name="header"/>
				<fo:region-after extent="1cm" region-name="footer"/>
      </fo:simple-page-master>
			<fo:simple-page-master master-name="other-pages-dc" margin-left="1in" margin-right="1in" page-height="11in" page-width="8.5in">
        <fo:region-body margin-bottom="1in" margin-top="1in" column-count="2"/>
				<fo:region-before extent="1cm" region-name="header"/>
				<fo:region-after extent="1cm" region-name="footer"/>
      </fo:simple-page-master>
			<fo:page-sequence-master master-name="sequence">  
				<fo:single-page-master-reference master-reference="first-page" />
				<fo:repeatable-page-master-reference master-reference="other-pages" />  
			</fo:page-sequence-master> 
		</fo:layout-master-set>

    <fo:bookmark-tree>
      <xsl:apply-templates select="." mode="bookmarks" />
    </fo:bookmark-tree>

    <xsl:variable name="lang"><xsl:call-template name="get-lang"/></xsl:variable>

		<fo:page-sequence master-reference="sequence" language="{$lang}">

      <xsl:call-template name="insertHeader" />
      <xsl:call-template name="insertFooter" />
     
			<fo:flow flow-name="xsl-region-body">
				<xsl:apply-templates />    
			</fo:flow>
    </fo:page-sequence>
    
    <xsl:if test="//iref">
      <fo:page-sequence master-reference="other-pages-dc" language="{$lang}">
        <xsl:call-template name="insertHeader" />
        <xsl:call-template name="insertFooter" />
	  		<fo:flow flow-name="xsl-region-body" font-size="9pt">
		  		<xsl:call-template name="insertIndex" />    
			  </fo:flow>
      </fo:page-sequence>
    </xsl:if>
    
	</fo:root>
</xsl:template>


<xsl:template name="section-maker">
  <xsl:variable name="sectionNumber">
    <xsl:if test="not(@myns:unnumbered)"><xsl:call-template name="get-section-number" /></xsl:if>
  </xsl:variable>

  <xsl:if test="$sectionNumber!=''">
    <xsl:attribute name="id"><xsl:value-of select="concat($anchor-prefix,'.section.',$sectionNumber)"/>
  </xsl:attribute></xsl:if>
  
  <xsl:call-template name="add-anchor" />
  
  <xsl:if test="$sectionNumber!=''"><xsl:value-of select="$sectionNumber" />&#0160;&#0160;</xsl:if>
  <xsl:value-of select="@title" />

</xsl:template>

<xsl:template match="section[count(ancestor::section) = 0 and @myns:notoclink]">

  <fo:block xsl:use-attribute-sets="h1-inline">
    <xsl:call-template name="section-maker" />
  </fo:block>

  <xsl:apply-templates select="iref" mode="iref-start"/>
  <xsl:apply-templates />
  <xsl:apply-templates select="iref" mode="iref-end"/>
</xsl:template>

<xsl:template match="section[count(ancestor::section) = 0 and not(@myns:notoclink)]">

  <fo:block xsl:use-attribute-sets="h1-new-page">
    <xsl:call-template name="section-maker" />
  </fo:block>

  <xsl:apply-templates select="iref" mode="iref-start"/>
  <xsl:apply-templates />
  <xsl:apply-templates select="iref" mode="iref-end"/>
</xsl:template>

<xsl:template match="section[count(ancestor::section) = 1]">
  <fo:block xsl:use-attribute-sets="h2">
    <xsl:call-template name="section-maker" />
  </fo:block>

  <xsl:apply-templates select="iref" mode="iref-start"/>
  <xsl:apply-templates />
  <xsl:apply-templates select="iref" mode="iref-end"/>
</xsl:template>

<xsl:template match="section[count(ancestor::section) &gt; 1]">
  <fo:block xsl:use-attribute-sets="h3">
    <xsl:call-template name="section-maker" />
  </fo:block>

  <xsl:apply-templates select="iref" mode="iref-start"/>
  <xsl:apply-templates />
  <xsl:apply-templates select="iref" mode="iref-end"/>
</xsl:template>

<xsl:template match="spanx[@style='emph' or not(@style)]">
  <fo:wrapper font-style="italic"><xsl:apply-templates /></fo:wrapper>
</xsl:template>

<xsl:template match="spanx[@style='strong']">
  <fo:wrapper font-weight="bold"><xsl:apply-templates /></fo:wrapper>
</xsl:template>

<xsl:template match="spanx[@style='verb']">
  <fo:wrapper font-family="monospace"><xsl:apply-templates/></fo:wrapper>
</xsl:template>

<xsl:template match="t">
	<fo:block space-before=".5em" space-after=".5em" start-indent="2em">
    <xsl:apply-templates />
  </fo:block>
</xsl:template>
               
<xsl:template match="vspace">
  <fo:block/>
</xsl:template>

<xsl:template match="xref[node()]">
	<xsl:variable name="target" select="@target" />
  <xsl:variable name="node" select="//*[@anchor=$target]" />
  <fo:basic-link internal-destination="{$target}" xsl:use-attribute-sets="internal-link">
    <xsl:value-of select="." />
  </fo:basic-link>
  <xsl:for-each select="//reference[@anchor=$target]">
    &#160;<xsl:call-template name="referencename"><xsl:with-param name="node" select="." /></xsl:call-template>
  </xsl:for-each>
</xsl:template>

<xsl:template match="xref[not(node())]">
  <xsl:variable name="context" select="." />
	<xsl:variable name="target" select="@target" />
  <xsl:variable name="node" select="//*[@anchor=$target]" />
	<!-- should check for undefined targets -->
	<!-- should check for undefined targets -->
  <fo:basic-link internal-destination="{$target}" xsl:use-attribute-sets="internal-link">
    <xsl:choose>
      <xsl:when test="local-name($node)='section'">
        <xsl:variable name="refname">
          <xsl:for-each select="$node">
            <xsl:call-template name="get-section-type">
              <xsl:with-param name="prec" select="$context/preceding-sibling::node()[1]" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="refnum">
          <xsl:for-each select="$node">
            <xsl:call-template name="get-section-number" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="@format='counter'">
            <xsl:value-of select="$refnum"/>
          </xsl:when>
          <xsl:when test="@format='title'">
            <xsl:value-of select="$node/@title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(concat($refname,'&#160;',$refnum))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="local-name($node)='figure'">
        <xsl:variable name="figcnt">
          <xsl:for-each select="$node">
            <xsl:number level="any" count="figure[@title!='' or @anchor!='']" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="@format='counter'">
            <xsl:value-of select="$figcnt" />
          </xsl:when>
          <xsl:when test="@format='title'">
            <xsl:value-of select="$node/@title" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(concat('Figure&#160;',$figcnt))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="referencename"><xsl:with-param name="node" select="/rfc/back/references/reference[@anchor=$target]" /></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </fo:basic-link>
</xsl:template>

<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="*">
  <fo:block font-weight="bold">UNKNOWN ELEMENT <xsl:value-of select="local-name()" /></fo:block>
  <xsl:message>UNKNOWN ELEMENT: <xsl:value-of select="local-name()" /></xsl:message>
  <xsl:apply-templates />
</xsl:template>

<xsl:template name="emitheader">
	<xsl:param name="lc" />
	<xsl:param name="rc" />

	<xsl:for-each select="$lc/myns:item | $rc/myns:item">
    <xsl:variable name="pos" select="position()" />
    <xsl:if test="$pos &lt; count($lc/myns:item) + 1 or $pos &lt; count($rc/myns:item) + 1"> 
      <fo:table-row>
        <fo:table-cell>
          <fo:block>
            <xsl:apply-templates select="$lc/myns:item[$pos]/node()" mode="simple-html" /> 
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block text-align="right">
            <xsl:apply-templates select="$rc/myns:item[$pos]/node()" mode="simple-html" /> 
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
	</xsl:for-each>
</xsl:template>


<xsl:template match="text()" mode="simple-html">
  <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="a" mode="simple-html">
  <fo:basic-link external-destination="url('{@href}')" xsl:use-attribute-sets="external-link">
    <xsl:apply-templates />
  </fo:basic-link>
</xsl:template>


<!-- produce back section with author information -->
<xsl:template name="insertAuthors">

	<fo:block id="{$anchor-prefix}.authors" xsl:use-attribute-sets="h1-new-page">
    Author's Address<xsl:if test="count(/rfc/front/author) &gt; 1">es</xsl:if>
  </fo:block>

  <xsl:apply-templates select="/rfc/front/author" />
</xsl:template>


<!-- generate the index section -->

<xsl:template name="insertIndex">

	<fo:block xsl:use-attribute-sets="h1-new-page" id="{$anchor-prefix}.index">
    Index
  </fo:block>

  <xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="ucase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />       
	
  <xsl:for-each select="//iref[generate-id(.) = generate-id(key('index-first-letter',translate(substring(@item,1,1),$lcase,$ucase)))]">
	  <xsl:sort select="translate(@item,$lcase,$ucase)" />
            
      <fo:block space-before="1em" font-weight="bold">
        <xsl:value-of select="translate(substring(@item,1,1),$lcase,$ucase)" />
      </fo:block>
            
      <xsl:for-each select="key('index-first-letter',translate(substring(@item,1,1),$lcase,$ucase))">
				<xsl:sort select="translate(@item,$lcase,$ucase)" />
    
    	  <xsl:if test="generate-id(.) = generate-id(key('index-item',@item))">
    
          <fo:block start-indent="1em" hyphenate="true">
            <xsl:value-of select="concat(@item,' ')" />
            
            <xsl:variable name="entries" select="key('index-item',@item)[not(@subitem) or @subitem='']" />
                                    
            <xsl:if test="$entries">
              <fo:page-index>
                <xsl:if test="$entries[@primary='true']">
                  <fo:index-item create-index-link="true" merge-sequential-index-page-numbers="true" ref-index-key="{concat('item=',@item,',subitem=',@subitem,',primary')}" font-weight="bold"/>
                </xsl:if>
                <xsl:if test="$entries[not(@primary='true')]">
                  <fo:index-item create-index-link="true" merge-sequential-index-page-numbers="true" ref-index-key="{concat('item=',@item,',subitem=',@subitem)}"/>
                </xsl:if>
              </fo:page-index>
            </xsl:if>

          </fo:block>
                
          <xsl:for-each select="key('index-item',@item)[@subitem and @subitem!='']">
					  <xsl:sort select="translate(@subitem,$lcase,$ucase)" />
		      
        	  <xsl:if test="generate-id(.) = generate-id(key('index-item-subitem',concat(@item,'..',@subitem)))">
            <fo:block start-indent="2em" hyphenate="true">
            
              <xsl:value-of select="concat(@subitem,' ')" />

              <xsl:variable name="entries2" select="key('index-item-subitem',concat(@item,'..',@subitem))" />
              
              <xsl:if test="$entries2">
                <fo:page-index>
                  <xsl:if test="$entries2[@primary='true']">
                    <fo:index-item create-index-link="true" merge-sequential-index-page-numbers="true" ref-index-key="{concat('item=',@item,',subitem=',@subitem,',primary')}" font-weight="bold"/>
                  </xsl:if>
                  <xsl:if test="$entries2[not(@primary='true')]">
                    <fo:index-item create-index-link="true" merge-sequential-index-page-numbers="true" ref-index-key="{concat('item=',@item,',subitem=',@subitem)}" link-back="true"/>
                  </xsl:if>
                </fo:page-index>
              </xsl:if>

            </fo:block>
          </xsl:if>
        </xsl:for-each>
                
      </xsl:if>
                
    </xsl:for-each>            
  </xsl:for-each>
</xsl:template>



<xsl:template match="/" mode="toc">
	<fo:block xsl:use-attribute-sets="h1-new-page" id="{concat($anchor-prefix,'.toc')}">
    <xsl:attribute name="page-break-before">always</xsl:attribute>
    Table of Contents
  </fo:block>

  <xsl:apply-templates mode="toc" />
</xsl:template>

<xsl:template name="insertTocLine">
  <xsl:param name="number" />
  <xsl:param name="target" />
  <xsl:param name="title" />
  <xsl:param name="tocparam" />
  
  <xsl:variable name="depth" select="string-length(translate($number,'.ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890&#167;','.'))" />
  
  <!-- handle tocdepth parameter -->
  <xsl:choose>
    <xsl:when test="($tocparam='' or $tocparam='default') and string-length(translate($number,'.ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890&#167;','.')) &gt;= $parsedTocDepth">
      <!-- dropped entry because of depth-->
    </xsl:when>
    <xsl:when test="$tocparam='exclude'">
      <!-- dropped entry because excluded -->
    </xsl:when>
    <xsl:when test="$depth = 0">
      <fo:block space-before="1em" font-weight="bold" text-align-last="justify">
        <xsl:value-of select="$number" />&#0160;&#0160;<fo:basic-link internal-destination="{$target}" xsl:use-attribute-sets="internal-link"><xsl:value-of select="$title"/></fo:basic-link>
        <fo:leader leader-pattern="dots"/>
        <fo:page-number-citation ref-id="{$target}"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth = 1">
      <fo:block space-before="0.5em" text-align-last="justify">
        <xsl:value-of select="$number" />&#0160;&#0160;&#0160;&#0160;<fo:basic-link internal-destination="{$target}" xsl:use-attribute-sets="internal-link"><xsl:value-of select="$title"/></fo:basic-link>
        <fo:leader leader-pattern="dots"/>
        <fo:page-number-citation ref-id="{$target}"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block text-align-last="justify">
        &#0160;&#0160;<xsl:value-of select="$number" />&#0160;&#0160;&#0160;&#0160;<fo:basic-link internal-destination="{$target}" xsl:use-attribute-sets="internal-link"><xsl:value-of select="$title"/></fo:basic-link>
        <fo:leader leader-pattern="dots"/>
        <fo:page-number-citation ref-id="{$target}"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!--
<xsl:template name="rfclist">
	<xsl:param name="list" />
	<xsl:choose>
    	<xsl:when test="contains($list,',')">
        	<xsl:variable name="rfcNo" select="substring-before($list,',')" />
        	<a href="{concat($rfcUrlPrefix,$rfcNo,'.txt')}"><xsl:value-of select="$rfcNo" /></a>,
        	<xsl:call-template name="rfclist">
            	<xsl:with-param name="list" select="normalize-space(substring-after($list,','))" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        	<xsl:variable name="rfcNo" select="$list" />
        	<a href="{concat($rfcUrlPrefix,$rfcNo,'.txt')}"><xsl:value-of select="$rfcNo" /></a>
       	</xsl:otherwise>
    </xsl:choose>
</xsl:template>
-->

<xsl:template name="insertHeader">
  <fo:static-content flow-name="header">
    <xsl:variable name="left">
      <xsl:call-template name="get-header-left" />
    </xsl:variable>
    <xsl:variable name="center">
      <xsl:call-template name="get-header-center" />
    </xsl:variable>
    <xsl:variable name="right">
      <xsl:call-template name="get-header-right" />
    </xsl:variable>
    <fo:table width="100%" text-align="center" space-before=".2cm" table-layout="fixed">
      <fo:table-column column-width="proportional-column-width({(string-length($left)+string-length($right)) div 2})" />
      <fo:table-column column-width="proportional-column-width({string-length($center)})" />
      <fo:table-column column-width="proportional-column-width({(string-length($left)+string-length($right)) div 2})" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block text-align="start">
              <xsl:value-of select="$left" />
   	        </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center">
            <fo:block>
              <xsl:value-of select="$center" />
   	        </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="end">
            <fo:block>
              <xsl:value-of select="$right" />
   	        </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:static-content>
</xsl:template>

<xsl:template name="insertFooter">
  <fo:static-content flow-name="footer">
    <xsl:variable name="left">
      <xsl:call-template name="get-author-summary" />
    </xsl:variable>
    <xsl:variable name="center">
      <xsl:call-template name="get-category-long" />
    </xsl:variable>
    <xsl:variable name="right">[Page 999]</xsl:variable>
    <fo:table text-align="center" width="100%" table-layout="fixed">
      <fo:table-column column-width="proportional-column-width({(string-length($left)+string-length($right)) div 2})" />
      <fo:table-column column-width="proportional-column-width({string-length($center)})" />
      <fo:table-column column-width="proportional-column-width({(string-length($left)+string-length($right)) div 2})" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block text-align="start">
              <xsl:value-of select="$left" />
 	          </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="center">
              <xsl:value-of select="$center" />
 	          </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="end">[Page <fo:page-number />]</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:static-content>
</xsl:template>

<!-- change tracking -->

<xsl:template match="ed:del" />
<xsl:template match="ed:issue" />
<xsl:template match="ed:ins">
  <xsl:apply-templates />
</xsl:template>
<xsl:template match="ed:replace">
  <xsl:apply-templates />
</xsl:template>

<!-- extensions -->

<xsl:template match="ed:link" />


<!-- Specials for XEP -->

<xsl:template match="node()" mode="bookmarks">
  <xsl:apply-templates mode="bookmarks"/>
</xsl:template>

<xsl:template match="abstract" mode="bookmarks">
  <fo:bookmark internal-destination="{concat($anchor-prefix,'.abstract')}">
    <fo:bookmark-title>Abstract</fo:bookmark-title>
    <xsl:apply-templates mode="bookmarks"/>
  </fo:bookmark>
</xsl:template>

<xsl:template match="note" mode="bookmarks">
  <xsl:variable name="num">
    <xsl:number count="note" />
  </xsl:variable>
  <fo:bookmark internal-destination="{concat($anchor-prefix,'.note.',$num)}">
    <fo:bookmark-title><xsl:value-of select="@title"/></fo:bookmark-title>
    <xsl:apply-templates mode="bookmarks"/>
  </fo:bookmark>
</xsl:template>

<xsl:template match="section[not(@myns:unnumbered)]" mode="bookmarks">
  <xsl:variable name="sectionNumber"><xsl:call-template name="get-section-number" /></xsl:variable>
  <fo:bookmark internal-destination="{$anchor-prefix}.section.{$sectionNumber}">
    <fo:bookmark-title><xsl:value-of select="concat($sectionNumber,' ',@title)"/></fo:bookmark-title>
    <xsl:apply-templates mode="bookmarks"/>
  </fo:bookmark>
</xsl:template>

<xsl:template match="section[@myns:unnumbered]" mode="bookmarks">
  <fo:bookmark internal-destination="{@anchor}">
    <fo:bookmark-title><xsl:value-of select="@title"/></fo:bookmark-title>
    <xsl:apply-templates mode="bookmarks"/>
  </fo:bookmark>
</xsl:template>

<xsl:template match="back" mode="bookmarks">
  <xsl:apply-templates select="/rfc/front" mode="bookmarks" />
  <xsl:apply-templates select="*[not(self::references)]" mode="bookmarks" />

  <xsl:if test="not($xml2rfc-private)">
    <!-- copyright statements -->
    <fo:bookmark internal-destination="{concat($anchor-prefix,'.ipr')}">
      <fo:bookmark-title>Intellectual Property and Copyright Statements</fo:bookmark-title>
    </fo:bookmark>
  </xsl:if>
  
  <!-- insert the index if index entries exist -->
  <xsl:if test="//iref">
    <fo:bookmark internal-destination="{concat($anchor-prefix,'.index')}">
      <fo:bookmark-title>Index</fo:bookmark-title>
    </fo:bookmark>
  </xsl:if>
</xsl:template>

<xsl:template match="front" mode="bookmarks">
  <xsl:variable name="title">
    <xsl:if test="count(author)=1">Author's Address</xsl:if>
    <xsl:if test="count(author)!=1">Author's Addresses</xsl:if>
  </xsl:variable>

  <fo:bookmark internal-destination="{concat($anchor-prefix,'.authors')}">
    <fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
  </fo:bookmark>
</xsl:template>

<xsl:template match="middle" mode="bookmarks">
  <xsl:apply-templates mode="bookmarks" />
  <xsl:call-template name="references-bookmarks" />
</xsl:template>

<xsl:template name="references-bookmarks">

  <!-- distinguish two cases: (a) single references element (process
  as toplevel section; (b) multiple references sections (add one toplevel
  container with subsection) -->

  <xsl:choose>
    <xsl:when test="count(/*/back/references) = 1">
      <xsl:for-each select="/*/back/references">
        <xsl:variable name="title">
          <xsl:choose>
            <xsl:when test="@title!=''"><xsl:value-of select="@title" /></xsl:when>
            <xsl:otherwise>References</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
      
        <fo:bookmark internal-destination="{$anchor-prefix}.references">
          <fo:bookmark-title><xsl:call-template name="get-references-section-number"/><xsl:text> </xsl:text><xsl:value-of select="$title"/></fo:bookmark-title>
        </fo:bookmark>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <!-- insert pseudo container -->    
      <fo:bookmark internal-destination="{$anchor-prefix}.references">
        <fo:bookmark-title><xsl:call-template name="get-references-section-number"/><xsl:text> References</xsl:text></fo:bookmark-title>

        <!-- ...with subsections... -->    
        <xsl:for-each select="/*/back/references">
          <xsl:variable name="title">
            <xsl:choose>
              <xsl:when test="@title!=''"><xsl:value-of select="@title" /></xsl:when>
              <xsl:otherwise>References</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        
          <xsl:variable name="sectionNumber">
            <xsl:call-template name="get-section-number" />
          </xsl:variable>
  
          <xsl:variable name="num">
            <xsl:number/>
          </xsl:variable>
  
          <fo:bookmark internal-destination="{$anchor-prefix}.references.{$num}">
            <fo:bookmark-title><xsl:value-of select="concat($sectionNumber,' ',$title)"/></fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rfc" mode="bookmarks">
  <xsl:if test="not($xml2rfc-private)">
    <!-- Get status info formatted as per RFC2629-->
    <xsl:variable name="preamble"><xsl:call-template name="insertPreamble" /></xsl:variable>
    
    <!-- emit it -->
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:apply-templates select="msxsl:node-set($preamble)/node()" mode="bookmarks"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:apply-templates select="exslt:node-set($preamble)/node()" mode="bookmarks"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="temp" select="$preamble"/>
        <xsl:apply-templates select="$temp/node()" mode="bookmarks"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  
  <xsl:apply-templates select="front/abstract" mode="bookmarks"/>
  <xsl:apply-templates select="front/note" mode="bookmarks"/>

  <xsl:if test="$xml2rfc-toc">
    <fo:bookmark internal-destination="{concat($anchor-prefix,'.toc')}">
      <fo:bookmark-title>Table of Contents</fo:bookmark-title>
    </fo:bookmark>
  </xsl:if>
  
  <xsl:apply-templates select="middle|back" mode="bookmarks"/>
</xsl:template>

<!-- experimental table formatting -->

<xsl:template name="sum-widths">
  <xsl:param name="list"/>
  <xsl:choose>
    <xsl:when test="count($list)=0">
      <xsl:value-of select="0"/>
    </xsl:when>
    <xsl:when test="count($list)=1">
      <xsl:value-of select="number(substring-before($list[1],'%'))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="remainder">
        <xsl:call-template name="sum-widths">
          <xsl:with-param name="list" select="$list[position()>1]" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$remainder + number(substring-before($list[1],'%'))" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="texttable">
  <fo:block space-before=".5em" space-after=".5em" start-indent="2em">
    <xsl:apply-templates select="preamble" />
    <fo:table>
      <xsl:variable name="total-specified">
        <xsl:call-template name="sum-widths">
          <xsl:with-param name="list" select="ttcol/@width" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:for-each select="ttcol">
        <fo:table-column>
          <xsl:choose>
            <xsl:when test="@width">
              <xsl:attribute name="column-width">proportional-column-width(<xsl:value-of select="substring-before(@width,'%')" />)</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="column-width">proportional-column-width(<xsl:value-of select="(100 - number($total-specified)) div count(../ttcol[not(@width)])" />)</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-column>
      </xsl:for-each>
      <fo:table-header space-after=".5em">
        <fo:table-row>
          <xsl:apply-templates select="ttcol" />
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:variable name="columns" select="count(ttcol)" />
        <xsl:for-each select="c[(position() mod $columns) = 1]">
          <fo:table-row>
            <xsl:for-each select=". | following-sibling::c[position() &lt; $columns]">
              <fo:table-cell>
                <fo:block>
                  <xsl:variable name="pos" select="position()" />
                  <xsl:variable name="col" select="../ttcol[position() = $pos]" />
                  <xsl:if test="$col/@align">
                    <xsl:attribute name="text-align"><xsl:value-of select="$col/@align" /></xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="node()" />
                  &#0160;
                </fo:block>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
    <xsl:apply-templates select="postamble" />
  </fo:block>
</xsl:template>

<xsl:template match="ttcol">
  <fo:table-cell>
<!--    <xsl:if test="@width">
      <xsl:attribute name="width"><xsl:value-of select="@width" /></xsl:attribute>
    </xsl:if> -->
    <xsl:choose>
      <xsl:when test="@align">
        <xsl:attribute name="text-align"><xsl:value-of select="@align" /></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="text-align">left</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <fo:block font-weight="bold">
      <xsl:apply-templates />
    </fo:block>
  </fo:table-cell>
</xsl:template>

<xsl:template name="add-anchor">
  <xsl:if test="@anchor">
    <fo:block id="{@anchor}" />
  </xsl:if>
</xsl:template>

<!-- cref support -->

<xsl:template match="cref">
  <xsl:if test="$xml2rfc-comments!='no'">
    <xsl:variable name="cid">
      <xsl:choose>
        <xsl:when test="@anchor">
          <xsl:value-of select="@anchor"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$anchor-prefix"/>
          <xsl:text>.comment.</xsl:text>
          <xsl:number count="cref[not(@anchor)]" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$xml2rfc-inline!='yes'">
        <fo:footnote>
          <fo:inline>
            <fo:basic-link font-size="8pt" vertical-align="super" internal-destination="{$cid}">[<xsl:value-of select="$cid"/>]</fo:basic-link>
          </fo:inline>
          <fo:footnote-body>
            <fo:block font-size="10pt" start-indent="2em" text-align="left" id="{$cid}">
              <fo:inline font-size="8pt" vertical-align="super">[<xsl:value-of select="$cid"/>]</fo:inline>
              <xsl:text> </xsl:text>
              <xsl:value-of select="."/>
              <xsl:if test="@source"> --<xsl:value-of select="@source"/></xsl:if>
            </fo:block>
          </fo:footnote-body>
        </fo:footnote>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline xsl:use-attribute-sets="comment">
          <xsl:text>[</xsl:text>
          <xsl:value-of select="$cid"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:if test="@source"> --<xsl:value-of select="@source"/></xsl:if>
          <xsl:text>]</xsl:text>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:if>
</xsl:template>




  <!-- experimental: format URI witz zero-width spaces to ease line breaks -->
  
  <xsl:template name="format-uri">
    <xsl:param name="s"/>
    <xsl:param name="mode"/>
    
    <xsl:choose>
      <!-- optimization for not hypenating the scheme name -->
      <xsl:when test="$mode!='after-scheme' and string-length(substring-before($s,':')) > 2">
        <xsl:value-of select="concat(substring-before($s,':'),':&#x200b;')"/>
        <xsl:call-template name="format-uri">
          <xsl:with-param name="s" select="substring-after($s,':')"/>
          <xsl:with-param name="mode" select="'after-scheme'"/>
        </xsl:call-template>
      </xsl:when>
      <!-- do no insert break points after hyphens -->
      <xsl:when test="starts-with($s,'-')">
        <xsl:text>-</xsl:text>
        <xsl:call-template name="format-uri">
          <xsl:with-param name="s" select="substring($s,2)"/>
          <xsl:with-param name="mode" select="'after-scheme'"/>
        </xsl:call-template>
      </xsl:when>
      <!-- last char?-->
      <xsl:when test="string-length($s)=1">
        <xsl:value-of select="$s"/>
      </xsl:when>
      <!-- add one zwsp after each character -->
      <xsl:when test="$s!=''">
        <xsl:value-of select="concat(substring($s,1,1),'&#x200b;')"/>
        <xsl:call-template name="format-uri">
          <xsl:with-param name="s" select="substring($s,2)"/>
          <xsl:with-param name="mode" select="'after-scheme'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- done -->
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

</xsl:stylesheet>