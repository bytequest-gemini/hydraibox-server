<?php
// NUOVA PRIMA RIGA: Usa un percorso assoluto basato sulla posizione dello script stesso.
require __DIR__ . '/vendor/autoload.php';

// CONFIGURAZIONE: Inserisci qui le credenziali che trovi nella dashboard di Cloudinary
\Cloudinary\Configuration\Configuration::instance([
    'cloud' => [
        'cloud_name' => 'dj7hgz9pu', 
        'api_key'    => '693237159966493', 
        'api_secret' => '6Pf3S63mWuI_w_VW_kovaapD5sQ'
    ],
    'url' => ['secure' => true]
]);

// Legge i dati grezzi dell'immagine inviati dall'ESP32
$image_data = file_get_contents('php://input');

if ($image_data) {
    try {
        // Carica l'immagine su Cloudinary
        // Dobbiamo prima codificarla in base64 per l'API
        $result = \Cloudinary\Media\UploadApi::upload(
            'data:image/jpeg;base64,' . base64_encode($image_data),
            ['folder' => 'hydraibox'] // Opzionale: salva tutte le immagini in una cartella su Cloudinary
        );

        // Successo! Invia una risposta positiva all'ESP32
        http_response_code(200);
        echo "Immagine caricata su Cloudinary: " . $result['secure_url'];

    } catch (Exception $e) {
        // Errore durante l'upload su Cloudinary
        http_response_code(500);
        echo 'Errore durante l'upload su Cloudinary: ' . $e->getMessage();
    }
} else {
    // Nessun dato ricevuto
    http_response_code(400);
    echo "Errore: Nessun dato immagine ricevuto.";
}
?>