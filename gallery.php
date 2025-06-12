<?php
require __DIR__ . '/vendor/autoload.php';

\Cloudinary\Configuration\Configuration::instance([
    'cloud' => [
        'cloud_name' => 'dj7hgz9pu', 
        'api_key'    => '693237159966493', 
        'api_secret' => '6Pf3S63mWuI_w_VW_kovaapD5sQ'
    ],
    'url' => ['secure' => true]
]);

$adminApi = new \Cloudinary\Api\AdminApi();
$result = $adminApi->assets(["type" => "upload", "prefix" => "hydraibox", "max_results" => 50, "direction" => "desc"]);
?>
<!DOCTYPE html>