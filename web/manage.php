<!DOCTYPE html>
<html lang="en">
<head><meta http-equiv="Content-Type" content="text/html; charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content=""><meta name="author" content="">
	<title>Audit Spreadsheet - World of Warcraft</title>
	<!-- Bootstrap Core CSS -->
	<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" /><!-- Custom Fonts -->
	<link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800" rel="stylesheet" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic" rel="stylesheet" type="text/css" /><!-- Plugin CSS -->
	<link href="vendor/magnific-popup/magnific-popup.css" rel="stylesheet" /><!-- Theme CSS -->


	<link href="css/creative.min.css" rel="stylesheet" />
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries --><!-- WARNING: Respond.js doesn't work if you view the page via file:// --><!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	<link href="css/bootstrap-editable.css" rel="stylesheet">
	<style type="text/css">
	</style>

</head>
<body id="page-top">
<nav class="navbar navbar-default navbar-fixed-top" id="mainNav">
<div class="container-fluid"><!-- Brand and toggle get grouped for better mobile display -->
<div class="navbar-header"><button class="navbar-toggle collapsed" data-target="#bs-example-navbar-collapse-1" data-toggle="collapse" type="button"><span class="sr-only">Toggle navigation</span> Menu</button><a class="navbar-brand page-scroll" href="index.html">Guild Audit</a></div>
<!-- Collect the nav links, forms, and other content for toggling -->

<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
<ul class="nav navbar-nav navbar-right">
	<li><a class="page-scroll" href="spreadsheet.html">Spreadsheet</a></li>
	<li><a class="page-scroll" href="new.php">New Guild</a></li>
	<li><a class="page-scroll" href="manage.php">Manage Guild</a></li>
        <li><a class="page-scroll" href="https://discord.gg/86eUAFz" target="_blank">Discord</a></li>
	<!-- <li><a class="page-scroll" href="FAQ.html">FAQ</a></li>
	<li><a class="page-scroll" href="support.html">Support</a></li> -->
</ul>
</div>
<!-- /.navbar-collapse --></div>
<!-- /.container-fluid --></nav>

<header>
<?php

