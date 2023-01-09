#1 au moins trois tables

#Cette requête sélectionne le nom, l'email, le nom du produit, la quantité et le prix de toutes les 
#commandes passées par un client dont le nom est "Ardeen Yurocjkin" et dont le statut est "refunded". 
#La requête joint les tables customers, orders et products en utilisant les clés étrangères customer_id 
#et product_id.

SELECT c.name, c.email, p.name, o.quantity, o.price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE c.name = 'Ardeen Yurocjkin' AND o.status = 'refunded';

#2 sous-requête corrélée

#Cette requête sélectionne le nom et l'email de tous les clients qui ont au moins une commande, ainsi que 
#le nombre de commandes de chaque client. 

SELECT c.name AS customer_name, c.email AS customer_email, 
(SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) AS number_of_orders
FROM customers c
WHERE (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) > 0;

#3 sous-requête dans le WHERE

#Cette requête sélectionne les détails de toutes les commandes pour les produits de la catégorie "fruits". 

SELECT o.order_id, o.customer_id, o.product_id, o.quantity, o.price
FROM orders o
WHERE o.product_id IN (SELECT p.product_id FROM products p WHERE p.category = 'fruits');

#4 deux agrégats nécessitant GROUP BY et HAVING

#Cette requête sélectionne l'ID, le nom et le prix de tous les produits, ainsi que la quantité totale 
#de chaque produit vendue et le prix moyen des commandes pour chaque produit. On n'inclure que les produits 
#pour lesquels le prix moyen des commandes est supérieur à 900.

SELECT p.product_id, p.name, p.price, SUM(o.quantity) AS total_quantity_sold, 
       SUM(o.price) / COUNT(o.order_id) AS average_order_price
FROM products p JOIN orders o ON o.product_id = p.product_id
GROUP BY p.product_id, p.name, p.price
HAVING average_order_price > 900;


#5 le calcul de deux agrégats

#Cette requête sélectionne le nom de tous les clients et le prix le plus élevé de chaque commande pour 
#chaque client, ainsi que la moyenne des prix de commande pour tous les clients. 

SELECT c.name AS customer_name, MAX(o.price) AS highest_order_price, AVG(o.price) AS average_order_price
FROM customers c JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

#6 une jointure externe LEFT JOIN

#Cette requête sélectionne le nom de tous les clients et le nombre de commandes pour chaque client.

SELECT c.name AS customer_name, COUNT(o.order_id) AS number_of_orders
FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

#7 une jointure externe RIGHT JOIN

#Cette requête sélectionne le nom de tous les produits et le nombre de commandes pour chaque produit.

SELECT p.name AS product_name, COUNT(o.order_id) AS number_of_orders
FROM products p RIGHT JOIN orders o ON o.product_id = p.product_id
GROUP BY p.product_id, p.name;

#8 une jointure externe FULL JOIN

#Cette requête sélectionne le nom de tous les clients, le nom de tous les produits et l'ID de toutes les 
#commandes. La table customers est jointe à la table orders en utilisant l'ID de client, et la table orders 
#est jointe à la table products en utilisant l'ID de produit.Pour les clients ou les produits sans commandes 
#associées, le nom de la commande est affiché comme NULL.

SELECT c.name AS customer_name, p.name AS product_name, o.order_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN products p ON p.product_id = o.product_id
UNION
SELECT c.name AS customer_name, p.name AS product_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON o.customer_id = c.customer_id
RIGHT JOIN products p ON p.product_id = o.product_id;

#MySQL ne prend pas en charge les FULL OUTER JOIN. Au lieu de cela, j'ai utilisé UNION pour combiner les 
#résultats de LEFT JOIN et RIGHT JOIN. C'est l'équivalent exact de FULL OUTER JOIN. Je fournis également le 
#script avec FULL OUTER JOIN.

SELECT c.name AS customer_name, p.name AS product_name, o.order_id
FROM customers c
FULL JOIN orders o ON o.customer_id = c.customer_id
FULL JOIN products p ON p.product_id = o.product_id;

#9 deux requêtes équivalentes  
#avec des sous requêtes corrélées

#Cette requête sélectionne le nom de tous les clients ayant plus de 4 commandes. La condition de totalité 
#est exprimée dans la clause WHERE en utilisant une sous-requête corrélée qui compte le nombre de commandes 
#pour chaque client.

SELECT c.name AS customer_name
FROM customers c
WHERE (SELECT COUNT(o.order_id) FROM orders o WHERE o.customer_id = c.customer_id) > 4;

#10 deux requêtes équivalentes 
#avec de l’agrégation

#Cette requête sélectionne le nom de tous les clients ayant plus de 4 commandes. La condition de totalité 
#est exprimée dans la clause HAVING en utilisant l'agrégat COUNT qui compte le nombre de commandes pour 
#chaque client.

SET sql_mode = '';
SELECT c.name AS customer_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 4;

#11 deux requêtes qui renverraient le même résultat sans nulls et les résultats différents sinon

