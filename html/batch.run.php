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

<p>batch.run.pl - run a batch of Tesserae searches and digest results</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>batch.run.pl [options] FILE</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This script is meant to run a long list of Tesserae searches generated ahead of time by &#39;batch.prepare.pl&#39;. Creates a new directory, by default called &#39;tesbatch.000&#39; or similar, in which are placed the following files:</p>

<dl>

<dt id="scores.txt"><i>scores.txt</i></dt>
<dd>

<p>A table giving, for each Tesserae run, the number of results returned at each integer score.</p>

</dd>
<dt id="runs.txt"><i>runs.txt</i></dt>
<dd>

<p>A second table giving, for each Tesserae run, all the search parameters used as well as the time in seconds taken by that run.</p>

</dd>
<dt id="sqlite.db"><i>sqlite.db</i></dt>
<dd>

<p>A SQLite database containing the above two tables.</p>

</dd>
<dt id="working-"><i>working/</i></dt>
<dd>

<p>A subdirectory containing the results of all the individual Tesserae runs.</p>

</dd>
</dl>

<p>Note: if <b>cleanup</b> is set to true (the default), everything but the first two text files is deleted on completion.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="FILE"><i>FILE</i></dt>
<dd>

<p>The file of searches to perform, having been created by &#39;batch.prepare.pl&#39;.</p>

</dd>
<dt id="dbname-NAME"><b>--dbname</b> <i>NAME</i></dt>
<dd>

<p>Name of a directory in which to store output. Default is &#39;tesbatch.NNN&#39; where N is a number.</p>

</dd>
<dt id="no-cleanup"><b>--no-cleanup</b></dt>
<dd>

<p>Don&#39;t delete working data, including all the individual Tesserae results.</p>

</dd>
<dt id="parallel-N"><b>--parallel</b> <i>N</i></dt>
<dd>

<p>Allow <i>N</i> processes to run in parallel for faster results. Requires Parallel::ForkManager.</p>

</dd>
<dt id="quiet"><b>--quiet</b></dt>
<dd>

<p>Less output to STDERR.</p>

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

<p>The Original Code is batch.run.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>





</div>

<?php include "last.php"; ?>
