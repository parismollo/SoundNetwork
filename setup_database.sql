-- open psql

-- drop database if exists
DROP DATABASE IF EXISTS noisebook;

-- create owner of database
DROP USER IF EXISTS admin;
CREATE USER admin WITH PASSWORD '123456';

-- create database
CREATE DATABASE noisebook OWNER paris;


-- create tables
\i create_tables.sql