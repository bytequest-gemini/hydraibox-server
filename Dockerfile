# Usiamo l'immagine ufficiale base.
FROM php:8.2-apache

# Usiamo uno script helper per installare le estensioni, che gestisce le dipendenze in automatico.
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

# --- MODIFICA DIAGNOSTICA ---
# Lanciamo Composer in modalità super-loquace (-vvv) per vedere l'errore esatto.
# Ho rimosso le opzioni di ottimizzazione solo per questo test.
RUN composer install -vvv

# Diamo i permessi corretti all'intera cartella.
RUN chown -R www-data:www-data /var/www/html

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80