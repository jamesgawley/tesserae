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

<p>index_multi_child.pl - index a single text for multi-text searching</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>perl index_multi.pl [options] TEXT [TEXT2 [...]]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Create the indices used to perform multi-text searching. Right now, multi-text searches are based on stem-bigrams, pairs of stems that occur anywhere in the same textual unit (line/phrase). The index is created from existing stem indices, so this must be run after add_column.pl.</p>

<p>Default use is something like this:</p>

<pre><code>        perl scripts/v3/index_multi.pl texts/la/*
        </code></pre>

<p>The arguments are .tess files just as for add_column.pl, but index_multi.pl does not actually read these files; it looks them up in the stem index instead. Does not read directories the way add_column.pl does, so if you run a whole language subdir as in the above example, only full texts will be indexed. The way we interpret multi-text results right now, treating every book of a work as a separate hit wouldn&#39;t make sense.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="lang-LANG"><b>--lang LANG</b></dt>
<dd>

<p>Force all texts to be treated as belonging to language LANG.</p>

</dd>
<dt id="use-lingua-stem"><b>--use-lingua-stem</b></dt>
<dd>

<p>Use Lingua::Stem instead of build-in stem dictionaries. Untested in this script!</p>

</dd>
<dt id="parallel-N"><b>--parallel N</b></dt>
<dd>

<p>Allow up to N processes to run in parallel. Requires Parallel::ForkManager.</p>

</dd>
<dt id="quiet"><b>--quiet</b></dt>
<dd>

<p>Don&#39;t print messages to STDERR.</p>

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

<p>The Original Code is name.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s):</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>


</body>

</html>


