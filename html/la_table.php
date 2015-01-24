<?php
	$lang = array(
		'target' => 'la',
		'source' => 'la'
	);
	$selected = array(
		'target' => 'vergil.georgics.part.1',
		'source' => 'catullus.carmina'
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
	
	<h1>Latin Search</h1>
	
	<p>
		For explanations of advanced features, see the 
		<a href="/help.html">Instructions</a> page.
	</p>
	

	<script src="/tesserae.js"></script>

	<?php include "advanced.php"; ?>

</div>

<?php include "last.php"; ?>

