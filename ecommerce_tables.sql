DROP DATABASE ecommerce;

CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  tel_number VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  date_of_birthday DATE NOT NULL,
  date_of_inscription DATETIME NOT NULL
);

CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  category VARCHAR(255) NOT NULL,
  availability_status VARCHAR(255) NOT NULL,
  quantity_in_stock INTEGER,
  delivery_time VARCHAR(255)
);

CREATE TABLE price_history (
  price_history_id INTEGER PRIMARY KEY,
  product_id INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  change_date DATETIME NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TRIGGER update_price
AFTER INSERT ON price_history
FOR EACH ROW
  UPDATE products SET price = NEW.price WHERE product_id = NEW.product_id;

CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  price DECIMAL(10,2),
  delivery_address VARCHAR(255) NOT NULL,
  order_date DATE NOT NULL,
  status VARCHAR(255) NOT NULL,
  shipped_date VARCHAR(255) DEFAULT NULL,
  delivery_date VARCHAR(255) DEFAULT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE cancellation_requests (
  cancellation_requests_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  status VARCHAR(255) NOT NULL,
  request_date DATETIME NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
  );
  
  CREATE TABLE cancellation_requests_of_shipped_orders (
  cancellation_requests_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  status VARCHAR(255) NOT NULL,
  request_date DATETIME NOT NULL
  );
  
  
CREATE TRIGGER prevent_cancellation_of_shipped_orders
BEFORE INSERT ON cancellation_requests
FOR EACH ROW
BEGIN
  IF (SELECT shipped_date FROM orders WHERE order_id = NEW.order_id) IS NOT NULL THEN
    INSERT INTO cancellation_requests_of_shipped_orders (cancellation_requests_id, order_id, request_date, status)
    VALUES (NEW.cancellation_requests_id, NEW.order_id, NEW.request_date, NEW.status);
  END IF;
END;


CREATE TABLE cancellation_refunds (
  refund_id INTEGER PRIMARY KEY,
  cancellation_requests_id INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(255) NOT NULL,
  refund_date VARCHAR(255),
  FOREIGN KEY (cancellation_requests_id) REFERENCES cancellation_requests(cancellation_requests_id)
);

CREATE TABLE return_requests (
  return_request_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  reason TEXT NOT NULL,
  status VARCHAR(255) NOT NULL,
  request_date DATETIME NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
  );
  

CREATE TABLE return_refunds (
  refund_id INTEGER PRIMARY KEY,
  return_request_id INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(255) NOT NULL,
  refund_date VARCHAR(255),
  FOREIGN KEY (return_request_id) REFERENCES return_requests(return_request_id)
);

CREATE TRIGGER update_orders_status_cancellation
AFTER INSERT ON cancellation_requests
FOR EACH ROW
BEGIN
  UPDATE orders SET status = 'cancelled' WHERE order_id = NEW.order_id;
END;

CREATE TRIGGER update_orders_status_return
AFTER INSERT ON return_requests
FOR EACH ROW
BEGIN
  UPDATE orders SET status = 'returned' WHERE order_id = NEW.order_id;
END;

CREATE TRIGGER update_orders_status_return_refund
AFTER INSERT ON return_refunds
FOR EACH ROW
BEGIN
  IF NEW.status = 'remboursé' THEN
    UPDATE orders SET status = 'refunded' WHERE order_id IN (SELECT order_id FROM return_requests WHERE return_request_id = NEW.return_request_id);
  END IF;
END;

CREATE TRIGGER update_orders_status_cancel_refund
AFTER INSERT ON cancellation_refunds
FOR EACH ROW
BEGIN
  IF NEW.status = 'remboursé' THEN
    UPDATE orders SET status = 'refunded' WHERE order_id IN (SELECT order_id FROM cancellation_requests WHERE cancellation_requests_id = NEW.cancellation_requests_id);
  END IF;
END;

CREATE TABLE reviews (
  review_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  rating INTEGER NOT NULL,
  review TEXT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
 );