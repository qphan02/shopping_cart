
PRAGMA foreign_keys = off;

.mode column

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    email           VARCHAR(100)    NOT NULL,
    name            VARCHAR(100)    NOT NULL,
    password        VARCHAR(50)     NOT NULL,
    balance         DECIMAL(8,2)    NOT NULL,
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

DROP TABLE IF EXISTS holdings;
CREATE TABLE holdings (
    customer_email  VARCHAR(100)    NOT NULL,
    ticket          VARCHAR(5)      NOT NULL,
    quantity        INT(50)         NOT NULL,
    balance         DECIMAL(8,2)    NOT NULL,
    PRIMARY KEY (customer_email, ticket),
    FOREIGN KEY (customer_email) references users(email),
    FOREIGN KEY (ticket) references product(ticket)
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

-- users (email, name, password, balance)
INSERT INTO users VALUES ('phan@gwu.edu', 'phan', 'pass', 100000.00);
INSERT INTO users VALUES ('test@gwu.edu', 'testuser', 'testpass', 100000.00);
INSERT INTO users VALUES ('user1@gwu.edu', 'user1', 'pass', 100000.00);
INSERT INTO users VALUES ('user2@gwu.edu', 'user2', 'pass', 100000.00);
INSERT INTO users VALUES ('user3@gwu.edu', 'user3', 'pass', 100000.00);
INSERT INTO users VALUES ('user4@gwu.edu', 'use4', 'pass', 100000.00);

-- category (name)
INSERT INTO category VALUES ('technology');
INSERT INTO category VALUES ('communication');
INSERT INTO category VALUES ('semiconductor');
INSERT INTO category VALUES ('industry');
INSERT INTO category VALUES ('cryptocurreny');

-- product (ticket, name, price, stock, category)
INSERT INTO product VALUES ('AAPL', 'Apple', 159.30, 1000, 'technology');
INSERT INTO product VALUES ('MSFT', 'Microsoft', 278.91, 1000, 'technology');
INSERT INTO product VALUES ('AMZN', 'Amazon', 187.47, 1000, 'technology');
INSERT INTO product VALUES ('GOOG', 'Alphabet', 2529.29, 1000, 'communication');
INSERT INTO product VALUES ('FB', 'Meta Platfrom', 187.47, 1000, 'communication');
INSERT INTO product VALUES ('NVDA', 'Nvidia', 213.52, 1000, 'semiconductor');
INSERT INTO product VALUES ('TSLA', 'Tesla', 804.58, 1000, 'industry');
-- INSERT INTO product VALUES ('BA', 'Boeing', 169.17, 1000, 'industry');
INSERT INTO product VALUES ('BTC', 'Bitcoin', 38919.10, 1000, 'cryptocurreny');
