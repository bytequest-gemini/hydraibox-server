<?php
// 1. Includiamo l'autoloader di Composer in modo robusto
require __DIR__ . '/vendor/autoload.php';

// 2. Configurazione: Inserisci qui le tue credenziali che trovi nella dashboard di Cloudinary
\Cloudinary\Configuration\Configuration::instance([
    'cloud' => [
        'cloud_name' => 'dj7hgz9pu', 
        'api_key'    => '693237159966493', 
        'api_secret' => '6Pf3S63mWuI_w_VW_kovaapD5sQ'
    ],
    'url' => ['secure' => true]
]);

// 3. Usiamo l'API di Amministrazione per chiedere le risorse (assets)
$result = null; // Inizializziamo la variabile dei risultati
try {
    $adminApi = new \Cloudinary\Api\AdminApi();
    
    // Chiediamo le risorse di tipo 'upload' dalla cartella 'hydraibox'
    // ordinate per data di creazione, dalla più recente
    $result = $adminApi->assets([
        "type"        => "upload",
        "prefix"      => "hydraibox", // Filtra per la cartella che abbiamo specificato nell'upload
        "max_results" => 50,
        "direction"   => "desc"
    ]);
} catch (Exception $e) {
    // Gestiamo un eventuale errore di connessione o autenticazione con Cloudinary
    $error_message = 'Errore durante il recupero delle immagini da Cloudinary: ' . $e->getMessage();
}

?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galleria Hydraibox</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"; background-color: #f0f2f5; margin: 0; padding: 20px; }
        h1 { text-align: center; color: #1c1e21; }
        .gallery-container { display: flex; flex-wrap: wrap; gap: 16px; justify-content: center; padding: 20px; }
        .image-card { background: #fff; border: 1px solid #dddfe2; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; text-align: center; transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out; }
        .image-card:hover { transform: translateY(-5px); box-shadow: 0 8px 16px rgba(0,0,0,0.15); }
        .image-card img { display: block; width: 100%; max-width: 400px; height: auto; }
        .image-card p { margin: 12px 0; font-size: 0.9em; color: #606770; }
        .error-box { text-align: center; color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 8px; margin: 20px auto; max-width: 600px; }
    </style>
</head>
<body>
    <h1>Galleria Immagini Hydraibox</h1>
    <div class="gallery-container">
        <?php
        if (isset($error_message)) {
            // Se c'è stato un errore, lo mostriamo
            echo '<p class="error-box">' . htmlspecialchars($error_message) . '</p>';
        } elseif (isset($result['resources']) && count($result['resources']) > 0) {
            // Se ci sono immagini, le mostriamo
            foreach($result['resources'] as $image) {
                // Estrae la data di caricamento e la formatta in italiano
                $upload_date = date('d/m/Y H:i:s', strtotime($image['created_at']));

                echo '<div class="image-card">';
                // Usiamo l'URL sicuro fornito da Cloudinary
                echo '<a href="' . htmlspecialchars($image['secure_url']) . '" target="_blank"><img src="' . htmlspecialchars($image['secure_url']) . '" alt="Immagine acquario"></a>';
                echo '<p>Caricata il: ' . $upload_date . '</p>';
                echo '</div>';
            }
        } else {
            // Se non ci sono né errori né immagini
            echo '<p>Nessuna immagine trovata su Cloudinary. Attendi che l\'ESP32 invii il primo fotogramma.</p>';
        }
        ?>
    </div>
</body>
</html>