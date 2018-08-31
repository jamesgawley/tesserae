<?xml version="1.0" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rev="made" href="mailto:_softwareupdate@tennine-slave.macports.org" />
</head>

<body style="background-color: white">



<ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a></li>
  <li><a href="#OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</a></li>
  <li><a href="#KNOWN-BUGS">KNOWN BUGS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>cross-language-dictionary-gen.pl - create translation dictionary from parallel texts</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>cross-language-dictionary-gen.pl [options] --grc TEXT1 --la TEXT2</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Creates a translation dictionary in CSV format, where each line contains a stem in language 1 followed by two &quot;translations,&quot; i.e. stems in language 2 deemed to be related to the language 1 headword.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="grc-TEXT1"><b>--grc</b> <i>TEXT1</i></dt>
<dd>

<p>The Greek text.</p>

</dd>
<dt id="la-TEXT2"><b>--la</b> <i>TEXT2</i></dt>
<dd>

<p>The Latin text.</p>

</dd>
<dt id="feature-FEATURE"><b>--feature</b> <i>FEATURE</i></dt>
<dd>

<p>The name of the dictionary, which will be saved as &#39;data/synonymy/FEATURE.csv&#39; Default is &#39;trans1&#39;.</p>

</dd>
<dt id="n-N"><b>--n</b> <i>N</i></dt>
<dd>

<p>Return N results for each key; default is 2.</p>

</dd>
<dt id="score"><b>--score</b></dt>
<dd>

<p>Export scores along with translation candidates.</p>

<p>item <b>--echo</b></p>

<p>Echo results to stderr.</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print usage and exit.</p>

</dd>
<dt id="quiet"><b>--quiet</b></dt>
<dd>

<p>Don&#39;t print debugging info to the terminal.</p>

</dd>
</dl>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is cross-language-dictionary-gen.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): James Gawley, Chris Forstall</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>


</body>

</html>


