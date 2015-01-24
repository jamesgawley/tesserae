<?php
	$lang = array(
		'target' => 'grc',
		'source' => 'grc'
	);
	$selected = array(
		'target' => 'apollonius.argonautica.part.1',
		'source' => 'homer.iliad'
	);
	$features = array(
		'word' => 'exact word',
		'stem' => 'lemma',
		'3gr'  => 'character 3-gram'
	);
	$selected_feature = 'stem';
?>

<?php include "first.php"; ?>
<?php include "nav_search.php"; ?>

</div>
<div id="main">
	
	<h1>Greek Search</h1>
	
	<p>
		For explanations of advanced features, see the 
		<a href="/help.html">Instructions</a> page.
	</p>
	

	<script src="/tesserae.js"></script>

	<?php include "advanced.php"; ?>

</div>

<?php include "last.php"; ?>

