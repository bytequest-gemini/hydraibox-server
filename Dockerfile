# Usiamo l'immagine ufficiale base.
FROM php:8.2-apache

# --- NUOVO METODO DI INSTALLAZIONE AUTOMATIZZATO ---

# 1. Scarichiamo lo script di installazione per le estensioni PHP
# e gli diamo i permessi per essere eseguito.
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# 2. Usiamo lo script per installare tutto ciò che ci serve.
# Lui si occuperà di installare in automatico TUTTE le dipendenze di sistema necessarie.
RUN install-php-extensions gd curl json

# --- FINE NUOVO METODO ---


# Il resto dello script rimane identico
# Installiamo Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_MEMORY_LIMIT=-1

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80