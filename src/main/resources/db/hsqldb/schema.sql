CREATE TABLE IF NOT EXISTS users
(
  id INTEGER IDENTITY PRIMARY KEY,
	username       	     VARCHAR(80) NOT NULL,
	password   	     VARCHAR(80) NOT NULL,
	studentname VARCHAR(80) NOT NULL,
	studentsurname VARCHAR(80) NOT NULL,
	studentgroup VARCHAR(80) NOT NULL
);