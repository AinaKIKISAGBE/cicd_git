# F2_Docker_Container_Flask_Api


l'objectif est de containairiser l'api f1_flask_api


prerequis: 
habituillé à l'environnement linux
docker installé, 
avoir quelques notion de docker, sinon chercher sur mon site et suivre le cours de docker s'il est déjà disponible 


#############################################
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
ADD ./F1_Flask_Api/config/nginx_flask_api /etc/nginx/sites-available/default
RUN chown www-data:www-data /etc/nginx/sites-available/default 
RUN chmod 755 /etc/nginx/sites-available/default 
RUN rm /etc/nginx/sites-enabled/default  
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Exposer le port 80 pour Nginx
EXPOSE 80 5000

# Commande de démarrage
CMD service nginx start && gunicorn -w 4 -b 0.0.0.0:5000 wsgi 

############################################

docker build -t  f2_docker_container_flask_api:v1 .
docker run --name f1_flask_api1 -d -p 8080:80 -p 5000:5000  f2_docker_container_flask_api:v1






GITHUB_TOKEN=votre_token_github

source keys.config
curl -O https://raw.githubusercontent.com/AinaKIKISAGBE/tools_public/refs/heads/main/create_repos_on_gith/create_repos_on_gith_with_token.py
python create_repos_on_gith_with_token.py --github_token $GITHUB_TOKEN --name F1_Flask_Api --private false --description "begin F1_Flask_Api" 
rm create_repos_on_gith_with_token.py


echo "# F2_Docker_Container_Flask_Api" >> README.md
echo "keys.config" >> .gitignore

echo git config --global user.name "AinaKIKISAGBE" >> env.config
echo git config --global user.email "aina.kiki.sagbe@gmail.com" >> env.config
echo "env.config" >> .gitignore


rm -rf F1_Flask_Api/.git
rm -rf F1_Flask_Api/__pycache__

git init
# git remote add origin https://github.com/AinaKIKISAGBE/F2_Docker_Container_Flask_Api.git
source env.config
source keys.config
# git remote remove origin
# git remote add origin https://your_token_github@github.com/AinaKIKISAGBE/venv_scoring.git
git remote add origin https://${GITHUB_TOKEN}@github.com/AinaKIKISAGBE/F2_Docker_Container_Flask_Api.git
# mettre à jour l'url sans suprimer 
# git remote set-url origin https://${GITHUB_TOKEN}@github.com/AinaKIKISAGBE/F2_Docker_Container_Flask_Api.git



# nomer, renommer ou écraser une branche si elle existe déjà
git branch -M master

# changer de branche et aller sur la branche master
#git checkout master

# charger le contenu d'une branche du repot distant vers le repos local
#git pull origin master

# mettre à jour les modification apporté aux fichiers dans le repos local
git add .
git commit -m " premier depot de F2_Docker_Container_Flask_Api"

# envoyer sur la branche distante
git push origin master

# afficher la brabche en cours
git branch






# buil images
docker build -t ghcr.io/ainakikisagbe/f2_docker_container_flask_api:v2 .

# docker login github
echo $GITHUB_TOKEN | docker login ghcr.io -u AinaKIKISAGBE --password-stdin

# push release
docker push ghcr.io/ainakikisagbe/f2_docker_container_flask_api:v2



############################# docker-compose.yml 
docker ps 

docker images
docker rmi -f ghcr.io/ainakikisagbe/f2_docker_container_flask_api:v2

### connect to image 
version: '3'
services:
  flask_web:
    image: f2_docker_container_flask_api:v2
	#image : ghcr.io/ainakikisagbe/f2_docker_container_flask_api:v2
    container_name: aade
    ports:
      - "8080:80"        # Expose le port 80 du conteneur sur le port 80 de l'hôte

docker-compose up -d 


### build dockefile and run 
version: '3'
services:
  flask_web:
    #image: f2_docker_container_flask_api:v2
    build:
      context: .       # Le chemin vers le répertoire contenant le Dockerfile
      dockerfile: Dockerfile  # Optionnel si le fichier s'appelle 'Dockerfile'
    image: f2_docker_container_flask_api:v3
    container_name: aade2
    ports:
      - "8080:80"        # Expose le port 80 du conteneur sur le port 80 de l'hôte
    #environment:
    #  - ENV_VAR=value  # Variables d'environnement (si nécessaire)


### docker-compose build 
"""
version: '3.8'

services:
  webapp:
    image: ubuntu:22.04
    container_name: aa100_flask_nginx_app
    environment:
      - DEBIAN_FRONTEND=noninteractive
    command: >
      bash -c " \
      apt-get update && \
      apt-get install -y python3.11 python3-pip python3-venv bash nginx git curl sudo && \
      ln -s /usr/bin/python3 /usr/bin/python && \
      git clone https://github.com/AinaKIKISAGBE/F1_Flask_Api.git /opt/webapp/ &&\
      pip install --no-cache-dir -r /opt/webapp/requierements.txt &&\
      adduser --disabled-password --gecos '' aina && \
      adduser aina sudo &&\
      rm /etc/nginx/sites-available/default &&\
      cp /opt/webapp/config/nginx/nginx_flask_api /etc/nginx/sites-available/default &&\
      chown www-data:www-data /etc/nginx/sites-available/default &&\
      chmod 755 /etc/nginx/sites-available/default &&\
      rm /etc/nginx/sites-enabled/default &&\
      ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/ &&\
      service nginx start &&\
      gunicorn -w 4 -b 0.0.0.0:5000 wsgi \
      "
    ports:
      - "8080:80"
      - "5000:5000"

"""	  


#docker-compose up --build

#docker-compose down
docker-compose up -d --build --force-recreate





# envoyer sutr une autre branche de github 

# changer de branche et aller sur la branche master
git checkout -b master3

# afficher la brabche en cours
git branch

# mettre à jour les modification apporté aux fichiers dans le repos local
git add .
git commit -m " master3 depot de F2_Docker_Container_Flask_Api"

# envoyer sur la branche distante
git push origin master3


# envoyer sutr une autre branche de github 
# changer de branche et aller sur la branche master
git checkout -b master4

# afficher la brabche en cours
git branch

# mettre à jour les modification apporté aux fichiers dans le repos local
git add .
git commit -m " master4 depot de F2_Docker_Container_Flask_Api"

# envoyer sur la branche distante
git push origin master4

### release tag 
# git tag v1
git push origin master4

git tag -d v1
git tag -a v1 -m "First release version 1"
git push origin v1 --force



# clone release (toutes les branche) au moment ou le tag v1 a été appliqué sur une des branche (master dans notre cas)
git clone --branch v1 https://github.com/AinaKIKISAGBE/F1_Flask_Api.git

# clone release uniquement la branche qui a été tagué v1 (sera cloné uniquement le contenu de la branche qui a été tagué v1, ici ca sera uniquement le contenu de la branche master au moment ou il a été tagué v1 )
git clone --branch v2 --single-branch  https://github.com/AinaKIKISAGBE/F1_Flask_Api.git --branch master

