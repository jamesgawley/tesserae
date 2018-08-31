<?php include "first.php"; ?>
<?php include "nav_help.php"; ?>
</div>
<div id="main">




<ul id="index">
  <li><a href="#install.pl">install.pl</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a></li>
  <li><a href="#OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</a></li>
  <li><a href="#KNOWN-BUGS">KNOWN BUGS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="install.pl">install.pl</h1>

<p>install.pl - run scripts to set up Tesserae database</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>install.pl [options]</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This just runs a bunch of other Tesserae scripts that set up the feature dictionaries, add all the texts to the database, and build the dropdown menus for the (optional) web interface. You could do these things individually if you want to customize your install; this script is just provided to make &quot;default&quot; case setup easier.</p>

<h1 id="OPTIONS-AND-ARGUMENTS">OPTIONS AND ARGUMENTS</h1>

<dl>

<dt id="lang-LANG---lang-LANG2-...-"><b>--lang</b> LANG [--lang LANG2 ...]</dt>
<dd>

<p>Languages to set up initially. Tesserae expects LANG to correspond to a subdirectory of <i>texts/</i>, containing all the works in that language. The version of Tesserae on GitHub has a large number of texts in Greek (<i>texts/grc</i>) and Latin (<i>texts/la</i>), mostly from Perseus, as well as a couple of experimental texts in English (<i>texts/en</i>), of diverse provenance. You can use the flag more than once to select multiple languages. The default setting is <b>--lang</b> la <b>--lang</b> grc; i.e., if you don&#39;t specify a language at all you&#39;ll get both Greek and Latin by default. If your machine is slow and you don&#39;t care about, say, Greek, it&#39;s smart to use the flag to specify only one language. See &quot;Known Bugs&quot; below if you&#39;re using English.</p>

</dd>
<dt id="feature-FEAT---feature-FEAT2-"><b>--feature</b> FEAT [--feature FEAT2]</dt>
<dd>

<p>The feature sets to install, in addition to exact word matching. Defaults to &#39;stem&#39;. You probably don&#39;t want to mess around with this; but see &quot;Known Bugs&quot; regarding English stem matching.</p>

</dd>
<dt id="clean"><b>--clean</b></dt>
<dd>

<p>Use scripts/v3/clean.pl to delete existing texts and feature dictionaries before installing texts. This will run clean.pl with the flags --text --dict LANG [LANG2 ...], for each of the languages specified using the <b>--lang</b> option or for &#39;la&#39; and &#39;grc&#39; by default (see above).</p>

</dd>
<dt id="help"><b>--help</b></dt>
<dd>

<p>Print usage and exit.</p>

</dd>
</dl>

<h1 id="KNOWN-BUGS">KNOWN BUGS</h1>

<p>English stem matching won&#39;t work out of the box, since there&#39;s no dictionary. You have to index for English stems separately, using Lingua::Stem, by running add_col_stem.pl with the --use-lingua flag. So if you run this script with the option &#39;--lang en&#39;, turn off stem indexing by specifying &#39;--feat &quot;&quot;&#39; (i.e. nothing inside double-quotes) or things might go poorly. Or just install the English texts yourself later.</p>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>University at Buffalo Public License Version 1.0. The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the &quot;License&quot;); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.</p>

<p>Software distributed under the License is distributed on an &quot;AS IS&quot; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.</p>

<p>The Original Code is install.pl.</p>

<p>The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.</p>

<p>Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.</p>

<p>Contributor(s): Chris Forstall</p>

<p>Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the &quot;GPL&quot;), or the GNU Lesser General Public License Version 2.1 (the &quot;LGPL&quot;), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.</p>





</div>

<?php include "last.php"; ?>
