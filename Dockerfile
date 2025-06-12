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

# --- ECCO LA CORREZIONE ---
# 1. PRIMA copiamo TUTTI i file del nostro progetto (inclusi composer.json, upload.php, etc.)
COPY . .

# 2. ORA, con tutti i file al loro posto, lanciamo Composer.
# Composer vedrà il file composer.json e creerà la cartella vendor/ accanto agli altri file, senza che venga più sovrascritta.
RUN composer install --no-dev --optimize-autoloader

# Diamo i permessi corretti alla cartella di uploads per sicurezza
RUN chown -R www-data:www-data /var/www/html/uploads

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80
EXPOSE 80