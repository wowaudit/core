<!DOCTYPE html>
<html lang="en">
<head><meta http-equiv="Content-Type" content="text/html; charset=us-ascii"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content=""><meta name="author" content="">
	<title>Audit Spreadsheet - World of Warcraft</title>
	<!-- Bootstrap Core CSS -->
	<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" /><!-- Custom Fonts -->
	<link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800" rel="stylesheet" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic" rel="stylesheet" type="text/css" /><!-- Plugin CSS -->
	<link href="vendor/magnific-popup/magnific-popup.css" rel="stylesheet" /><!-- Theme CSS -->
	<link href="css/creative.min.css" rel="stylesheet" /><!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries --><!-- WARNING: Respond.js doesn't work if you view the page via file:// --><!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
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
<div class="header-content">
<div class="header-content-inner">
<h1 id="homeHeading">Track New Guild</h1>

<hr />
<center>
<form class="form-horizontal" role="form" method="post" action="create_guild.php">
<div class="input-group">

    <select name='guild_region' class='form-control input-sm' placeholder='Region'><option>EU</option><option>US</option></select>

    <span class="input-group-btn" style="width:5px;"></span>
    <input type="text" name="guild_realm" class="form-control input-sm" placeholder="Guild Realm", value="" />
    <span class="input-group-btn" style="width:5px;"></span>
    <input type="text" name="guild_name" class="form-control input-sm" placeholder="Guild Name", value="" />
</div>
</center>
<?php if(isset($_GET['fail'])) { 

if ($_GET['fail'] == 'taken') {

echo "<font color='red'>*This guild has already been claimed</font>";

} elseif ($_GET['fail'] == 'noexist') {

echo "<font color='red'>*This guild does not seem to exist. Check your spelling!</font>";

} else {

echo "<font color='red'>*This realm does not seem to exist in the " . $_GET['fail'] . " region.</font>"; 

}
} ?>
</br>
<p><input type='submit' class='btn btn-primary btn-xl page-scroll' value='Track this Guild'</p>
</form>

<!-- jQuery --><script src="vendor/jquery/jquery.min.js"></script><!-- Bootstrap Core JavaScript --><script src="vendor/bootstrap/js/bootstrap.min.js"></script><!-- Plugin JavaScript --><script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script><script src="vendor/scrollreveal/scrollreveal.min.js"></script><script src="vendor/magnific-popup/jquery.magnific-popup.min.js"></script><!-- Theme JavaScript --><script src="js/creative.min.js"></script></body>
</html>