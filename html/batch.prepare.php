<?php include "first.php"; ?>
<?php include "nav_help.php"; ?>
</div>
<div id="main">




<ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a></li>
  <li><a href="#OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</a></li>
  <li><a href="#TESSERAE-SEARCH-OPTIONS">TESSERAE SEARCH OPTIONS</a></li>
  <li><a href="#SPECIFYING-MULTIPLE-VALUES">SPECIFYING MULTIPLE VALUES</a>
    <ul>
      <li><a href="#EXAMPLE">EXAMPLE</a></li>
    </ul>
  </li>
  <li><a href="#INPUT-FILE-FORMAT">INPUT FILE FORMAT</a>
    <ul>
      <li><a href="#SAMPLE-INPUT-FILE">SAMPLE INPUT FILE</a></li>
    </ul>
  </li>
  <li><a href="#KNOWN-BUGS">KNOWN BUGS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>batch.prepare.pl - prepare a systematic set of tesserae searches</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>batch.prepare.pl [options] [tessoptions]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This script accepts Tesserae search parameters specifying multiple values per parameter. It then generates every combination of these parameters and writes to a file a list of individual Tesserae searches to be performed. The idea is that you would then feed this list into batch.run.pl, which would run the searches, although if you really wanted to you could also run the output file as a shell script.</p>

<p>The simplest way to use this script is to specify Tesserae search options just as for read_table.pl; Here, unlike with read_table.pl, you can specify multiple values.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="outfile-FILE"><b>--outfile</b> <i>FILE</i></dt>
<dd>

<p>The destination for output.</p>

</dd>
<dt id="interactive"><b>--interactive</b></dt>
<dd>

<p>This flag initiates &quot;interactive&quot; mode. The script will ask you what values or ranges you want for each of the available parameters.</p>

</dd>
<dt id="infile-FILE"><b>--infile</b> <i>FILE</i></dt>
<dd>

<p>This will attempt to read parameters from FILE. Use &#39;--man&#39; to read about the format of this file.</p>

</dd>
<dt id="quiet"><b>--quiet</b></dt>
<dd>

<p>Less output to STDERR.</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print usage and exit.</p>

</dd>
<dt id="man"><b>--man</b></dt>
<dd>

<p>Display detailed help.</p>

</dd>
</dl>

<h1 id="TESSERAE-SEARCH-OPTIONS">TESSERAE SEARCH OPTIONS</h1>

<p>Aside from parsing out lists and ranges, the script simply passes these on to Tesserae&#39;s read_table.pl.</p>

<dl>

<dt id="source-SOURCE"><b>--source</b> <i>SOURCE</i></dt>
<dd>

<p>the source text</p>

</dd>
<dt id="target-TARGET"><b>--target</b> <i>TARGET</i></dt>
<dd>

<p>the target text</p>

</dd>
<dt id="unit-UNIT"><b>--unit</b> <i>UNIT</i></dt>
<dd>

<p>unit to search: &quot;line&quot; or &quot;phrase&quot;</p>

</dd>
<dt id="feature-FEAT"><b>--feature</b> <i>FEAT</i></dt>
<dd>

<p>feature to search on: &quot;word&quot;, &quot;stem&quot;, &quot;syn&quot;, or &quot;3gr&quot;</p>

</dd>
<dt id="stop-N"><b>--stop</b> <i>N</i></dt>
<dd>

<p>number of stop words</p>

</dd>
<dt id="stbasis-STBASIS"><b>--stbasis</b> <i>STBASIS</i></dt>
<dd>

<p>stoplist basis: &quot;corpus&quot;, &quot;source&quot;, &quot;target&quot;, or &quot;both&quot;</p>

</dd>
<dt id="dist-D"><b>--dist</b> <i>D</i></dt>
<dd>

<p>max distance (in words) between matching words</p>

</dd>
<dt id="dibasis-DIBASIS"><b>--dibasis</b> <i>DIBASIS</i></dt>
<dd>

<p>metric used to calculate distance: &quot;freq&quot;, &quot;freq-target&quot;, &quot;freq-source&quot;, &quot;span&quot;, &quot;span-target&quot;, or &quot;span-source&quot;</p>

</dd>
</dl>

<h1 id="SPECIFYING-MULTIPLE-VALUES">SPECIFYING MULTIPLE VALUES</h1>

<p>This can be done in a couple of ways. First, you can separate different values with commas. When entering options at the command-line, no whitespace is allowed, but using an input file or interactive mode whitespace is allowed. Second, for names of texts only, you can use the wildcard character &#39;*&#39; to match several names at once. Third, for numeric parameters only, you can specify a range by giving the start and end values separated by a dash (but no space); optionally, you can append a &quot;step&quot; value, separated from the range by a colon (but no space), e.g. &#39;1-10&#39; or &#39;10-20:2&#39;. The default step is 1.</p>

<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>  batch.prepare.pl --outfile my.list.txt                          \
                   --target  lucan.bellum_civile,statius.thebaid  \
                   --source  vergil.aeneid.part.*                 \
                   --stop    5-10                                 \
                   --dist    4-20:4</code></pre>

<h1 id="INPUT-FILE-FORMAT">INPUT FILE FORMAT</h1>

<p>It may be easier to lay out the various options in a separate file, from which batch.prepare.pl can read using the <i>--infile</i> flag.</p>

<p>The file should be arranged as follows. Values for a given search parameter should be grouped together, one per line, under a header in square brackets giving the name of the parameter. Text names can use the wildcard as above. Numeric ranges can be specified as above, and in this case whitespace around the &quot;-&quot; or &quot;:&quot; chars is okay. Alternately, you can specify a range verbosely using one of the forms</p>

<pre><code>        range(from=I; to=J)</code></pre>

<p>or</p>

<pre><code>        range(from=I; to=J; step=K)</code></pre>

<p>where I, J, and K are integers.</p>

<h2 id="SAMPLE-INPUT-FILE">SAMPLE INPUT FILE</h2>

<pre><code>  # my batch file
  # -- comments beginning with a hash sign are ignored

  [source]
  vergil.aeneid.part.*          # wildcard
        
  [target]
  lucan.bellum_civile.part.*    # multiple values on separate lines
  statius.thebaid.part.*
  silius_italicus.punica.part.*

  [stop]
  10 - 20 : 5                   # range can have spaces

  [stbasis]
  both                          # single values work too
        
  [dist]
  range(from=8; to=16; step=4)  # verbose-style range</code></pre>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<p>None, but nothing has really been tested much.</p>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<p>batch.run.pl</p>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tmv.westeurope.cloudapp.azure.com/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is batch.prepare.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall, Neil Bernstein, Xia Lu</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>





</div>

<?php include "last.php"; ?>
