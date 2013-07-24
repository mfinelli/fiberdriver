<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width" />
		<title><?php echo $hostname=trim(exec('hostname -f')); ?> | fiberdriver open source server management system</title>
		<link rel="stylesheet" href="/css/fiberdriver.css" />
		<script src="/js/custom.modernizr.js"></script>
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
<?php
$menucheck=explode('/',$_SERVER['REQUEST_URI']);
if(count($menucheck)){
	array_shift($menucheck);
	$menucheck=implode('/',array(array_shift($menucheck),array_shift($menucheck)));
}else
	$menucheck="";
foreach($menu as $section=>$items){
	echo "\t\t\t\t\t".'<section class="section';
	if(!strcmp($section,explode('/',$menucheck)[0]))
		echo ' active';
	echo '">'."\n";
	echo "\t\t\t\t\t\t".'<p class="title"><a href="#">'."{$items['name']}".'</a></p>'."\n";
	echo "\t\t\t\t\t\t".'<div class="content">'."\n";
	echo "\t\t\t\t\t\t\t".'<ul class="side-nav">'."\n";
	foreach($items['items'] as $uri=>$title){
		echo "\t\t\t\t\t\t\t\t".'<li><a';
		if(!strcmp($section.'/'.$uri,$menucheck))
			echo ' class="active"';
		echo ' href="/'."{$section}".'/'."{$uri}".'">'."{$title['name']}".'</a></li>'."\n";
	}
	echo "\t\t\t\t\t\t\t".'</ul>'."\n";
	echo "\t\t\t\t\t\t".'</div>'."\n";
	echo "\t\t\t\t\t".'</section>'."\n";
} ?>
				</div>
			</div>
			<div class="large-9 columns">
				<h2>Section <?php echo $_SERVER['REQUEST_URI']; ?></h2>
				<pre><?php echo $content; ?></pre>
			</div>
		</div>
		<script src="/js/jquery.js"></script>
		<script src="/js/foundation.js"></script>
		<script src="/js/foundation.alerts.js"></script>
		<script src="/js/foundation.clearing.js"></script>
		<script src="/js/foundation.cookie.js"></script>
		<script src="/js/foundation.dropdown.js"></script>
		<script src="/js/foundation.forms.js"></script>
		<script src="/js/foundation.interchange.js"></script>
		<script src="/js/foundation.joyride.js"></script>
		<script src="/js/foundation.magellan.js"></script>
		<script src="/js/foundation.orbit.js"></script>
		<script src="/js/foundation.placeholder.js"></script>
		<script src="/js/foundation.reveal.js"></script>
		<script src="/js/foundation.section.js"></script>
		<script src="/js/foundation.tooltips.js"></script>
		<script src="/js/foundation.topbar.js"></script>
		<script>
			$(document).foundation();
		</script>
	</body>
</html>