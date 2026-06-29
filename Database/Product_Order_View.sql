DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
create Table Product(
p_id serial primary key,
p_name varchar(20) not null
);
create table orders(
o_id serial primary key,
Delivery_location varchar(20) not null,
p_id int REFERENCES Product(p_id), 
Available_stock int
);
INSERT INTO product (p_name)
VALUES
('Laptop'),
('Mouse'),
('Keyboard'),
('Monitor'),
('Printer'),
('Scanner'),
('Speaker'),
('Webcam'),
('Hard Disk'),
('UPS');
INSERT INTO orders (Delivery_location,p_id, Available_stock)
VALUES
('japan',1, 850),
('india',2, 920),
('india',3, 1100),
('china',4, 875),
('china',5, 980),
('japan',6, 1200),
('china',7, 1050),
('japan',8, 890),
('india',9, 1150),
('india',10, 1000);
SELECT * FROM Product;
select * from Orders;

CREATE VIEW available_products AS
SELECT Product.p_id, Product.p_name, orders.available_stock
FROM Product 
JOIN Orders 
ON Product.p_id = Orders.p_id
WHERE Available_stock > 500;

select * from available_products;