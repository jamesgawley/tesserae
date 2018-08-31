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

<p>add_column.pl - add texts to the tesserae database</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>perl add_column.pl [options] TEXT [, TEXT2, [DIR], ...]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Reads in one or more .tess documents and creates the indices used by read_table.pl to perform Tesserae searches.</p>

<p>This script is usually run on an entire directory of texts at once, when you&#39;re first setting Tesserae up. E.g. (from the Tesserae root dir),</p>

<pre><code>   perl scripts/v3/add_column.pl texts/la/*</code></pre>

<p>If the script is passed a directory instead of a file, it will search inside for .tess files; this is designed for works which have been partitioned into separate files, e.g. by internal &quot;book&quot;. These .part. files are stored inside a directory named for the original work.</p>

<p>If you have a file in the <i>texts/</i> directory called <i>prose_list</i>, this will be read and any texts whose names are found in the prose list will be added to the database in &quot;prose mode&quot;. Because the &quot;line&quot; unit of text doesn&#39;t make much sense for prose works, in prose mode the line database is just a copy of the phrase one.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="lang"><b>--lang</b></dt>
<dd>

<p>Specify the language code for all texts. By default tries to guess from the path, which usually includes this code. Tells Tesserae where to look for stem dictionaries, etc.</p>

</dd>
<dt id="parllel-N"><b>--parllel N</b></dt>
<dd>

<p>Allow up to N processes to run in parallel. Requires Parallel::ForkManager.</p>

</dd>
<dt id="use-lingua-stem"><b>--use-lingua-stem</b></dt>
<dd>

<p>Use the Lingua::Stem module to do stemming instead of internal dictionaries. This is the only way to index English works by stem; I don&#39;t think it works for Latin and almost certainly not for Greek. The language code will be passed to Lingua::Stem, which must have a stemmer for that code.</p>

</dd>
<dt id="prose"><b>--prose</b></dt>
<dd>

<p>Force all texts to be added in prose mode.</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print usage and exit.</p>

</dd>
</dl>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is add_column.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall &lt;forstall@buffalo.edu&gt;, James Gawley, Neil Coffee</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>


</body>

</html>


