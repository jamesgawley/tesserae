	<form action="<?php echo $url_cgi . '/read_table.pl' ?>" method="post" ID="Form1">

		<table class="input">
			<tr>
				<th>Source:</th>
				<td>
					<select name="source_auth" onchange="populate_work('<?php echo $lang['source']; ?>','source')">
					</select><br />
					<select name="source_work" onchange="populate_part('<?php echo $lang['source']; ?>','source')">
					</select><br />
					<select name="source">
					</select>
				</td>
			</tr>
			<tr>
				<th>Target:</th>
				<td>
					<select name="target_auth" onchange="populate_work('<?php echo $lang['target']; ?>','target')">
					</select><br />
					<select name="target_work" onchange="populate_part('<?php echo $lang['target']; ?>','target')">
					</select><br />
					<select name="target">
					</select>
				</td>
			</tr>
		</table>
	<p>	
		For an overview of all advanced features, see the <a href="<?php echo $url_html . '/help_advanced.php' ?>">Instructions</a> page.
	</p>
		<div onclick="hideshow()" style="color:black; text-align:center;">
			<p id="moremsg">show advanced</p>
		</div>
		<div id="advanced" style="display:none; background-color:white;">
			<table class="input">
				<tr>
					<th>Feature:</th>
					<td>
						<select name="feature">
							<?php
								foreach ($features as $k => $v) {
									$sel = '';
									if ($k == $selected_feature) {
										$sel = ' selected="selected"';
									}
									echo '<option value="' . $k .'"'. $sel .'>' . $v .'</option>';
								}
							?>
						</select>
					</td>
				</tr>
				<tr>
					<th>Unit:</th>
					<td>
						<select name="unit">
							<option value="line">line</option>
							<option value="phrase">phrase</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>Maximum distance:</th>
					<td>
						<select name="dist">
							<option value="1">1 word</option>
							<option value="2">2 words</option>
							<option value="3">3 words</option>
							<option value="4">4 words</option>
							<option value="5" selected="selected">5 words</option>
						</select>							
					</td>
				</tr>
				<tr>
					<th>Drop scores below:</td>
					<td>
						<select name="cutoff">
							<option value="0">no cutoff</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6" selected="selected">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>Require identical word order:</td>
					<td>
						<select name="order">
							<option value="0" selected="selected">no</option>
							<option value="1">yes</option>
						</select>
					</td>
				</tr>				
			</table>
		</div>
		<div style="text-align:center; padding:20px;">
			<input type="submit" value="Compare Texts" ID="btnSubmit" NAME="btnSubmit" />
		</div>
		<div style="visibility:hidden">
				<select id="<?php echo $lang['target'].'_texts' ?>">
					<?php include $fs_html.'/textlist.'.$lang['target'].'.r.php'; ?>
				</select>
				<?php
					if ($lang['source'] != $lang['target']) {

						echo '<select id="'.$lang['source'].'_texts">';
						include $fs_html.'/textlist.'.$lang['source'].'.r.php';
						echo '</select>';
					}
					
					foreach ($hidden as $k => $v) {
					
						echo '<input type="hidden" name="' . $k . '" value="' . $v . '" />';
					}
				?>
		</div>
	</form>
	<script type="text/javascript">
		lang = {
			'target':'<?php echo $lang['target'] ?>',
			'source':'<?php echo $lang['source'] ?>'
		};
		selected = {
			'target':'<?php echo $selected['target'] ?>',
			'source':'<?php echo $selected['source'] ?>'
		};
		populate_author(lang['target'], 'target');
		populate_author(lang['source'], 'source');
		set_defaults(lang, selected);
	</script>
	
