<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galleria Fotogrammi ESP32-CAM</title>
    <style>
        body { font-family: sans-serif; background-color: #f0f2f5; }
        h1 { text-align: center; color: #333; }
        .gallery-container { display: flex; flex-wrap: wrap; gap: 15px; justify-content: center; padding: 20px; }
        .image-card { background: white; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); overflow: hidden; }
        .image-card img { display: block; max-width: 320px; height: auto; }
        .image-card p { text-align: center; margin: 10px 0; font-size: 0.9em; color: #555; }
    </style>
</head>
<body>
    <h1>Galleria Fotogrammi ESP32-CAM</h1>
    <div class="gallery-container">
        <?php
        $upload_dir = 'uploads/';
        // Trova tutti i file .jpg nella cartella
        $images = glob($upload_dir . '*.jpg');
        
        // Ordina i file in ordine inverso (dal più recente al più vecchio)
        rsort($images);
        
        if (count($images) > 0) {
            foreach($images as $image) {
                // Estrae il solo nome del file dal percorso completo
                $file_name = basename($image);
                echo '<div class="image-card">';
                echo '<a href="' . $image . '" target="_blank"><img src="' . $image . '" alt="' . $file_name . '"></a>';
                echo '<p>' . $file_name . '</p>';
                echo '</div>';
            }
        } else {
            echo '<p>Nessuna immagine trovata. Attendi che l\'ESP32-CAM invii il primo fotogramma.</p>';
        }
        ?>
    </div>
</body>
</html>