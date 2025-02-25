CREATE DATABASE booking_room;
USE booking_room;

CREATE TABLE Customer (
	customer_id varchar(10) primary key ,
    customer_full_name varchar(150) not null,
    customer_email varchar(255) unique,
    customer_address varchar(255) not null
);

CREATE TABLE Room (
	room_id varchar(10) primary key,
    room_price decimal(10,2),
    room_status enum("Available", "Booked"),
    room_area int
);

CREATE TABLE Booking (
	booking_id int auto_increment primary key,
    customer_id varchar(10) not null,
    room_id varchar(10) not null  ,
    check_in_date date not null,
    check_out_date date not null,
    total_amount decimal(10,2),
    foreign key (customer_id) references Customer(customer_id),
	foreign key (room_id) references Room(room_id)
);

CREATE TABLE Payment (
	payment_id int auto_increment primary key,
    booking_id int not null,
    payment_method varchar(50),
    payment_date date not null,
    payment_amount decimal(10,2),
    foreign key (booking_id) references Booking(booking_id)
);

alter table Room add column room_type enum("single", "double", "suite");
alter table Customer add column customer_phone char(15) not null unique;
alter table Booking add constraint total_amount check(total_amount >= 0); 

-- 3.1
INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address) 
	VALUE 
		("C001", "Nguyen Anh Tu", "tu.nguyen@example.com", "0912345678", "Hanoi, Vietnam"),
        ("C002", "Tran Thi Mai", "mai.tran@example.com", "0923456789", "Ho Chi Minh, Vietnam"),
        ("C003", "Le Minh Hoang", "hoang.le@example.com", "0934567890", "Danang, Vietnam"),
        ("C004", "Pham Hoang Nam", "nam.pham@example.com", "0945678901", "Hue, Vietnam"),
        ("C005", "Vu Minh Thu", "thu.vu@example.com", "0956789012", "Hai Phong, Vietnam"),
        ("C006", "Nguyen Thi Lan", "lan.nguyen@example.com", "0967890123", "Quang Ninh, Vietnam"),
        ("C007", "Bui Minh Tuan", "tuan.bui@example.com", "0978901234", "Bac Giang, Vietnam"),
        ("C008", "Pham Quang Hieu", "hieu.pham@example.com", "0989012345", "Quang Nam, Vietnam"),
        ("C009", "Le Thi Lan", "lan.le@example.com", 0990123456, "Da Lat, Vietnam"),
        ("C010", "Nguyen Thi Mai", "mai.nguyen@example.com", "0901234567", "Can Tho, Vietnam");
        
INSERT INTO Room (room_id, room_type, room_price, room_status, room_area)
	VALUE
		("R001", "Single", 100.0, "Available", 25),
        ("R002", "Double", 150.0, "Booked", 40),
        ("R003", "Suite", 250.0, "Available", 60),
        ("R004", "Single", 120.0, "Booked", 30),
        ("R005", "Double", 160.0, "Available", 35);

INSERT INTO Booking (customer_id, room_id, check_in_date, check_out_date, total_amount)
	VALUE 
		("C001", "R001", "2025-03-01", "2025-03-05", 400.0),
        ("C002", "R002", "2025-03-02", "2025-03-06", 600.0),
        ("C003", "R003", "2025-03-03", "2025-03-07", 1000.0),
        ("C004", "R004", "2025-03-04", "2025-03-08", 480.0),
        ("C005", "R005", "2025-03-05", "2025-03-09", 800.0),
        ("C006", "R001", "2025-03-06", "2025-03-10", 400.0),
        ("C007", "R002", "2025-03-07", "2025-03-11", 600.0),
        ("C008", "R003", "2025-03-08", "2025-03-12", 1000.0),
        ("C009", "R004", "2025-03-09", "2025-03-13", 480.0),
        ("C010", "R005", "2025-03-10", "2025-03-14", 800.0);

INSERT INTO Payment (booking_id, payment_method, payment_date, payment_amount)
	VALUE
		(1, "Cash", "2025-03-05", 400.0),
        (2, "Credit Card", "2025-03-06", 600.0),
        (3, "Bank Transfer", "2025-03-07", 1000.0),
        (4, "Cash", "2025-03-08", 480.0),
        (5, "Credit Card", "2025-03-09", 800.0),
        (6, "Bank Transfer", "2025-03-10", 400.0),
        (7, "Cash", "2025-03-11", 600.0),
        (8, "Credit Card", "2025-03-12", 1000.0),
        (9, "Bank Transfer", "2025-03-13", 480.0),
        (10, "Cash", "2025-03-14", 800.0),
        (1, "Credit Card", "2025-03-15", 400.0),
        (2, "Bank Transfer", "2025-03-16", 600.0),
        (3, "Cash", "2025-03-17", 1000.0),
        (4, "Credit Card", "2025-03-18", 480.0),
        (5, "Bank Transfer", "2025-03-19", 800.0),
        (6, "Cash", "2025-03-20", 400.0),
        (7, "Credit Card", "2025-03-21", 600.0),
        (8, "Bank Transfer", "2025-03-22", 1000.0),
        (9, "Cash" , "2025-03-23", 480.0),
        (10, "Credit Card", "2025-03-24", 800.0);
        
