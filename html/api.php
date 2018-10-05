<?php include "first.php"; ?>
<?php 	$page = 'api'; ?>
<?php include "nav_search.php"; ?>
		</div>
		<div id="main">
        <h1>Application Program Interface</h1>
		<p>
		Online libraries wishing to query this web service can use the API described below.
		</p>
		<h2>Basic search</h2>
		<p>
		Machine queries can be directed to:</p>
		<p>
		<code>http://tmv.westeurope.cloudapp.azure.com/search/&lt;target&gt;/&lt;source&gt;/&lt;unit&gt;/</code>
		</p>
		<p>where the three 'subdirectories' in <> brackets must be replaced with CTS URNs (in the case of 'target' and 'source') and either 'line' or 'phrase' (in the case of 'unit'). Additional variables can be fed in as parameters. These settings reflect the options on the search page:
<table>
<tr><td>Parameter</td><td>	Front-page equivalent</td></tr>
<tr><td>'feature'</td><td>	Feature</td></tr>
<tr><td>'nearby'</td><td>	Search neighboring units</td></tr>
<tr><td>'window'</td><td>	Maximum distance between matchwords</td></tr>
<tr><td>'order'</td><td>	Require identical word order</td></tr>
<tr><td>'cutoff'</td><td>	Drop scores below</td></tr>
</table>
</p>
<p>

Only the three endpoint subdivisions are mandatory. So the minimal query for a line-based search of Lucan 1 versus all of the Aeneid would look like this:

<pre><code>HTTP GET: tmv.westeurope.cloudapp.azure.com/search/urn:cts:latinLit:phi0917.phi001:1/urn:cts:latinLit:phi0690.phi003/line/</pre></code>

This can be expanded with additional parameters to include neighboring phrases and require strict word order:

<pre><code>HTTP GET: tmv.westeurope.cloudapp.azure.com/search/urn:cts:latinLit:phi0917.phi001:1/
urn:cts:latinLit:phi0690.phi003/line/?nearby=1;order=1</pre></code>

		</p>
		<h2>Response</h2>
		The expected response consists of a JSON document with objects of the following format:
		
		<pre><code>
		
{
	"target_raw": "Nominis et ius est, veras expromere voces;",
	"target": "urn:cts:latinLit:phi0917.phi001:1.360",
	"match": "expromo; uoco-uox",
	"source_raw": "Compellare uirum et maestas expromere uoces:",
	"score": "10",
	"source": "urn:cts:latinLit:phi0690.phi003:2.280",
	"entity":"tesserae_musivae_1.0",
	"highlight":["urn:cts:latinLit:phi0917.phi001:1.360@expromere[1]",
		"urn:cts:latinLit:phi0917.phi001:1.360@voces[1]",
		"urn:cts:latinLit:phi0690.phi003:2.280@expromere[1]",
		"urn:cts:latinLit:phi0690.phi003:2.280@voces[1]"]
}
</code></pre>
		
		</p>
<p>
An explanation of the values:

</p>
<p>
<table>
<tr><td>Key</td><td>	Description</tr></td>
<tr><td>"source"</td><td>	A string representing the CTS URN for the text span used as the source in this parallel.</tr></td>
<tr><td>"target"</td><td>	A string representing the CTS URN for the text span used as the target in this parallel.</tr></td>
<tr><td>"entity"</td><td>	A string representing the search engine or text from which the parallel is drawn</tr></td>
<tr><td>"match_tokens"</td><td>	A list of strings, where each string is a token found in both the source span and the target span.</tr></td>
<tr><td>"score"</td><td>	A number representing the score assigned to the pair of text spans.</tr></td>
<tr><td>"source_raw"</td><td>	The string making up the text span specified by the value of "source".</tr></td>
<tr><td>"target_raw"</td><td>	The string making up the text span specified by the value of "target".</tr></td>
<tr><td>"highlight"</td><td>	A of list strings representing CTS URNs that define which parts in the source and target spans were used to determine the score.</tr></td>
</table>

		</p>
        <p>
            Inquiries or comments about the API should be directed to
            <div class="indent">
            James Gawley <br />
            Department of Classics <br />
            338 MFAC <br />
            Buffalo, NY 14261 <br />
            <a href="mailto:ncoffee@buffalo.edu">jamesgaw@buffalo.edu</a>
        </div>
     </p>
		</div>
		<?php include "last.php"; ?>