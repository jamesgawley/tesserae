<?php include "first.php"; ?>
<?php include "nav_help.php"; ?>
</div>
<div id="main">




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

<p>build-rec.pl - import benchmark allusions into Tesserae</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>build-rec.pl [options]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This script is supposed to read a set of benchmark, hand-graded allusions from a text file and correlate the phrases referenced with phrases in our Tesserae database.</p>

<p>It&#39;s not checking the benchmark set against Tesserae results, it&#39;s just making sure that we can actually find the phrase pairs in our texts.</p>

<p>The script writes a binary version of the benchmark database, in which it replaces the original text of the two phrases with the equivalent text from Tesserae.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="bench-FILE"><b>--bench</b> <i>FILE</i></dt>
<dd>

<p>Read the benchmark from FILE. Default is &#39;data/bench/bench4.txt&#39;.</p>

</dd>
<dt id="cache-FILE"><b>--cache</b> <i>FILE</i></dt>
<dd>

<p>The binary file to write. Default is &#39;data/bench/rec.cache&#39;.</p>

</dd>
<dt id="target-NAME"><b>--target</b> <i>NAME</i></dt>
<dd>

<p>The name of the target text. Default is &#39;lucan.bellum_civile.part.1&#39;.</p>

</dd>
<dt id="source-NAME"><b>--source</b> <i>NAME</i></dt>
<dd>

<p>The name of the target text. Default is &#39;vergil.aeneid&#39;.</p>

</dd>
<dt id="delim-STRING"><b>--delim</b> STRING</dt>
<dd>

<p>The field delimiter in the text file to be read. Default is tab.</p>

</dd>
<dt id="check-FLOAT"><b>--check</b> FLOAT</dt>
<dd>

<p>A similarity threshold between the user-entered text and Tesserae&#39;s best guess at the correct phrase, below which Tesserae will automatically check for typos in the locus. Range: 0-1. Default is 0.3.</p>

</dd>
<dt id="warn-FLOAT"><b>--warn</b> FLOAT</dt>
<dd>

<p>A similarity threshold below which a warning will be printed to the terminal. The best match will still be selected, even if the similarity is 0, but at least you&#39;ll know about it. Range: 0-1. Default is 0.18.</p>

</dd>
<dt id="dump"><b>--dump</b></dt>
<dd>

<p>For debugging purposes, print the processed benchmark set to the terminal.</p>

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

<p>The Original Code is name.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s):</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>





</div>

<?php include "last.php"; ?>
