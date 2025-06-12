# Usiamo l'immagine ufficiale base.
FROM php:8.2-apache

# Installiamo gli strumenti di sistema FONDAMENTALI
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    libcurl4-openssl-dev

# Usiamo lo script helper per installare le estensioni PHP
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions gd curl json

# Installiamo Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_MEMORY_LIMIT=-1

# Impostiamo la cartella di lavoro
WORKDIR /var/www/html

# Copiamo TUTTI i file del nostro progetto.
COPY . .

# Lanciamo Composer con le opzioni ottimizzate per la produzione.
RUN composer install --no-dev --optimize-autoloader

# --- LA MOSSA FINALE: Disabilitare la cache aggressiva di PHP (OPcache) ---
# Creiamo un file di configurazione che dice a OPcache di controllare SEMPRE se i file
# sono stati modificati, invece di usare una versione vecchia in memoria.
# Questo dovrebbe risolvere il nostro problema del "fantasma".
RUN echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/opcache-fix.ini && \
    echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/opcache-fix.ini

# Diamo i permessi corretti all'intera cartella.
RUN chown -R www-data:www-data /var/www/html

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80