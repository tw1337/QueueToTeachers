CREATE TABLE IF NOT EXISTS users
(
  id INTEGER IDENTITY PRIMARY KEY,
	username       	     VARCHAR(80) NOT NULL,
	password   	     VARCHAR(80) NOT NULL,
	naming 	     VARCHAR(80) NOT NULL,
	surname 	     VARCHAR(80) NOT NULL,
);