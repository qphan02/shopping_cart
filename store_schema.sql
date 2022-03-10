
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
    ticket          VARCHAR(5)     NOT NULL,
    name            VARCHAR(20)    NOT NULL,
    price           DECIMAL(6,2),
    stock           INT(10)        NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    PRIMARY KEY (ticket),
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

-- users (email, name, password)
INSERT INTO users VALUES ('phan@gwu.edu', 'phan', 'pass');
INSERT INTO users VALUES ('test@gwu.edu', 'testuser', 'testpass');
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

-- product (ticket, name, price, stock, category)
INSERT INTO product VALUES ('AAPL', 'Apple', 159.30, 10, 'technology');
INSERT INTO product VALUES ('MSFT', 'Microsoft', 278.91, 20, 'technology');
INSERT INTO product VALUES ('AMZN', 'Amazon', 187.47, 30, 'technology');
INSERT INTO product VALUES ('GOOG', 'Alphabet', 2529.29, 40, 'communication');
INSERT INTO product VALUES ('FB', 'Meta Platfrom', 187.47, 50, 'communication');
INSERT INTO product VALUES ('NVDA', 'Nvidia', 213.52, 60, 'semiconductor');
INSERT INTO product VALUES ('TSLA', 'Tesla', 804.58, 70, 'industry');
-- INSERT INTO product VALUES ('BA', 'Boeing', 169.17, 80, 'industry');
INSERT INTO product VALUES ('BTC', 'Bitcoin', 38919.10, 90, 'cryptocurreny');
