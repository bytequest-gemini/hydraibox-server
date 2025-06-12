# Usiamo un'immagine ufficiale che ha già Apache e PHP installati e pronti.
FROM php:8.2-apache

# Installiamo TUTTE le dipendenze e le estensioni PHP che potrebbero servire.
# Aggiungiamo curl e json per la comunicazione e la gestione dei dati.
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd curl json

# Installiamo Composer (il gestore di pacchetti per PHP)
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Diciamo a Composer di non avere limiti di memoria, per evitare fallimenti silenziosi.
ENV COMPOSER_MEMORY_LIMIT=-1

# Impostiamo la cartella di lavoro
WORKDIR /var/www/html

# Copiamo TUTTI i file del nostro progetto.
COPY . .

# Lanciamo Composer con le opzioni ottimizzate per la produzione.
RUN composer install --no-dev --optimize-autoloader

# Diamo i permessi corretti all'intera cartella.
RUN chown -R www-data:www-data /var/www/html

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80