#Cette requête sélectionne le nom de tous les clients, le nom de tous les produits et la date de commande 
#ou de livraison de toutes les commandes. La fonction COALESCE renvoie la première valeur non NULL parmi 
#les valeurs passées en argument, donc dans ce cas, elle renvoie la date d'expédition si elle n'est pas NULL, 
#sinon elle renvoie la date de commande.

SELECT c.name AS customer_name, p.name AS product_name, 
		(CASE WHEN o.delivery_date != 'NULL' THEN o.delivery_date ELSE o.order_date END) AS delivery_or_order_date
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN products p ON p.product_id = o.product_id;


#

SELECT c.name AS customer_name, p.name AS product_name,
       (CASE WHEN o.delivery_date != 'NULL' THEN o.delivery_date ELSE o.order_date END) AS delivery_or_order_date
FROM customers c
JOIN (SELECT * FROM orders WHERE delivery_date != 'NULL') o ON o.customer_id = c.customer_id
JOIN products p ON p.product_id = o.product_id;


#12 deux requêtes qui renverraient le même résultat sans nulls et les résultats différents sinon

#Cette requête sélectionne le nom de tous les clients, le nom de tous les produits et la date de commande 
#ou de livraison de toutes les commandes. Dans ce cas, si la date d'expédition n'est pas NULL, la requête 
#retourne la date d'expédition, sinon elle retourne la date de commande.

SELECT c.name AS customer_name, p.name AS product_name, o.delivery_date AS delivery_or_order_date
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN products p ON p.product_id = o.product_id;

#

SELECT c.name AS customer_name, p.name AS product_name, o.delivery_date AS delivery_or_order_date
FROM customers c JOIN (SELECT customer_id, product_id, delivery_date FROM orders 
                       WHERE delivery_date != 'NULL') o 
ON o.customer_id = c.customer_id JOIN products p ON p.product_id = o.product_id;

#13 5 produits les plus populaires

#Le résultat de cette requête est une table contenant le nom des 5 produits les plus populaires et leur 
#quantité totale vendue.

SELECT p.name AS product_name, SUM(o.quantity) AS total_quantity
FROM products p
JOIN orders o ON o.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity DESC
LIMIT 5;

#14 la commande avec la livraison la plus longue

#Le résultat de cette requête est une table contenant les détails de la commande avec la livraison la plus 
#longue, y compris la durée de livraison en jours.

SELECT o.*, DATEDIFF(STR_TO_DATE(o.delivery_date, '%d/%m/%Y'), o.order_date) AS delivery_time
FROM orders o
WHERE o.status = 'livré'
ORDER BY delivery_time DESC
LIMIT 1;

#15 la catégorie de produits la plus commandée 

#Le résultat de cette requête est une table contenant la catégorie de produits la plus commandée et 
#sa quantité totale vendue.

SELECT p.category, SUM(o.quantity) AS total_quantity
FROM products p
JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity DESC
LIMIT 1;

#16 les 5 commandes les plus grandes

#Le résultat de cette requête est une table contenant les détails des 5 commandes les plus grandes, 
#triées par ordre décroissant de quantité de produits.

SELECT o.order_id, o.customer_id, o.product_id, p.name AS product_name, o.quantity, o.price, 
o.order_date, o.shipped_date, o.delivery_date
FROM orders o
JOIN products p ON p.product_id = o.product_id
ORDER BY o.quantity DESC
LIMIT 5;

#17 les 5 commandes les plus cheres

#Le résultat de cette requête est une table contenant les détails des 5 commandes les plus cheres, triées 
#par ordre décroissant de facture totale.

SELECT o.order_id, o.customer_id, o.product_id, p.name AS product_name, o.quantity, p.price, 
o.order_date, o.shipped_date, o.delivery_date, o.price AS total_bill
FROM orders o
JOIN products p ON p.product_id = o.product_id
ORDER BY total_bill DESC
LIMIT 5;

#18 le montant d'argent dépensé pour chaque catégorie de produits

#Le résultat de cette requête sera une table contenant la catégorie de produits et le montant total 
#dépensé pour chaque catégorie.

SELECT p.category, SUM(o.price) AS total_spend
FROM orders o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.category;

#19 le plus grand nombre de changements de prix 

#Le résultat de cette requête est une table contenant le nom des 5 produits ayant le plus grand nombre 
#de changements de prix, triés par ordre décroissant de nombre de changements de prix.

SELECT p.name, COUNT(h.product_id) AS price_changes
FROM products p
JOIN price_history h ON h.product_id = p.product_id
GROUP BY p.name
ORDER BY price_changes DESC
LIMIT 5;

#20 le plus de retours

#Le résultat de cette requête est une table contenant le nom des 5 clients ayant fait le plus de retours, 
#triés par ordre décroissant de nombre de retours.

SELECT customer_id, COUNT(*) as num_returns
FROM orders
JOIN return_requests
ON orders.order_id = return_requests.order_id
GROUP BY customer_id
ORDER BY num_returns DESC
LIMIT 5;