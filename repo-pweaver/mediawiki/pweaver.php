<?php

# URL of the Pweaver server
$wgPweaverURL = '';
$wgPweaverRepos = array();

function pweaverRepo(
	$url,
	$gitweb
) {
	return array(
		'url'    => $url,
		'gitweb' => $gitweb
	);
}

$wgExtensionCredits['parserhooks'][] = array(
	'name'         =>  'Pweaver',
	'author'       =>  'Owen Healy <ellbur@gmail.com>',
	'url'          =>  '(none)',
	'description'  =>  'Retrieves HTML from a remote Pweaver'
);
$wgHooks['ParserFirstCallInit'][] = 'pweaverInit'; 

function pweaverInit(Parser &$parser) {
	$parser->setHook('pweaver', 'pweaverRender');
	return true;
}

function pweaverRender(
	$input,
	$args,
	$parser,
	$frame
) {
    global $wgPweaverURL;
	global $wgPweaverRepos;
	
	$repo   = $args['repo'];
	$pull   = $repo;
	$gitweb = $args['gitweb'];
	$commit = $args['commit'];
	$path   = $args['path'];

	if (isset($wgPweaverRepos[$repo])) {
		$repo = $wgPweaverRepos[$repo];
		$pull = $repo['url'];
		
		if ($gitweb == FALSE) {
			$gitweb = $repo['gitweb'];
		}
	}

	$report = file_get_contents(sprintf(
		'%s?repo=%s&commit=%s&path=%s',
		$wgPweaverURL,
		urlencode($pull),
		urlencode($commit),
		urlencode($path)
	));

	$archiveInfo = '';

	if ($gitweb != FALSE) {
		$archiveURL = sprintf('%s;a=snapshot;h=%s;sf=tgz',
			$gitweb,
			urlencode($commit)
		);
		$archiveInfo = sprintf('<p><a href="%s">Archive</a></p>',
			htmlspecialchars($archiveURL)
		);
	}

	$html = sprintf(<<<END
		%s
		<div class="repo-info">
		<p>Repo: %s</p>
		<p>Commit: %s</p>
		<p>File: %s</p>
		%s
		</div>
END
		,
		$report,
		htmlspecialchars($pull),
		htmlspecialchars($commit),
		htmlspecialchars($path),
		$archiveInfo
	);
	
	return $html;
}

?>
