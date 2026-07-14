-- PostgreSQL Schema for Airline Reservation System (SkyGlide Airways)

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. Create Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    phone VARCHAR(50),
    address VARCHAR(255),
    dob DATE,
    usertype VARCHAR(50) DEFAULT 'user'
);

-- 2. Create Flights Table
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number INT NOT NULL,
    departure VARCHAR(255) NOT NULL,
    arrival VARCHAR(255) NOT NULL,
    date TIMESTAMP NOT NULL,
    price VARCHAR(50) NOT NULL
);

-- 3. Create Payments Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    paymentMode VARCHAR(50) NOT NULL,
    cardNumber VARCHAR(50),
    expiry VARCHAR(10),
    cvv VARCHAR(5)
);

-- 4. Create Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    flight_id INT NOT NULL,
    flight_number VARCHAR(50) NOT NULL,
    departure VARCHAR(255) NOT NULL,
    arrival VARCHAR(255) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    payment_id VARCHAR(50) DEFAULT 'PENDING',
    seat_number VARCHAR(50),
    passenger_name VARCHAR(255),
    passenger_age INT,
    passenger_gender VARCHAR(50),
    
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert sample flights for testing
INSERT INTO flights (flight_number, departure, arrival, date, price) VALUES
(101, 'Delhi', 'Mumbai', '2026-07-20 08:00:00', '4500.00'),
(102, 'Mumbai', 'Delhi', '2026-07-20 12:00:00', '4800.00'),
(103, 'Bangalore', 'Delhi', '2026-07-21 15:30:00', '5200.00'),
(104, 'Delhi', 'Bangalore', '2026-07-21 19:45:00', '5500.00'),
(105, 'Kolkata', 'Mumbai', '2026-07-22 10:15:00', '6000.00');
