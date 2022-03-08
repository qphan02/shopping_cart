
PRAGMA foreign_keys = off;

.mode column

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    email           VARCHAR(100)    NOT NULL,
    name            VARCHAR(100)    NOT NULL,
    password        VARCHAR(50)     NOT NULL,
    PRIMARY KEY (email)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    customer_email  VARCHAR(100),
    date            VARCHAR(100)    NOT NULL,
    total           INT(10)         NOT NULL,
    quantity        INT(10)         NOT NULL,
    FOREIGN KEY (customer_email) references users(email),
    PRIMARY KEY (customer_email, date)
);

DROP TABLE IF EXISTS category;
CREATE TABLE category(
    name            VARCHAR(50)     NOT NULL,
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS product;
CREATE TABLE product(
    id              INT(5)         NOT NULL,
    name            VARCHAR(50)     NOT NULL,
    price           DECIMAL(6,2),
    stock           INT(10),
    category        VARCHAR(50)     NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (category) references category(name)
);

DROP TABLE IF EXISTS orderitem;
CREATE TABLE orderitem(
    customer_email  VARCHAR(100),
    date            VARCHAR(100),
    product_id      INT(10),
    quantity        INT(10),
    FOREIGN KEY (customer_email) references orders(customer_email),
    FOREIGN KEY (date) references orders(date),
    FOREIGN KEY (product_id) references product(id),
    PRIMARY KEY (customer_email, date, product_id)
);

PRAGMA foreign_keys = on;

-- -- users
-- INSERT INTO users VALUES ('ebaron', 'pass', 'TA', 'Ethan Baron');
-- INSERT INTO users VALUES ('acoleman', 'pass', 'TA', 'Alex Coleman');
-- INSERT INTO users VALUES ('jjacobs', 'pass', 'TA', 'Jett Jacobs');
-- INSERT INTO users VALUES ('timwood', 'pass', 'Professor', 'Tim Wood');
-- INSERT INTO users VALUES ('rstarr', 'pass', 'Student', 'Ringo Starr'); 

-- users (email, name, password)
INSERT INTO users VALUES ('phan@gwu.edu', 'phan', 'pass');
INSERT INTO users VALUES ('user1@gwu.edu', 'user1', 'pass');
INSERT INTO users VALUES ('user2@gwu.edu', 'user2', 'pass');
INSERT INTO users VALUES ('user3@gwu.edu', 'user3', 'pass');
INSERT INTO users VALUES ('user4@gwu.edu', 'use4', 'pass');

-- category (name)
INSERT INTO category VALUES ('technology');
INSERT INTO category VALUES ('communication');
INSERT INTO category VALUES ('semiconductor');
INSERT INTO category VALUES ('industry');
INSERT INTO category VALUES ('cryptocurreny');

-- product (id, name, price, stock, category)
INSERT INTO product VALUES (01, 'AAPL', 159.30, 10, 'technology');
INSERT INTO product VALUES (02, 'MSFT', 278.91, 20, 'technology');
INSERT INTO product VALUES (03, 'AMZN', 187.47, 30, 'technology');
INSERT INTO product VALUES (04, 'GOOG', 2529.29, 40, 'communication');
INSERT INTO product VALUES (05, 'FB', 187.47, 50, 'communication');
INSERT INTO product VALUES (06, 'NVDA', 213.52, 60, 'semiconductor');
INSERT INTO product VALUES (07, 'TSLA', 804.58, 70, 'industry');
INSERT INTO product VALUES (08, 'BA', 169.17, 80, 'industry');
INSERT INTO product VALUES (09, 'BTC', 38919.10, 90, 'cryptocurreny');

-- oders (customer_email, date, total, quantity)

-- orderitem (customer_email, date, product_id, quantity)
-- INSERT INTO orderitem VALUES ("phan@gwu.edu", '08/03/2022', 09, 3);
