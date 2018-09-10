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
  <li><a href="#OPTIONS">OPTIONS</a></li>
  <li><a href="#KNOWN-BUGS">KNOWN BUGS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>score.test.pl - Compare a set of scoring algorithms on the Lucan-Vergil benchmark.</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p><b>score.test.pl</b> [OPTIONS]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Does a Tesserae search using target=lucan.bellum_civile.part.1, source=vergil.aeneid, unit=phrase. Each parallel is scored by each of the scoring modules specified using the --plugin option; if none is specified all available plugins are run. The output is a list of scores for each parallel, along with annotator type and commentary results.</p>

<h1 id="OPTIONS">OPTIONS</h1>

<dl>

<dt id="plugin-NAME"><b>--plugin</b> NAME</dt>
<dd>

<p>Use NAME to score each parallel. Must be a Perl module in the plugins directory. To specify more than one plugin, repeat the <b>--plugin</b> flag. If none is specified, all the modules in the plugins dir will be used.</p>

</dd>
<dt id="quiet"><b>--quiet</b></dt>
<dd>

<p>Don&#39;t write progress info to STDERR.</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print this message and exit.</p>

</dd>
</dl>

<p>In addition, any of the usual options for read_table.pl can be given as well, with the exception of <i>source</i>, <i>target</i>, and <i>unit</i>.</p>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<p><i>cgi-bin/read_table.pl</i></p>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tmv.westeurope.cloudapp.azure.com/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is score.test.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Neil Coffee, Chris Forstall, James Gawley.</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>


</body>

</html>