-- 3.2
UPDATE Booking b
JOIN Room r ON b.room_id = r.room_id
SET b.total_amount = r.room_price * DATEDIFF(b.check_out_date, b.check_in_date)
WHERE r.room_status = 'Đã đặt' AND b.check_in_date < CURDATE();

-- 3.3
DELETE FROM Payment WHERE payment_method = 'Cash' AND payment_amount < 500;
        
-- 4.1
SELECT customer_full_name, customer_email, customer_phone, customer_address 
FROM Customer
ORDER BY customer_full_name;

-- 4.2
SELECT room_id, room_type, room_price, room_area 
FROM Room
ORDER BY room_price desc;

-- 4.3 
SELECT c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
FROM Customer c
JOIN Booking b on c.customer_id = b.customer_id;

-- 4.4
SELECT c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
FROM Booking b
JOIN Customer c on c.customer_id = b.customer_id
JOIN Payment p on p.booking_id = b.booking_id
ORDER BY p.payment_amount DESC;

-- 4.5
SELECT *
FROM Customer
ORDER BY customer_full_name
LIMIT 3 
OFFSET 1;

-- 4.6
SELECT c.customer_id, c.customer_full_name, COUNT(DISTINCT b.room_id)
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name
HAVING COUNT(DISTINCT b.room_id) >= 2 AND SUM(p.payment_amount) > 1000;

-- 4.7
SELECT r.room_id, r.room_type, r.room_price, SUM(p.payment_amount) 
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY r.room_id, r.room_type, r.room_price
HAVING SUM(p.payment_amount) < 1000 AND COUNT(DISTINCT b.customer_id) >= 3;

-- 4.8
SELECT c.customer_id, c.customer_full_name, b.room_id, SUM(p.payment_amount)
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name, b.room_id
HAVING SUM(p.payment_amount) > 1000;

-- 4.9
-- nhieu nhat
SELECT r.room_id, r.room_type, COUNT(DISTINCT b.customer_id) AS so_luong_khach_hang_dat
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
GROUP BY r.room_id, r.room_type
ORDER BY so_luong_khach_hang_dat DESC
LIMIT 1;

-- it nhat
SELECT r.room_id, r.room_type, COUNT(DISTINCT b.customer_id) AS so_luong_khach_hang_dat
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
GROUP BY r.room_id, r.room_type
ORDER BY so_luong_khach_hang_dat ASC
LIMIT 1;

-- 4.10
SELECT c.customer_id, c.customer_full_name, b.room_id, SUM(p.payment_amount)
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name, b.room_id
HAVING SUM(p.payment_amount) > (SELECT AVG(payment_amount) FROM Payment WHERE booking_id IN (SELECT booking_id FROM Booking WHERE room_id = b.room_id));

-- 5.1
CREATE VIEW View_BookingsBeforeDate AS
SELECT r.room_id, r.room_type, c.customer_id, c.customer_full_name
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Customer c ON b.customer_id = c.customer_id
WHERE b.check_in_date < '2025-03-10';

-- 5.2
CREATE VIEW View_LargeRoomsBookings AS
SELECT c.customer_id, c.customer_full_name, b.room_id, r.room_area
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Room r ON b.room_id = r.room_id
WHERE r.room_area > 30;

-- 6.1
DELIMITER //
CREATE TRIGGER check_insert_booking
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    IF NEW.check_in_date > NEW.check_out_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày đặt phòng không thể sau ngày trả phòng được !';
    END IF;
END;//
DELIMITER ;

-- 6.2
DELIMITER //
CREATE TRIGGER update_room_status_on_booking
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    UPDATE Room
    SET room_status = 'Đã đặt'
    WHERE room_id = NEW.room_id;
END;//
DELIMITER ;

-- 7.1
DELIMITER //
CREATE PROCEDURE add_customer (
    IN p_customer_id VARCHAR(10),
    IN p_customer_full_name VARCHAR(150),
    IN p_customer_email VARCHAR(255),
    IN p_customer_address VARCHAR(255),
    IN p_customer_phone CHAR(15)
)
BEGIN
    INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_address, customer_phone)
    VALUES (p_customer_id, p_customer_full_name, p_customer_email, p_customer_address, p_customer_phone);
END;//
DELIMITER ;

-- 7.2
DELIMITER //
CREATE PROCEDURE add_payment (
    IN p_booking_id INT,
    IN p_payment_method VARCHAR(50),
    IN p_payment_amount DECIMAL(10, 2),
    IN p_payment_date DATE
)
BEGIN
    INSERT INTO Payment (booking_id, payment_method, payment_amount, payment_date)
    VALUES (p_booking_id, p_payment_method, p_payment_amount, p_payment_date);
END;//
DELIMITER ;




















































