# Usiamo un'immagine ufficiale che ha già Apache e PHP installati e pronti.
FROM php:8.2-apache

# --- INIZIO SEZIONE DI DEBUG AVANZATO ---

# Passo 1: Aggiorniamo la lista dei pacchetti
RUN echo ">>> STEP 1: Eseguo apt-get update..." && \
    apt-get update

# Passo 2: Installiamo le librerie di sistema (git, zip, libpng, etc.)
RUN echo ">>> STEP 2: Installo le librerie di sistema..." && \
    apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev

# Passo 3.1: Configuriamo l'estensione GD
RUN echo ">>> STEP 3.1: Configuro estensione GD..." && \
    docker-php-ext-configure gd --with-freetype --with-jpeg

# Passo 3.2: Installiamo l'estensione GD
RUN echo ">>> STEP 3.2: Installo estensione GD..." && \
    docker-php-ext-install -j$(nproc) gd

# Passo 3.3: Installiamo l'estensione cURL
RUN echo ">>> STEP 3.3: Installo estensione cURL..." && \
    docker-php-ext-install curl

# Passo 3.4: Installiamo l'estensione JSON
RUN echo ">>> STEP 3.4: Installo estensione JSON..." && \
    docker-php-ext-install json

# --- FINE SEZIONE DI DEBUG AVANZATO ---


# Installiamo Composer (il gestore di pacchetti per PHP)
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Diciamo a Composer di non avere limiti di memoria
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