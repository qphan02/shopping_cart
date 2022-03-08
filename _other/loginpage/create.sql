PRAGMA foreign_keys=off;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  username        varchar(50) not null PRIMARY KEY,
  password        varchar(50) not null,
  type_user       varchar(50) not null,
  name            varchar(50) not null
);

DROP TABLE IF EXISTS students;
CREATE TABLE students (
  id          varchar(32) not null PRIMARY KEY,
  name        varchar(50) not null,
  email       varchar(50) not null,
  grade       varchar(5) not null,
  engagement  int(1)
);

PRAGMA foreign_keys=on;

-- users
INSERT INTO users VALUES ('ebaron', 'pass', 'TA', 'Ethan Baron');
INSERT INTO users VALUES ('acoleman', 'pass', 'TA', 'Alex Coleman');
INSERT INTO users VALUES ('jjacobs', 'pass', 'TA', 'Jett Jacobs');
INSERT INTO users VALUES ('timwood', 'pass', 'Professor', 'Tim Wood');
INSERT INTO users VALUES ('rstarr', 'pass', 'Student', 'Ringo Starr'); 

-- students
INSERT INTO students VALUES ('G12345678', 'Ringo Starr', 'ringo@fakeemail.com', 'A-', 2);
INSERT INTO students VALUES ('G82915273', 'Paul McCartney', 'paul@gmail.com', 'D', 0);
INSERT INTO students VALUES ('G22004676', 'John Lennon', 'john@fakeemail.com', 'A+', 3);
INSERT INTO students VALUES ('G46003216', 'George Harrison', 'george@aol.com', 'B', 1);
