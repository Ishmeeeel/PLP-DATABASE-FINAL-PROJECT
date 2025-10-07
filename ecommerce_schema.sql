-- ===============================================
-- E-COMMERCE DATABASE SCHEMA (QUESTION 1)
-- Designed for: MySQL
-- Normalization: 3NF/BCNF
-- Use Case: Tracking Customers, Products, Orders, and Inventory.
-- ===============================================

-- 1. DATABASE CREATION
-- Note: Replace 'ecommerce_db' with your desired database name if necessary.
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ===============================================
-- 2. CREATE TABLES
-- ===============================================

-- A. Customers Table (Entity)
-- Contains basic customer information.
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL, -- UNIQUE ensures no duplicate email accounts
    phone VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- B. Product Categories Table (Entity)
-- Used to organize products (e.g., Electronics, Clothing, Books).
-- This handles the "One-to-Many" relationship (One Category has Many Products).
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

-- C. Products Table (Entity)
-- Contains details about available inventory items.
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0), -- Constraint: Price must be positive
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),   -- Constraint: Quantity cannot be negative
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- D. Orders Table (Entity)
-- Represents a single transaction placed by a customer.
-- This handles the "One-to-Many" relationship (One Customer places Many Orders).
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- E. Order_Items Table (Junction/Associative Entity)
-- Handles the "Many-to-Many" relationship between Orders and Products.
-- One Order can have Many Products, and One Product can be in Many Orders.
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order DECIMAL(10, 2) NOT NULL, -- The price when the order was placed
    -- Composite UNIQUE key ensures a product is listed only once per order
    UNIQUE KEY unique_order_product (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- F. Addresses Table (Entity - Demonstrates One-to-One/Optional One-to-Many)
-- Stored separately for normalization (eliminating potential transitive dependencies) and reuse.
CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL, -- UNIQUE key enforces a 1:1 or 1:M relationship
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    -- Cascading delete: if a customer is deleted, their address is also deleted.
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- ===============================================
-- 3. INDEXES FOR PERFORMANCE
-- ===============================================

-- Index on email for fast logins/lookups
CREATE INDEX idx_customer_email ON Customers (email);

-- Index on product name for searching
CREATE INDEX idx_product_name ON Products (product_name);

-- Index on order date for reports
CREATE INDEX idx_order_date ON Orders (order_date);


-- ===============================================
-- 4. EXAMPLE DATA INSERTION (Optional but helpful for testing)
-- ===============================================

INSERT INTO Customers (first_name, last_name, email, phone) VALUES
('Alex', 'Johnson', 'alex.j@example.com', '555-1234'),
('Maria', 'Garcia', 'maria.g@example.com', '555-5678');

INSERT INTO Addresses (customer_id, street, city, zip_code, country) VALUES
(1, '100 Main St', 'New York', '10001', 'USA'),
(2, '25 Oak Ave', 'Chicago', '60601', 'USA');

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Apparel');

INSERT INTO Products (product_name, description, unit_price, stock_quantity, category_id) VALUES
('Laptop Pro', 'High-end laptop.', 1200.00, 50, 1),
('T-Shirt Cotton', 'Plain cotton tee.', 25.50, 200, 2),
('Wireless Mouse', 'Ergonomic wireless mouse.', 35.00, 150, 1);

INSERT INTO Orders (customer_id, total_amount, status) VALUES
(1, 1235.00, 'Shipped'),
(2, 51.00, 'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_order) VALUES
(1, 1, 1, 1200.00), -- 1 Laptop Pro
(1, 3, 1, 35.00),   -- 1 Wireless Mouse
(2, 2, 2, 25.50);   -- 2 T-Shirt Cotton

