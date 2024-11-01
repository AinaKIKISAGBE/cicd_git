# Utiliser une image de base
FROM ubuntu:22.04

# Mise à jour et installation de paquets
RUN apt-get update && \
    apt-get install -y python3.11 python3-pip python3-venv bash nginx git curl sudo && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Copier l'application dans le conteneur
ADD ./F1_Flask_Api /opt/webapp/
ADD ./F1_Flask_Api/requierements.txt /tmp/requierements.txt

# Définir le répertoire de travail
WORKDIR /opt/webapp/

# Installer les dépendances Python
RUN pip install --no-cache-dir -r /tmp/requierements.txt

# Ajouter l'utilisateur 'aina' avec sudo
RUN adduser --disabled-password --gecos "" aina && \
    adduser aina sudo

# Configurer Nginx
RUN rm /etc/nginx/sites-available/default 
ADD ./F1_Flask_Api/config/nginx/nginx_flask_api /etc/nginx/sites-available/default
RUN chown www-data:www-data /etc/nginx/sites-available/default 
RUN chmod 755 /etc/nginx/sites-available/default 
RUN rm /etc/nginx/sites-enabled/default  
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Exposer le port 80 pour Nginx
EXPOSE 80 
#EXPOSE 5000

# Commande de démarrage
CMD service nginx start && gunicorn -w 4 -b 0.0.0.0:5000 app:app 



