CREATE TABLE Users (
email VARCHAR(100) NOT NULL,
name VARCHAR(100) NOT NULL,
password VARCHAR(50) NOT NULL,
PRIMARY KEY (email));
INSERT INTO Users VALUES("me@virajprakash.com", "Viraj Prakash", "pass");
INSERT INTO Users VALUES("testuser", "testuser", "testpass");

CREATE TABLE Orders (
customer_email VARCHAR(100),
date VARCHAR(100) NOT NULL,
total INT(10) NOT NULL,
FOREIGN KEY (customer_email) references Users(email),
PRIMARY KEY (customer_email, date)
);

CREATE TABLE Category(name VARCHAR(50) NOT NULL,
PRIMARY KEY (name)
);
INSERT INTO Category VALUES("Java software");
INSERT INTO Category VALUES("Full stack solution");
INSERT INTO Category VALUES("Consulting service");


CREATE TABLE Product(
id INT(10) NOT NULL,
name VARCHAR(50) NOT NULL,
price INT(10),
stock INT(10),
category VARCHAR(50) NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (category) references category(name)
);
INSERT INTO Product VALUES(1, "Single page, static HTML site", 5, 10, "Miscellaneous");
INSERT INTO Product VALUES(2, "Dynamic web application with DBMS integration", 1000, 4, "Full stack solution");
INSERT INTO Product VALUES(3, "Small Java Application", 50, 20, "Java software");
INSERT INTO Product VALUES(4, "Medium Java Application", 150, 10, "Java software");
INSERT INTO Product VALUES(5, "Large Java Application with GUI or multi client communication", 500, 5, "Java software");
INSERT INTO Product VALUES(6, "15 minute virtual consultation", 10, 50, "Consulting service");
INSERT INTO Product VALUES(7, "30 minute virtual consultation", 20, 50, "Consulting service");
INSERT INTO Product VALUES(8, "45 minute virtual consultation", 30, 50, "Consulting service");
INSERT INTO Product VALUES(9, "60 minute virtual consultation", 40, 50, "Consulting service");
INSERT INTO Product VALUES(10, "120 minute virtual consultation", 80, 50, "Consulting service");
CREATE TABLE OrderItem(
customer_email VARCHAR(100),
date VARCHAR(100),
product_id INT(10),
quantity INT(10),
FOREIGN KEY (customer_email) references Orders(customer_email),
FOREIGN KEY (date) references Orders(date),
FOREIGN KEY (product_id) references Product(id),
PRIMARY KEY (customer_email, date, product_id)
);

  

