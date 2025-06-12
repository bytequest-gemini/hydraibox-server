# Usiamo un'immagine ufficiale che ha già Apache e PHP installati e pronti.
FROM php:8.2-apache

# AGGIORNAMENTO: Prima installiamo tutte le dipendenze necessarie per la libreria GD,
# poi configuriamo e installiamo l'estensione stessa.
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

# Copiamo prima il file di configurazione e installiamo le dipendenze
COPY composer.json .
RUN composer install --no-dev --optimize-autoloader

# Ora copiamo il resto dei file del progetto
COPY . .

# Diamo i permessi corretti alla cartella di uploads
RUN chown -R www-data:www-data /var/www/html/uploads

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80