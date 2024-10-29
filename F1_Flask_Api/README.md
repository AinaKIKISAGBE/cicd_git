# F1_Flask_Api


<img width="692" alt="3" src="https://github.com/user-attachments/assets/feb6bbd9-e407-4228-8f8f-3883769ea1b6">

## 1/ Mise en place
### create venv 
#### go to repository all venv 
```
cd ~/Desktop/DevOps
mkdir venv_all
cd venv_all
```
#### create venv named "fask_venv"
	python3 -m venv F1_Flask_Api_venv

#### activate venv "fask_venv"
	source F1_Flask_Api_venv/bin/activate



## 2/ installation de flask et permière application flask
### create F1_Flask_Api
#### create F1_Flask_Api repository
	cd ~/Desktop/DevOps
	mkdir F1_Flask_Api
	cd F1_Flask_Api

#### installer package flask
	pip install flask


#### edit file app.py 
#### exécuter app.py 
	python3 app.py

#### arreter le serveur 
	> Ctrl + C 


## 3/ Installation de gunicron et livraison de l'api avec gunicron 
### traiter le message de warning
#### WARNING: This is a development server. Do not use it in a production deployment.
Cela indique que  serveur de développement Flask n'est pas destiné à être utilisé en production. Pour un déploiement en production, il est recommandé d'utiliser un serveur WSGI (comme Gunicorn ou uWSGI) qui est plus performant et sécurisé.

#### installer gunicron 
	pip install gunicorn

#### exécuter gunicorn 
	gunicorn -w 4 -b 0.0.0.0:5000 app:app
		-w 4 : Le nombre de travailleurs (workers) pour gérer les requêtes. Cela peut être ajusté en fonction de ton CPU.
		-b 0.0.0.0:5000 : Spécifie l'adresse et le port. Ici, cela écoute sur toutes les interfaces réseau à 8000.
		app:app : Indique que l'application Flask est définie dans app.py et que l’instance de Flask s'appelle app

#### on peu modifie le lancement de gunicorn en créant un fichier wsgi.py
	echo "from app import app as application" > wsgi.py
	gunicorn --bind 0.0.0.0:5000 wsgi 


## 4/ Installation de nginx et livraison de l'api avec nginx 
#### securité de l'api
Pour des raisons de performance et de sécurité, il est recommandé de placer un reverse proxy (comme Nginx ou Apache) devant Gunicorn, pour gérer le routage, les certificats SSL, et la mise en cache

	sudo apt update
	sudo apt install nginx
	
    #### si erreur lors de l'installation : 
    sudo apt remove --purge nginx nginx-core nginx-common
    sudo apt autoremove
    sudo apt autoclean
    sudo apt update
    sudo apt install nginx

    #### vérifier les dépendances
    sudo apt-cache depends nginx

    #### Vérifier les dépôts et la version Ubuntu
    nano /etc/apt/sources.list
    ls /etc/apt/sources.list.d/

    #### si un service apache est actife il peux créer des conflits avec les port utilisé par nginx et nginx pourrai ne pas démarrer 
    #### donc il faut deactiver apache
    sudo systemctl stop apache2
    #### et lempecher de démarer au démarage du pc si on n'en veuc plus 
    sudo systemctl disable apache2

    #### verifier l'état de nginx 
    sudo systemctl status nginx

    #### le démarer à nouveau et revérifier 
    sudo systemctl start nginx
    sudo systemctl status nginx

    #### si tout est bon alors redémamer le service nginx
    sudo systemctl restart nginx
    sudo systemctl status nginx

#### maintenant que nginx est bien configuré, on peu continuer
	ls /etc/nginx/sites-available/
	sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/nginx_flask_api
	sudo nano /etc/nginx/sites-available/nginx_flask_api

	server {
		listen 80; 
		#server_name votre_nom_de_domaine.com;

		location / {
			proxy_pass http://127.0.0.1:5000;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
		}
	}

	ls /etc/nginx/sites-enabled/
	sudo rm /etc/nginx/sites-enabled/nginx_flask_api 
	sudo ln -s /etc/nginx/sites-available/nginx_flask_api /etc/nginx/sites-enabled/
	sudo systemctl restart nginx

#### nginx
	http://192.168.1.XX:80

	gunicorn --bind 0.0.0.0:5000 wsgi 
	
#### gunicorn
	http://192.168.1.XX:5000

#### nginx
	http://192.168.1.XX:80


## 5/ création du requirements.txt 
#### recupérer la liste de tous les packages et envoyer dans le requierment 
	pip freeze > requirements.txt 

#### Vérifier le contenu du fichier
	cat requirements.txt

#### Pour installer les packages dans un autre environnement
	# pip install -r requirements.txt


## 6/ envoie du projet sur github
#### connexion à github  

#### création du projet ayant le même nom que le dossier de mon projet physique sur github 
#### creation du token api 

#### creation de keys.config et sauvegarde du token 
	echo > keys.config

#### renseigner le fichier keys.config
#### F1_Flask_Api_token_github
	GITHUB_TOKEN=votre_token_github

	source keys.config
	curl -O https://raw.githubusercontent.com/AinaKIKISAGBE/tools_public/refs/heads/main/create_repos_on_gith/create_repos_on_gith_with_token.py
	python create_repos_on_gith_with_token.py --github_token $GITHUB_TOKEN --name F1_Flask_Api --private false --description "begin F1_Flask_Api" 
	rm create_repos_on_gith_with_token.py

