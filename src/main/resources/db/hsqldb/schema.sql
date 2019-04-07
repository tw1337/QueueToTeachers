CREATE TABLE IF NOT EXISTS groups
(
    id   INTEGER IDENTITY PRIMARY KEY,
    group_name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS users
(
  id INTEGER IDENTITY PRIMARY KEY,
	username       	     VARCHAR(80) NOT NULL,
	password   	     VARCHAR(80) NOT NULL,
	student_name VARCHAR(80) NOT NULL,
	student_surname VARCHAR(80) NOT NULL,
  group_id INTEGER     NOT NULL
);
ALTER TABLE users
    add CONSTRAINT fk_users_groups foreign key (group_id) REFERENCES groups (id);

CREATE TABLE IF NOT EXISTS events
(
    id          INTEGER IDENTITY PRIMARY KEY,
    event_name        varchar(80) NOT NULL,
    event_date   DATETIME,
    event_owner INTEGER     NOT NULL
);
ALTER TABLE events
    add constraint fk_events_users foreign key (event_owner) references users (id);