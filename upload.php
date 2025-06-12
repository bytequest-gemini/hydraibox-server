<?php
// Specifica la cartella dove salvare le immagini
$upload_dir = 'uploads/';

// Se la cartella non esiste, la crea
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0755, true);
}

// Genera un nome di file unico basato sulla data e ora attuali
// Esempio: 2025-06-11_15-30-00.jpg
$file_name = date('Y-m-d_H-i-s') . '.jpg';
$file_path = $upload_dir . $file_name;

// Legge i dati grezzi (raw data) dal corpo della richiesta POST
$image_data = file_get_contents('php://input');

// Se sono stati ricevuti dei dati, li scrive nel file
if ($image_data) {
    if (file_put_contents($file_path, $image_data)) {
        // Successo
        http_response_code(200); // OK
        echo "Immagine salvata con successo come: " . $file_name;
    } else {
        // Errore di scrittura file
        http_response_code(500); // Internal Server Error
        echo "Errore: Impossibile salvare il file sul server.";
    }
} else {
    // Nessun dato ricevuto
    http_response_code(400); // Bad Request
    echo "Errore: Nessun dato immagine ricevuto.";
}
?>