USE ecommerce;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(customer_id, name, email, tel_number, address, @date_of_birthday, @date_of_inscription)
SET date_of_birthday = STR_TO_DATE(@date_of_birthday, '%d/%m/%Y'), date_of_inscription = STR_TO_DATE(@date_of_inscription, '%d/%m/%Y');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/price_history.csv'
INTO TABLE price_history
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(price_history_id, product_id, price, @change_date)
SET change_date = STR_TO_DATE(@change_date, '%d/%m/%Y');


CREATE TABLE temp_orders (
  order_id INTEGER,
  customer_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  price DECIMAL(10,2),
  delivery_address VARCHAR(255),
  order_date DATE,
  status VARCHAR(255),
  shipped_date VARCHAR(255),
  delivery_date VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE temp_orders
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(order_id, customer_id, product_id, quantity, delivery_address, @order_date, status, shipped_date, delivery_date)
SET order_date = STR_TO_DATE(@order_date, '%d/%m/%Y');
UPDATE temp_orders t
JOIN products p ON p.product_id = t.product_id
SET t.price = p.price*t.quantity;
INSERT INTO orders (order_id, customer_id, product_id, quantity, price, delivery_address, order_date, status, shipped_date, delivery_date)
SELECT order_id, customer_id, product_id, quantity, price, delivery_address, order_date, status, shipped_date, delivery_date
FROM temp_orders;

DROP TABLE temp_orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cancellations.csv'
INTO TABLE cancellation_requests
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(cancellation_requests_id, order_id, status, @request_date)
SET request_date = STR_TO_DATE(@request_date, '%Y-%m-%d');

DROP TABLE cancellation_requests_of_shipped_orders;

CREATE TABLE temp_cancellation_refunds (
  refund_id INTEGER,
  cancellation_requests_id INTEGER,
  amount DECIMAL(10,2),
  status VARCHAR(255),
  refund_date VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cancellation_refunds.csv'
INTO TABLE temp_cancellation_refunds
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(refund_id, cancellation_requests_id, status, refund_date);

UPDATE temp_cancellation_refunds t
JOIN cancellation_requests rr ON rr.cancellation_requests_id = t.cancellation_requests_id
JOIN orders o ON o.order_id = rr.order_id
SET t.amount = o.price;

INSERT INTO cancellation_refunds (refund_id, cancellation_requests_id, amount, status, refund_date)
SELECT refund_id, cancellation_requests_id, amount, status, refund_date
FROM temp_cancellation_refunds;

DROP TABLE temp_cancellation_refunds;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/returns.csv'
INTO TABLE return_requests
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(return_request_id, order_id, reason, status, @request_date)
SET request_date = STR_TO_DATE(@request_date, '%Y-%m-%d');

CREATE TABLE temp_return_refunds (
  refund_id INTEGER,
  return_request_id INTEGER,
  amount DECIMAL(10,2),
  status VARCHAR(255),
  refund_date VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/return_refunds.csv'
INTO TABLE temp_return_refunds
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(refund_id, return_request_id, status, refund_date);

UPDATE temp_return_refunds t
JOIN return_requests rr ON rr.return_request_id = t.return_request_id
JOIN orders o ON o.order_id = rr.order_id
SET t.amount = o.price;

INSERT INTO return_refunds (refund_id, return_request_id, amount, status, refund_date)
SELECT refund_id, return_request_id, amount, status, refund_date
FROM temp_return_refunds;

DROP TABLE temp_return_refunds;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;