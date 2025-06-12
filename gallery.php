<?php
// Abilitiamo la visualizzazione di tutti gli errori possibili
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

echo '<h1>Report Diagnostico del Server</h1>';
echo '<hr>';

// --- TEST 1: Dove si trova fisicamente questo script? ---
echo '<h2>Test 1: Percorso Assoluto dello Script</h2>';
echo '<p>La costante __DIR__ contiene: <strong>' . __DIR__ . '</strong></p>';
echo '<p>Questo conferma che siamo in /var/www/html, come previsto.</p>';
echo '<hr>';

// --- TEST 2: Esiste e possiamo leggere l\'autoloader? ---
echo '<h2>Test 2: Controllo del file vendor/autoload.php</h2>';
$autoload_path = __DIR__ . '/vendor/autoload.php';
echo '<p>Sto cercando il file al percorso: <strong>' . $autoload_path . '</strong></p>';

if (file_exists($autoload_path)) {
    echo '<p style="color:green; font-weight:bold;">STATO: Il file esiste.</p>';
    if (is_readable($autoload_path)) {
        echo '<p style="color:green; font-weight:bold;">STATO: Il file è leggibile.</p>';
    } else {
        echo '<p style="color:red; font-weight:bold;">ERRORE: Il file esiste ma NON è leggibile dall\'utente ' . get_current_user() . '!</p>';
    }
} else {
    echo '<p style="color:red; font-weight:bold;">ERRORE FATALE: Il file NON esiste in questo percorso!</p>';
}
echo '<hr>';

// --- TEST 3: C'è qualche restrizione di sicurezza sui percorsi? ---
echo '<h2>Test 3: Controllo Restrizioni Percorso (open_basedir)</h2>';
$open_basedir = ini_get('open_basedir');
if ($open_basedir) {
    echo '<p>Attenzione, è attiva una restrizione sui percorsi: <strong>' . $open_basedir . '</strong></p>';
} else {
    echo '<p style="color:green; font-weight:bold;">STATO: Nessuna restrizione open_basedir attiva.</p>';
}
echo '<hr>';


// --- TEST 4: Cosa c'è realmente in questa cartella al momento dell'esecuzione? ---
echo '<h2>Test 4: Elenco File nella Directory Corrente</h2>';
echo '<pre>';
print_r(scandir(__DIR__));
echo '</pre>';
echo '<hr>';

// --- TEST 5: Proviamo a includere l'autoloader e vediamo se l'errore avviene qui ---
echo '<h2>Test 5: Tentativo di Inclusione e Utilizzo Classe</h2>';
echo '<p>Ora provo a eseguire "require \'vendor/autoload.php\';" e a istanziare la classe...</p>';

try {
    require $autoload_path;
    echo '<p style="color:green; font-weight:bold;">STATO: require vendor/autoload.php eseguito SENZA ERRORI.</p>';
    
    // Ora proviamo a istanziare la classe
    $adminApi = new \Cloudinary\Api\AdminApi();
    echo '<p style="color:green; font-weight:bold;">STATO: Classe \Cloudinary\Api\AdminApi trovata e istanziata con SUCCESSO!</p>';
    echo '<p>Se vedi questo messaggio, il problema originale è misteriosamente risolto.</p>';

} catch (Throwable $t) {
    echo '<p style="color:red; font-weight:bold;">ERRORE CATTURATO DURANTE IL TENTATIVO:</p>';
    echo '<pre>' . $t->getMessage() . '</pre>';
    echo '<pre>' . $t->getTraceAsString() . '</pre>';
}

?>