# Usiamo un'immagine ufficiale che ha già Apache e PHP installati e pronti.
FROM php:8.2-apache

# Copiamo i file del nostro progetto nella cartella del server web dentro la "scatola".
# Il primo punto "." significa "tutto quello che c'è in questa cartella".
# Il secondo percorso è la destinazione dentro la scatola.
COPY . /var/www/html/

# Diciamo al mondo esterno che la nostra scatola ascolta sulla porta 80.
EXPOSE 80