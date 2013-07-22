<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width" />
		<title><?php echo $hostname=trim(exec('hostname -f')); ?> | fiberdriver open source server management system</title>
		<link rel="stylesheet" href="css/fiberdriver.css" />
		<script src="js/custom.modernizr.js"></script>
	</head>
	<body>
		<nav class="top-bar">
			<ul class="title-area">
				<li class="name">
					<h1><a href="/">fiberdriver (<?php echo $hostname; ?>)</a></h1>
				</li>
			</ul>
		</nav>
		<div class="row">
			<div class="large-3 columns">
				<div class="section-container accordion" data-section="accordion">
					<section class="section">
						<p class="title"><a href="#">Configuration</a></p>
						<div class="content">
							<ul class="side-nav">
								<li><a href="#">Fiberdriver</a></li>
								<li><a href="#">Nginx</a></li>
								<li><a href="#">PHP</a></li>
								<li><a href="#">MariaDB</a></li>
							</ul>
						</div>
					</section>
					<section class="section">
						<p class="title"><a href="#">Virtual Hosts</a></p>
						<div class="content">
							<ul class="side-nav">
								<li><a href="#">Add New</a></li>
							</ul>
						</div>
					</section>
				</div>
			</div>
			<div class="large-9 columns">
				<h2>Section</h2>
			</div>
		</div>
		<script src="js/jquery.js"></script>
		<script src="js/foundation.js"></script>
		<script src="js/foundation.alerts.js"></script>
		<script src="js/foundation.clearing.js"></script>
		<script src="js/foundation.cookie.js"></script>
		<script src="js/foundation.dropdown.js"></script>
		<script src="js/foundation.forms.js"></script>
		<script src="js/foundation.interchange.js"></script>
		<script src="js/foundation.joyride.js"></script>
		<script src="js/foundation.magellan.js"></script>
		<script src="js/foundation.orbit.js"></script>
		<script src="js/foundation.placeholder.js"></script>
		<script src="js/foundation.reveal.js"></script>
		<script src="js/foundation.section.js"></script>
		<script src="js/foundation.tooltips.js"></script>
		<script src="js/foundation.topbar.js"></script>
		<script>
			$(document).foundation();
		</script>
	</body>
</html>