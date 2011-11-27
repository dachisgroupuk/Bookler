<?php
$con = mysql_connect("127.0.0.1","root","root");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("mandg_book0", $con);

$result_chapters = mysql_query("select wp_posts.ID, post_title,display_name from wp_posts LEFT JOIN wp_users on wp_posts.post_author = wp_users.ID where post_type != 'revision' order by post_date");
$result_bodies = mysql_query("select wp_posts.ID, post_title,display_name, post_date_gmt, post_content from wp_posts LEFT JOIN wp_users on wp_posts.post_author = wp_users.ID where post_type != 'revision' order by post_date");

?>
<div id="toc">
  <h1>Contents</h1>

<?php
while($chapters = mysql_fetch_array($result_chapters))
  {
  echo '<LI class="chapter"><A href="#'.$chapters['ID'].'">'.$chapters['ID'].' - '.$chapters['post_title']." - ".$chapters['display_name'].'</A></LI>';
  }

?>

</div>

<?php

	while($bodies = mysql_fetch_array($result_bodies))
	  {
		  echo '<h1><a name="'.$bodies['ID'].'" id ="'.$bodies['ID'].'">'.$bodies['ID'].' - '.$bodies['post_title'].'</h1><span class="author">'.$bodies['display_name'].' on '.$bodies['post_date_gmt'].'</span>';
			echo nl2br($bodies['post_content']);
	  }

  mysql_close($con);
?>