if(isset($_GET['key'])) {

require('db.php');
// Check connection
if (mysqli_connect_errno()){echo "Failed to connect to MySQL: " . mysqli_connect_error();}

mysqli_set_charset($con,'utf8');
$result = mysqli_query($con,"SELECT * from guilds WHERE key_code = '" . mb_substr($_GET['key'],0,10) ."'");

$roww = mysqli_fetch_array($result);

if($roww['key_code'] == $_GET['key'] && !($roww['key_code'] == 'demo_key') && !($roww['key_code'] == '')){


echo "<div class='header-content'>";
echo "<div class='header-content-inner'>";
echo "<h2>Managing " . $roww['name'] . " on " . $roww['realm'] . "-" . $roww['region'] ."</h2>";
echo "<hr />";
echo "<H3>Keycode: " . $roww['key_code'] . "</h3>";
echo "<br/>

<p><a class='btn btn-primary btn-xl page-scroll' href='#services'>Add / Remove Members</a></p>
</div>
</div>
</header>

    <section id='services'>

<div class='container'>";
$result = mysqli_query($con,"SELECT * FROM users WHERE guild_id = (SELECT guild_id from guilds WHERE key_code = '" . $_GET['key'] ."') ORDER BY name ASC");
$count = 0;

echo "<div class='col-lg-8 col-lg-offset-2 text-center'>
    <form action='update.php' method='post'>
   <input type='hidden' name='keycode' value='" . $_GET['key'] . "'>
	<p><input type='submit' class='btn btn-primary btn-xl page-scroll' value='Save Changes'</p>
	<br/>  <table class='table'>
    <thead>
      <tr>
		  <th></th>
        <th>Character Name</th>
        <th>Role</th>
        <th>Realm (optional)</th>
		<th>Status</th>
      </tr>
    </thead>
    <tbody>";
while($row = mysqli_fetch_array($result))
{
$count = $count + 1;
echo "<tr>";
echo "<td align='right'> " . $count . "</td>";
echo "<td><input type='text' name='name_" . $count . "' class='form-control input-sm' placeholder='Name', value='" . $row['name'] . "' /></td>";
if ($row['role'] == 'Heal') { echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option selected>Heal</option><option>Melee</option><option>Ranged</option><option>Tank</option></select></td>";} elseif ($row['role']== 'Tank') { echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option>Heal</option><option>Melee</option><option>Ranged</option><option selected>Tank</option></select></td>";} elseif ($row['role'] == 'Melee') { echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option>Heal</option><option selected>Melee</option><option>Ranged</option><option>Tank</option></select></td>";} elseif ($row['role'] == 'Ranged') { echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option>Heal</option><option>Melee</option><option selected>Ranged</option><option>Tank</option></select></td>";} else { echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option>Heal</option><option>Melee</option><option>Ranged</option><option>Tank</option></select></td>";}

if ($row["realm"]) { echo '<td><input type="text" name="realm_' . $count . '" class="form-control input-sm" placeholder="Realm (optional)", value="' . $row["realm"] . '" /></td>'; } else { echo '<td><input type="text" name="realm_' . $count . '" class="form-control input-sm" placeholder="Realm (optional)", value="' . $roww["realm"] . '" /></td>'; };

if($row['status'] == 'tracking'){$tracking = 'green';} elseif($row['status'] == 'pending') {$tracking = 'orange';} elseif($row['status'] == 'not tracking') {$tracking = 'red';};
echo "<td><font color='" . $tracking . "'>" . $row['status'] . "</font></td>";
echo "</tr>";
}
while ($count < 30)
{
$count = $count + 1;
echo "<tr>";
echo "<td align='right'> " . $count . "</td>";
echo "<td><input type='text' name='name_" . $count . "' class='form-control input-sm' placeholder='Name', value='' /></td>";
echo "<td><select name='role_" . $count . "' class='form-control input-sm'><option></option><option>Heal</option><option>Melee</option><option>Ranged</option><option>Tank</option></select></td>";
echo '<td><input type="text" name="realm_' . $count . '" class="form-control input-sm" placeholder="Realm (optional)", value="' . $roww["realm"] . '" /></td>';
echo "<td></td>";
echo "</tr>";
}
echo "</tbody></table>";

echo "<br/>
<p><input type='submit' class='btn btn-primary btn-xl page-scroll' value='Save Changes'</p>
</div>
</form>
</div>


    </section>";

mysqli_close($con);

} else {

echo "<div class='header-content'>";
echo "<div class='header-content-inner'>";
echo "<h1>Manage your Guild</h1>";
echo "<hr /><form action='manage.php' method='get'>";
echo "<div class='input-group col-sm-2 col-md-offset-5'><center><input name='key' type='text' class='form-control input-sm' placeholder='Keycode', value='' /><font color='red'>*Invalid Keycode</font></center></div>";

echo "

<br/>
<p><input type='submit' class='btn btn-primary btn-xl page-scroll' value='Manage'</p>
</form>
</div>
</div>
</header>";

}

} else {

echo "<div class='header-content'>";
echo "<div class='header-content-inner'>";
echo "<h1>Manage your Guild</h1>";
echo "<hr /><form action='manage.php' method='get'>";
echo "<div class='input-group col-sm-2 col-md-offset-5'><input name='key' type='text' class='form-control input-sm' placeholder='Keycode', value='' /></div>";

echo "

<br/>
<p><input type='submit' class='btn btn-primary btn-xl page-scroll' value='Manage'</p>
</form>
</div>
</div>
</header>";

}
?>



<!-- jQuery --><script src="vendor/jquery/jquery.min.js"></script><!-- Bootstrap Core JavaScript -->
	<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.min.js"></script><!-- Plugin JavaScript --><script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script><script src="vendor/scrollreveal/scrollreveal.min.js"></script><script src="vendor/magnific-popup/jquery.magnific-popup.min.js"></script><!-- Theme JavaScript --><script src="js/creative.min.js"></script>
<script src="js/bootstrap-editable.js"></script>

</html>
