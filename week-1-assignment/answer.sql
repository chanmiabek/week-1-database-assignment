-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- 2. Create Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    country VARCHAR(100)
);

-- 3. Create Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year YEAR,
    author_id INT,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_books_author
        FOREIGN KEY (author_id) REFERENCES authors(author_id)
        ON DELETE SET NULL
);

-- 4. Create Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(30),
    joined_date DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- 5. Create Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT fk_loans_book
        FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_loans_member
        FOREIGN KEY (member_id) REFERENCES members(member_id)
        ON DELETE CASCADE
);

-- 6. Insert sample data
INSERT INTO authors (first_name, last_name, country) VALUES
    ('Chinua', 'Achebe', 'Nigeria'),
    ('Ngũgĩ', 'wa Thiong''o', 'Kenya'),
    ('Grace', 'Ogot', 'Kenya');

INSERT INTO books (title, isbn, publication_year, author_id, total_copies, available_copies) VALUES
    ('Things Fall Apart', '9780385474542', 1958, 1, 5, 4),
    ('Weep Not, Child', '9780143106692', 1964, 2, 3, 3),
    ('The Promised Land', '9789966460283', 1966, 3, 2, 2);

INSERT INTO members (full_name, email, phone, joined_date) VALUES
    ('Amina Hassan', 'amina.hassan@example.com', '+254700111222', '2026-01-15'),
    ('David Otieno', 'david.otieno@example.com', '+254711222333', '2026-02-10');

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date) VALUES
    (1, 1, '2026-11-01', '2026-11-15', NULL);

-- 7. Verify database objects and records
SHOW TABLES;
SELECT * FROM books;