# Usiamo l'immagine ufficiale base.
FROM php:8.2-apache

# Passo 1: Installiamo gli strumenti di sistema FONDAMENTALI (git, zip, etc.)
# Questo era il pezzo mancante che faceva fallire Composer.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip

# Passo 2: Usiamo lo script helper per installare le estensioni PHP
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions gd curl json

# Installiamo Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Diciamo a Composer di non avere limiti di memoria
ENV COMPOSER_MEMORY_LIMIT=-1

# Impostiamo la cartella di lavoro
WORKDIR /var/www/html

# Copiamo TUTTI i file del nostro progetto.
COPY . .

# Lanciamo Composer. Ora ha tutti gli strumenti di cui ha bisogno per funzionare.
RUN composer install --no-dev --optimize-autoloader

# Diamo i permessi corretti all'intera cartella.
RUN chown -R www-data:www-data /var/www/html

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80