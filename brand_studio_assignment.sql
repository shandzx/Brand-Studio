-- BRAND STUDIO DATABASE ASSIGNMENT

-- Scenario:
-- This database is designed for a brand studio business
-- to manage clients, services, projects, and payments.
-- It helps track which services clients book, project
-- progress, deadlines, and payment records.

-- CREATE AND USE DATABASE

CREATE DATABASE IF NOT EXISTS brand_studio_db;
USE brand_studio_db;

-- REMOVE TABLES IF THEY ALREADY EXIST
-- This allows the script to be rerun without conflicts

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS clients;

-- CLIENTS TABLE
-- Stores client personal details and business information

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    business_name VARCHAR(100) NOT NULL
);

-- SERVICES TABLE
-- Stores the different services offered by the brand studio
-- Each service includes a price and estimated delivery time

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    service_price DECIMAL(10,2) NOT NULL,
    delivery_days INT NOT NULL
);

-- PROJECTS TABLE
-- Stores projects booked by clients
-- Links each project to one client and one service

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    service_id INT NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    project_status VARCHAR(50) NOT NULL,
    deadline DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- PAYMENTS TABLE
-- Stores payment records for each project
-- Links each payment to one project

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- INSERT DATA INTO CLIENTS

INSERT INTO clients (first_name, last_name, email, business_name) VALUES
('Shanaya', 'Morton', 'shanaya@email.com', 'The Shan Mor'),
('Mia', 'Leya', 'mia@email.com', 'The Mia Studio'),
('Blanche', 'Studio', 'blanche@email.com', 'Blanche Studio'),
('Kachelle', 'White', 'kachelle@email.com', 'Silk Syndicate'),
('Maha', 'Co', 'maha@email.com', 'Drafts and Co'),
('Iman', 'London', 'iman@email.com', 'The Lash Artist'),
('Capri', 'Nells', 'capri@email.com', 'Nells Dreamhouse'),
('Lymara', 'Morton', 'lymara@email.com', 'I Always Affirmed');

-- INSERT DATA INTO SERVICES

INSERT INTO services (service_name, service_price, delivery_days) VALUES
('Brand Strategy', 500.00, 7),
('Visual Identity Design', 750.00, 10),
('Content Strategy', 400.00, 5),
('Website Copywriting', 350.00, 4),
('Instagram Refresh', 300.00, 3),
('Launch Strategy', 600.00, 8),
('Email Marketing Setup', 450.00, 6),
('Social Media Audit', 250.00, 3);

-- INSERT DATA INTO PROJECTS

INSERT INTO projects (client_id, service_id, project_name, project_status, deadline) VALUES
(1, 1, 'The Shan Mor Rebrand', 'Completed', '2026-04-20'),
(2, 2, 'The Mia Studio Identity', 'In Progress', '2026-04-25'),
(3, 3, 'Blanche Studio Content Plan', 'Completed', '2026-04-18'),
(4, 4, 'Silk Syndicate Website Copy', 'Not Started', '2026-05-01'),
(5, 5, 'Drafts and Co Instagram Refresh', 'In Progress', '2026-04-27'),
(6, 6, 'The Lash Artist Launch', 'Completed', '2026-04-22'),
(7, 7, 'Nells Dreamhouse Email Setup', 'On Hold', '2026-05-03'),
(8, 8, 'I Always Affirmed Social Audit', 'Completed', '2026-04-19');

-- INSERT DATA INTO PAYMENTS

INSERT INTO payments (project_id, amount_paid, payment_date, payment_status) VALUES
(1, 500.00, '2026-04-20', 'Paid'),
(2, 300.00, '2026-04-15', 'Partial'),
(3, 400.00, '2026-04-18', 'Paid'),
(4, 0.00, '2026-04-16', 'Pending'),
(5, 150.00, '2026-04-17', 'Partial'),
(6, 600.00, '2026-04-22', 'Paid'),
(7, 200.00, '2026-04-21', 'Partial'),
(8, 250.00, '2026-04-19', 'Paid');

-- QUERY 1
-- Retrieve all clients ordered by last name

SELECT *
FROM clients
ORDER BY last_name ASC;

-- QUERY 2
-- Retrieve all services ordered by highest price

SELECT *
FROM services
ORDER BY service_price DESC;

-- QUERY 3
-- Retrieve projects with client and service details
-- Uses INNER JOIN

SELECT 
    p.project_id,
    p.project_name,
    c.first_name,
    c.last_name,
    c.business_name,
    s.service_name,
    p.project_status,
    p.deadline
FROM projects p
JOIN clients c ON p.client_id = c.client_id
JOIN services s ON p.service_id = s.service_id
ORDER BY p.deadline ASC;


-- QUERY 4
-- Count the total number of projects
-- Uses aggregate function COUNT()

SELECT COUNT(*) AS total_projects
FROM projects;

SELECT * FROM projects;

-- QUERY 5
-- Find the average price of services
-- Uses aggregate function AVG()

SELECT AVG(service_price) AS average_service_price
FROM services;


-- QUERY 6
-- Retrieve projects currently in progress

SELECT 
    project_name,
    project_status,
    deadline
FROM projects
WHERE project_status = 'In Progress'
ORDER BY deadline ASC;

-- QUERY 7
-- Retrieve payment records with project names
-- Uses INNER JOIN

SELECT 
    pay.payment_id,
    p.project_name,
    pay.amount_paid,
    pay.payment_status,
    pay.payment_date
FROM payments pay
JOIN projects p ON pay.project_id = p.project_id
ORDER BY pay.amount_paid DESC;

SELECT * FROM payments;

-- QUERY 8
-- Display full client names using CONCAT()
-- Uses built-in string function

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    business_name
FROM clients
ORDER BY full_name ASC;


-- QUERY 9
-- Display service names in uppercase using UPPER()
-- Uses built-in string function

SELECT 
    UPPER(service_name) AS service_name_uppercase,
    service_price
FROM services
ORDER BY service_price DESC;


-- QUERY 10
-- Delete one payment record
-- Example of deleting incorrect or unwanted data

DELETE FROM payments
WHERE payment_id = 4;


-- QUERY 11
-- Show remaining payment records after deletion

SELECT *
FROM payments
ORDER BY payment_id ASC;

-- Query 12
-- Calculates the total amount paid for each project by grouping payments and summing amounts

SELECT 
    p.project_name,
    SUM(pay.amount_paid) AS total_paid
FROM payments pay
JOIN projects p ON pay.project_id = p.project_id
GROUP BY p.project_name
ORDER BY total_paid DESC;

DELIMITER //

CREATE PROCEDURE GetProjectsByStatus(IN input_status VARCHAR(50))
BEGIN
    SELECT 
        project_id,
        project_name,
        project_status,
        deadline
    FROM projects
    WHERE project_status = input_status
    ORDER BY deadline ASC;
END //

DELIMITER ;

CALL GetProjectsByStatus('Completed');