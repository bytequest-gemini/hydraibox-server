# Usiamo un'immagine ufficiale con PHP e Apache
FROM php:8.2-apache

# Installiamo strumenti necessari e le estensioni PHP per le immagini
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
&& docker-php-ext-install gd

# Installiamo Composer (il gestore di pacchetti per PHP)
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Impostiamo la cartella di lavoro
WORKDIR /var/www/html

# Copiamo prima il file di configurazione e installiamo le dipendenze
COPY composer.json .
RUN composer install

# Ora copiamo il resto dei file del progetto
COPY . .

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80
EXPOSE 80