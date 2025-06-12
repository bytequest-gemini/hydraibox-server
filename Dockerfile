# Usiamo un'immagine ufficiale che ha già Apache e PHP installati e pronti.
FROM php:8.2-apache

# Installiamo strumenti necessari e le estensioni PHP per le immagini
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd

# Installiamo Composer (il gestore di pacchetti per PHP)
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Impostiamo la cartella di lavoro
WORKDIR /var/www/html

# Copiamo TUTTI i file del nostro progetto.
COPY . .

# Lanciamo Composer per installare le dipendenze
RUN composer install

# --- LA MODIFICA CHIAVE FINALE ---
# Diamo i permessi corretti ALL'INTERA CARTELLA dell'applicazione, non solo a uploads.
# Questo assicura che il server Apache (che gira come utente www-data) sia il proprietario
# del codice che deve eseguire, risolvendo ogni potenziale problema di permessi.
RUN chown -R www-data:www-data /var/www/html

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80
EXPOSE 80