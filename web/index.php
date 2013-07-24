<?php

$menu = array(
	'config'=>array(
		'name'=>'Configuration',
		'items'=>array(
			'fiberdriver'=>array(
				'name'=>'Fiberdriver',
				'items'=>array()
			),
			'nginx'=>array(
				'name'=>'Nginx',
				'items'=>array()
			),
			'php'=>array(
				'name'=>'PHP',
				'items'=>array()
			),
			'mariadb'=>array(
				'name'=>'MariaDB',
				'items'=>array()
			)
		)
	),
	'virtual-hosts'=>array(
		'name'=>'Virtual Hosts',
		'items'=>array(
			'add-new'=>array(
				'name'=>'Add New',
				'items'=>array()
			)
		)
	)
);
require('include/template.php');
?>