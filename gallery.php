<?php
// Includiamo la libreria di Cloudinary
require 'vendor/autoload.php';

// CONFIGURAZIONE: Inserisci qui le stesse credenziali che hai usato in upload.php
\Cloudinary\Configuration\Configuration::instance([
    'cloud' => [
        'cloud_name' => 'dj7hgz9pu', 
        'api_key'    => '693237159966493', 
        'api_secret' => '6Pf3S63mWuI_w_VW_kovaapD5sQ'
    ],
    'url' => ['secure' => true]
]);

// Usiamo l'API di Amministrazione per chiedere le risorse (assets)
$adminApi = new \Cloudinary\Api\AdminApi();

// Chiediamo le risorse di tipo 'upload' dalla cartella 'hydraibox'
// ordinate per data di creazione, dalla più recente
$result = $adminApi->assets([
    "type"        => "upload",
    "prefix"      => "hydraibox", // Filtra per la cartella che abbiamo specificato nell'upload
    "max_results" => 50,
    "direction"   => "desc"
]);

?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galleria Hydraibox</title>
    <style>
        body { font-family: sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
        h1 { text-align: center; color: #333; }
        .gallery-container { display: flex; flex-wrap: wrap; gap: 15px; justify-content: center; }
        .image-card { background: white; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); overflow: hidden; text-align: center; }
        .image-card img { display: block; width: 100%; max-width: 400px; height: auto; }
        .image-card p { margin: 10px 0; font-size: 0.9em; color: #555; }
    </style>
</head>
<body>
    <h1>Galleria Immagini Hydraibox</h1>
    <div class="gallery-container">
        <?php
        if (isset($result['resources']) && count($result['resources']) > 0) {
            foreach($result['resources'] as $image) {
                // Estrae la data di caricamento e la formatta
                $upload_date = date('d-m-Y H:i:s', strtotime($image['created_at']));

                echo '<div class="image-card">';
                // Usiamo l'URL sicuro fornito da Cloudinary
                echo '<a href="' . $image['secure_url'] . '" target="_blank"><img src="' . $image['secure_url'] . '" alt="Immagine acquario"></a>';
                echo '<p>Caricata il: ' . $upload_date . '</p>';
                echo '</div>';
            }
        } else {
            echo '<p>Nessuna immagine trovata su Cloudinary. L\'upload potrebbe essere fallito o non ancora avvenuto.</p>';
        }
        ?>
    </div>
</body>
</html>