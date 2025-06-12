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

# Copiamo TUTTI i file del progetto.
COPY . .

# Lanciamo Composer per installare le dipendenze
RUN composer install

# --- TELECAMERA SPIA ---
# Questo comando stamperà la lista dei file e delle cartelle presenti
# nella directory di lavoro, inclusi i permessi.
# Cercheremo la cartella "vendor" nell'output dei log di build.
RUN ls -la

# Diamo i permessi corretti alla cartella di uploads per sicurezza
RUN chown -R www-data:www-data /var/www/html/uploads

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80
EXPOSE 80