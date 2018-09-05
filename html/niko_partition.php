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
  <li><a href="#POD-ERRORS">POD ERRORS</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>niko_partition.pl - partition huge dataset produced by Nikolaev plugin</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>niko_partition.pl --table TABLE --key KEY [--table TABLE2 --key KEY2] SESSION</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Splits <i>intertexts.txt</i> and <i>tokens.txt</i> into a number of smaller files for easier processing.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<ul>

<p>item <b>--table</b> TABLE</p>

<p>Table to partition</p>

<p>item <b>--key</b> KEY</p>

<p>Column by which to sort as an integer; first column is 0.</p>

<p>item <b>SESSION</b></p>

<p>Directory containing the tables.</p>

<p><b>--help</b></p>

<p>Print usage and exit.</p>

</ul>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tmv.westeurope.cloudapp.azure.com/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is niko_partition.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>

<h1 id="POD-ERRORS">POD ERRORS</h1>

<p>Hey! <b>The above document had some coding errors, which are explained below:</b></p>

<dl>

<dt id="Around-line-18:">Around line 18:</dt>
<dd>

<p>You can&#39;t have =items (as at line 32) unless the first thing after the =over is an =item</p>

</dd>
</dl>





</div>

<?php include "last.php"; ?>
