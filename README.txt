I) Présentation générale

Le projet a été réalisé par Nadezhda ZHUKOVA, étudiante à la Faculté de bioinformatique L3.
Le but du projet est de modéliser, peupler et créer une base de données d'un site e-commerce. Dans ce cas, une épicerie a été choisie.

a) Produits
Tous les produits sont regroupés par classe. Le prix des produits peut changer au fil du temps, par conséquent, les informations sur tous les changements de prix sont stockées dans un tableau séparé, dont les mises à jour entraînent automatiquement des mises à jour dans le tableau des produits. Le produit peut être en stock (le nombre exact d'unités est disponible immédiatement), disponible sur commande (avec un délai), ou temporairement indisponible.

b) Clients
Pour les clients, les informations usuelles sont conservées : nom, prénom, adresse, e-mail, numéro de téléphone, date anniversaire, date d'inscription du client sur le site.

c) Commandes
Pour chaque commande, la date de la commande est enregistrée. La commande contient aussi l’adresse de livraison si elle est différente de l’adresse de facturation (on considère que l’adresse de facturation est l’adresse du client). Chaque commande peut concerner plusieurs produits. Chacun de
ces produits peut être livré séparément, donc une commande client sera vue comme un ensemble de commandes individuelles, une pour chaque type d'article commandé. Le statut de chaque commande individuelle est enregistré : livrée (avec la date d’expédition et la date de livraison), en livraison (avec la date d’expédition), en préparation (avec la date prévue
d’expedition), en attente (si le produit n’était pas en stock au moment de la commande, dans ce cas on représentera la date prévue de réapprovisionnement et la date prevue d’expedition qui devra être successive). La commande de chaque produit peut être annulée en tout ou partie par l'acheteur si celui-ci n'a pas été expédié, ce qui implique un remboursement. En conséquence, les demandes d'annulation d'articles qui ont été expédiés sont automatiquement annulées. Une fois un produit livré, il est possible de le retourner avec remboursement. Les demandes des retours, des cancellations et des remboursements, sont enregistrés dans des tableaux séparés. Pour retourner le produit , il faut spécifier la raison (par exemple, un produit défectueux).
On n'est pas demandé  de modéliser les paniers ni les interactions avec les banques en cas de paiement en ligne.

d) Les avis et les notes
Les clients peuvent déposer des avis et des notes (sur les produits), qui sont stockés dans un tableau séparé. Le client ne peut pas laisser un avis sur un produit qu'il n'a jamais acheté - une telle opinion ne sera pas automatiquement enregistrée.

II) Peuplement des tables

Les tables sont alimentées à partir de fichiers csv générés par vous-même à l'aide du site. 

III) Les requêtes

20 questions sur une simulation de site e-commerce ont été conçues et les requêtes SQL pour y répondre ont été écrits.

IV) Rendu

La visualisation finale du projet se compose des éléments suivants :
– Modélisation sous forme de diagramme ER
– Script SQL ecommerce_tables.sql qui crée toutes les tables
– Fichiers csv avec les données utilisées pour remplir les tableaux
– Script SQL data_adding.sql qui qui alimente les tables à partir de fichiers csv
– Un fichier sql contenant toutes les requêtes et leur description
– Un fichier README qui décrit le projet
