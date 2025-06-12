# Usiamo l'immagine ufficiale base.
FROM php:8.2-apache

# Installiamo gli strumenti di sistema FONDAMENTALI
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip

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

# Lanciamo Composer.
RUN composer install --no-dev --optimize-autoloader

# Diamo i permessi corretti all'intera cartella.
RUN chown -R www-data:www-data /var/www/html


# --- COMANDO DI AVVIO MODIFICATO PER DIAGNOSTICA ---
# Invece di avviare Apache, eseguiamo questi comandi e poi terminiamo.
# Questo ci mostrerà lo stato esatto del filesystem QUANDO il container è in esecuzione.
CMD ["/bin/sh", "-c", "echo '--- REPORT DIAGNOSTICO DI RUNTIME ---'; echo '==> Percorso attuale:'; pwd; echo '==> Contenuto cartella /var/www/html:'; ls -la /var/www/html; echo '==> Contenuto cartella /var/www/html/vendor:'; ls -la /var/www/html/vendor; echo '--- FINE REPORT ---'"]