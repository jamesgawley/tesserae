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
  <li><a href="#EXAMPLES">EXAMPLES</a></li>
  <li><a href="#OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</a></li>
  <li><a href="#KNOWN-BUGS">KNOWN BUGS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>build-trans-cache.pl - install translation dictionary</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>build-trans-cache.pl [--feature NAME] --la|grc DICT [--la|grc DICT]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Reads one or more translation/synonymy dictionaries in CSV format; creates and installs Tesserae feature dictionaries in Storable binary format. Dictionaries should be utf-8 encoded text, with one line per headword. Each line begins with the headword to be translated, followed by one or more headwords to be considered its &quot;translations&quot; or &quot;synonyms.&quot; Fields must be separated by commas. See <i>perldoc build-trans-cache.pl</i> for examples.</p>

<h1 id="EXAMPLES">EXAMPLES</h1>

<p>To create a Greek-Latin translation feature set, first use <i>sims-export.py</i> to create a dictionary with Greek headwords in the first position on the line, followed by Latin translations. Then do, e.g.,</p>

<pre><code>  I&lt;build-trans-cache.pl&gt; --feature g2l --grc g2l_dict.csv</code></pre>

<p>This will create a feature set called &quot;g2l,&quot; using the dictionary &quot;g2l_dict.csv&quot; for the Greek feature set and the base stem dictionary for the Latin.</p>

<p>On the other hand, to create a synonymy feature set, first use <i>sims-export.py</i> to create a dictionary without the translation filter, so that Greek and Latin headwords are used indiscriminately throughout the CSV dictionary. Then give <i>build-trans-cache</i> the same CSV file for both Greek and Latin, e.g.,</p>

<pre><code>   I&lt;build-trans-cache.pl&gt; --feature syn --grc syn_dict.csv --la syn_dict.csv</code></pre>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="la-grc-DICT"><b>--la|grc</b> DICT</dt>
<dd>

<p>Language-based dictionary to read. Use <b>--la</b> to specify a Latin dictionary, <b>--grc</b> to specify a Greek dictionary. If a dictionary is provided for one language only, the other will use the existing stem dictionary.</p>

</dd>
<dt id="feature-NAME"><b>--feature</b> NAME</dt>
<dd>

<p>Optional name for feature set. Default is &quot;trans&quot;.</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print usage and exit.</p>

</dd>
</dl>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tmv.westeurope.cloudapp.azure.com/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is build-trans-cache.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall, James Gawley</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>


</body>

</html>


