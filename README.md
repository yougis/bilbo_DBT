# Description du projet 

Projet DBT pour l'automatisation de la transformation des tables et la préparation à leur valorisation.


# Organisation et méthodologie

**1. analyses** : permet de réaliser des requêtes SQL exploratoires, souvent temporaires, pour mieux comprendre (vient avant le Models). Cette partie n’intervient pas dans le pipeline de production.

**2. logs** : contient des informations sur l’exécution des commandes

**3. macros** : scripts SQL réutilisables dans A et B, permet d’appeler les fonctions au lieu de les réécrire dans les Models.

**4. models** : fichiers SQL contenant les scripts pour transformer les tables de faits en “mvue” et tables.

**5. seeds (ou data)** : stocke des données statiques (ex : CSV) 

**6. snapshots** : capture les versions historiques des données utiles pour le suivi des changements dans le temps

**7. targets** : permet de visualiser les run.

**8. tests** : contrôle qualité des données, fiabilité et intégrité des transformations en A 

**9. dbt_project.yml** : contient les informations de configurations du projet 

**10. profiles.yml** : contient les informations sur la connexion à la BD PostgreSQL 


# Comment utiliser ?

Pour utiliser ce projet, veuillez suivre les étapes ci-dessous :

_Étape 1 : Installer les dépendances_  
_Étape 2 : Configurer les fichiers de connexion_  
_Étape 3 : Exécuter les commandes dbt_

# Dernière mise à jour
<ins>Mercredi 3 juillet 2024 - 14h27</ins>  
Par : _Eliott_