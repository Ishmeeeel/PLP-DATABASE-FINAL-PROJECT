E-commerce Database Management System
This repository contains the SQL schema for a complete relational database management system (RDBMS) designed to track an E-commerce store's data, fulfilling Question 1 of the assignment.

Design Overview
The database is named ecommerce_db and is designed to adhere to Third Normal Form (3NF), ensuring minimal data redundancy and high data integrity.

Entities and Relationships
Entity

Primary Key (PK)

Key Relationships

Normal Form Feature

Customers

customer_id

1:M with Orders

Stores atomic customer information.

Addresses

address_id

1:1 with Customers

Separated to allow for clear one-to-one mapping of the primary address.

Categories

category_id

1:M with Products

Prevents repeating category names in the Products table (3NF).

Products

product_id

M:N with Orders (via Order_Items)

Contains price and stock details.

Orders

order_id

1:M with Order_Items

Tracks the transaction history.

Order_Items

order_item_id

M:N Associative Table

Breaks down the Many-to-Many relationship between Orders and Products.

Key Constraints and Data Integrity
The schema uses several constraints to enforce data integrity:

Primary Keys (PK): Unique identifier for each record (customer_id, product_id, etc.).

Foreign Keys (FK): Used to define relationships between tables (e.g., customer_id in Orders links to Customers).

NOT NULL: Ensures essential fields (like first_name, email, unit_price) are always populated.

UNIQUE: Enforced on email in the Customers table to prevent duplicate user accounts.

CHECK: Custom rules like ensuring unit_price is greater than 0 and stock_quantity is not negative.

ON DELETE CASCADE: Applied to the foreign key in the Addresses table, ensuring that if a customer is deleted, their associated address record is also removed.

How to Implement the Schema
Open MySQL: Access your MySQL environment (via Workbench, command line, or another tool).

Execute Script: Open the ecommerce_schema.sql file.

Run: Execute the entire script. It will automatically:

Create the ecommerce_db database.

Switch to the new database (USE ecommerce_db;).

Create all six tables with their respective keys and constraints.

Create relevant indexes for performance.

Insert sample data for testing.
