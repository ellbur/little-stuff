<?

$wgDataServer = false;

$wgHooks['ParserFirstCallInit'][] = 'includePlotInit';

function includePlotInit(Parser &$parser) {
	$parser->setHook('rhoplot', 'includePlotRender');
	return true;
}

function includePlotRender($input, $args, $parser, $frame) {
    global $wgDataServer;

	$query = http_build_query(array(
		'csv' => $input
	));

	$context = stream_context_create(array(
		'http' => array(
			'method' => 'POST',
			'content' => $query
		)
	));

	$url = $wgDataServer . '/get_content';
	$fp = @fopen($url, 'rb', false, $context);
	if (!$fp) {
		throw new Exception("fp: $url $php_errormsg");
	}
	
	$response = @stream_get_contents($fp);
	if ($response === false) {
		throw new Exception("response: $url $php_errormsg");
	}

	return $response;
}

?>