### envoie du projet sur guthub 
#### installation de git 
	sudo apt update
	sudo apt install git

#### envoie du projet sur guthub 
	echo "# F1_Flask_Api" >> README.md
	echo "keys.config" >> .gitignore

	echo git config --global user.name "AinaKIKISAGBE" >> env.config
	echo git config --global user.email "aina.kiki.sagbe@gmail.com" >> env.config
	echo "env.config" >> .gitignore


	git init
	# git remote add origin https://github.com/AinaKIKISAGBE/F1_Flask_Api.git
	source env.config
	source keys.config
 	# git remote remove origin
	# git remote add origin https://your_token_github@github.com/AinaKIKISAGBE/venv_scoring.git
	git remote add origin https://${GITHUB_TOKEN}@github.com/AinaKIKISAGBE/F1_Flask_Api.git
	# mettre à jour l'url sans suprimer 
	# git remote set-url origin https://${GITHUB_TOKEN}@github.com/AinaKIKISAGBE/F1_Flask_Api.git


	
	# nomer, renommer ou écraser une branche si elle existe déjà
	git branch -M master
	
	# changer de branche et aller sur la branche master
	#git checkout master
	
	# charger le contenu d'une branche du repot distant vers le repos local
	#git pull origin master
	
	# mettre à jour les modification apporté aux fichiers dans le repos local
	git add .
	git commit -m " premier depot de F1_Flask_Api"
	
	# envoyer sur la branche distante
	git push origin master
	
	# afficher la brabche en cours
	git branch

	
#### manipulation de branch 
	# créer une nouvelle branche et y accéder 
	git checkout -b main

	# changer de branche
	git checkout main

	# suprimer une branche en local 
	git branch
	git branch -D main
	git branch

	# suprimer la branche distant main
	git push origin --delete main
	git branch







# Différence entre Nginx et Gunicorn
Nginx et Gunicorn sont deux outils souvent utilisés ensemble pour déployer des applications web, mais ils remplissent des rôles très différents dans le stack d'une application. 

## 1. Rôle et Fonctionnalité
	•	Nginx :
		o	Type : Serveur web et reverse proxy.
		o	Fonction : Nginx est principalement utilisé pour servir des fichiers statiques (comme HTML, CSS, JavaScript, images, etc.) et pour agir comme un reverse proxy pour des applications en backend. Il gère également la répartition de charge, la gestion SSL, la mise en cache, et peut servir de point d'entrée pour les requêtes HTTP(S).
		o	Usage : Il est utilisé pour gérer la connexion entre les utilisateurs et les applications, permettant ainsi de déléguer la gestion des requêtes à des serveurs d'application comme Gunicorn.
	•	Gunicorn :
		o	Type : Serveur d'applications WSGI.
		o	Fonction : Gunicorn (Green Unicorn) est un serveur Python qui sert des applications conformes à l'interface WSGI (Web Server Gateway Interface). Il exécute des applications Python, en traitant les requêtes HTTP et en les envoyant à l'application pour traitement.
		o	Usage : Il est conçu pour exécuter des applications Python, comme celles développées avec Flask ou Django, et traite les requêtes générées par Nginx.

## 2. Gestion des Requêtes
	•	Nginx :
		o	Nginx peut gérer un grand nombre de connexions simultanées et est particulièrement efficace pour les fichiers statiques.
		o	Il redirige les requêtes vers Gunicorn (ou un autre serveur d'application) pour le traitement des requêtes dynamiques.
	•	Gunicorn :
		o	Gunicorn crée plusieurs processus (workers) pour gérer les requêtes, permettant ainsi d'augmenter la capacité de traitement.
		o	Il est plus adapté pour gérer des requêtes dynamiques générées par des frameworks Python.

## 3. Performances
	•	Nginx :
		o	Connu pour sa rapidité et son efficacité, en particulier lorsqu'il s'agit de servir des fichiers statiques.
		o	Il est optimisé pour gérer des milliers de connexions simultanées avec une faible consommation de ressources.
	•	Gunicorn :
		o	Bien qu'il soit performant pour exécuter des applications Python, il n'est pas conçu pour servir des fichiers statiques. Par conséquent, il est souvent combiné avec Nginx pour obtenir de meilleures performances.

 
## 4. Utilisation Commune
Dans un déploiement typique d'une application web Python, Nginx est utilisé comme serveur web devant Gunicorn. Voici comment ils interagissent : 

	•	Nginx reçoit les requêtes des clients (navigateur, API, etc.).
	•	Il traite les requêtes statiques (fichiers HTML, CSS, etc.) directement.
	•	Pour les requêtes dynamiques (API, pages générées par le serveur), Nginx les transmet à Gunicorn.
	•	Gunicorn exécute l'application Python, traite la requête, et renvoie la réponse à Nginx.
	•	Enfin, Nginx envoie la réponse finale au client.

## Conclusion
En résumé, Nginx est principalement un serveur web et un reverse proxy, tandis que Gunicorn est un serveur d'applications qui exécute des applications Python. Ensemble, ils offrent une solution robuste pour le déploiement d'applications web modernes
