DROP DATABASE IF EXISTS development;
CREATE DATABASE development;
USE development;

CREATE TABLE users (
  uid int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  firstname varchar(100) NOT NULL,
  lastname varchar(100) NOT NULL,
  email varchar(120) NOT NULL UNIQUE,
  pwdhash varchar(100) NOT NULL
);

CREATE TABLE c1 (
  c1_name varchar(45) NOT NULL,
  PRIMARY KEY(c1_name)
);

CREATE TABLE c2 (
  c1_name varchar(45) references `c1`,
  c2_name varchar(45) NOT NULL,
  PRIMARY KEY(c1_name,c2_name)
);

CREATE TABLE emots (
  c1_name varchar(45) references `c1`,
  c2_name varchar(45) references `c2`,
  emot_name varchar(45) NOT NULL,
  PRIMARY KEY(c2_name, emot_name)
);

CREATE TABLE chtn (
  c1_name varchar(45) references `c1`,
  c2_name varchar(45) references `c2`,
  emot_name varchar(45) references `emots`,
  chtn_id bigint NOT NULL AUTO_INCREMENT,
  chtn_url varchar(100),
  PRIMARY KEY(chtn_id)
);

desc `users`;
desc `c1`;
desc `c2`;
desc `emots`;
desc `chtn`;
