--Index creation scripts to optimize query performance 

--use DB
USE LibraryManagementSystem;

--Apply indexes to speed up commonly-used queries: 

--1. Library Table:
--1.1. Non-clustered on Name → Search by name 

CREATE NONCLUSTERED INDEX IX_Library_LibraryName
ON Library (LibraryName);
