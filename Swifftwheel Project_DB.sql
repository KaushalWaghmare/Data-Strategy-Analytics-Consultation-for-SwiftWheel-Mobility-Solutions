Create database swiftwheel_mobility_solutions_schemas
use swiftwheel_mobility_solutions_schemas

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  city VARCHAR(50),
  membership_type VARCHAR(20),
  registration_date DATE
);

CREATE TABLE Scooters (
  scooter_id INT AUTO_INCREMENT PRIMARY KEY,
  model VARCHAR(50),
  city VARCHAR(50),
  battery_level INT,
  status VARCHAR(20)
);

CREATE TABLE Staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100),
  role VARCHAR(50),
  city VARCHAR(50)
);

CREATE TABLE Trips (
  trip_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  scooter_id INT,
  start_time DATETIME,
  end_time DATETIME,
  start_city VARCHAR(50),
  end_city VARCHAR(50),
  cost DECIMAL(5,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (scooter_id) REFERENCES Scooters(scooter_id)
);

CREATE TABLE Payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT,
  amount DECIMAL(5,2),
  payment_status VARCHAR(20),
  payment_method VARCHAR(20),
  FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

CREATE TABLE Maintenance (
  maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
  scooter_id INT,
  staff_id INT,
  issue_report VARCHAR(200),
  repair_date DATE,
  status VARCHAR(20),
  FOREIGN KEY (scooter_id) REFERENCES Scooters(scooter_id),
  FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);



INSERT INTO Customers (full_name,email,city,membership_type,registration_date) VALUES
('Jack Patel','jack@gmail.com','London','Gold','2025-01-05'),
('Ben ten','ben@yahoo.com','Leeds','Standard','2025-02-11'),
('Ami Jones','ami@hotmail.com','Cardiff','Gold','2025-03-08'),
('David Sen','david@gmail.com','Edinburgh','Basic','2025-01-22'),
('Vatsal Patel','vatsal@gmail.com','London','Standard','2025-02-17'),
('Harrow Arris','harrow@yahoo.com','Cardiff','Basic','2025-02-28'),
('Young Lee','young@gmail.com','Leeds','Gold','2025-03-10'),
('Holly King','holly@gmail.com','Edinburgh','Standard','2025-01-18'),
('Ian Brown','ian@gmail.com','London','Gold','2025-02-05'),
('Juli Raval','juli@gmail.com','Cardiff','Standard','2025-03-12');


INSERT INTO Scooters (model,city,battery_level,status) VALUES
('X1','London',75,'Available'),
('X1','London',42,'Available'),
('A2','Leeds',56,'In Repair'),
('A2','Leeds',88,'Available'),
('Z3','Cardiff',26,'Available'),
('Z3','Cardiff',20,'Low Battery'),
('X1','Edinburgh',69,'Available'),
('A2','Edinburgh',20,'Low Battery'),
('Z3','London',67,'Available'),
('X1','Cardiff',53,'Available');




INSERT INTO Trips (customer_id,scooter_id,start_time,end_time,start_city,end_city,cost) VALUES
(1,1,'2025-03-01 09:00','2025-03-01 09:12','London','London',2.40),
(2,3,'2025-03-01 10:15','2025-03-01 10:30','Leeds','Leeds',3.10),
(5,1,'2025-03-02 11:20','2025-03-02 11:40','London','London',3.50),
(7,4,'2025-03-02 12:00','2025-03-02 12:25','Leeds','Leeds',4.20),
(3,5,'2025-03-03 14:10','2025-03-03 14:18','Cardiff','Cardiff',1.90),
(9,9,'2025-03-03 15:00','2025-03-03 15:10','London','London',2.00),
(4,7,'2025-03-04 16:30','2025-03-04 16:50','Edinburgh','Edinburgh',3.80),
(8,8,'2025-03-05 10:45','2025-03-05 10:55','Edinburgh','Edinburgh',2.10),
(6,6,'2025-03-05 13:00','2025-03-05 13:20','Cardiff','Cardiff',3.60),
(10,10,'2025-03-06 09:30','2025-03-06 09:48','Cardiff','Cardiff',3.00);


INSERT INTO Payments (trip_id,amount,payment_status,payment_method) VALUES
(1,2.40,'Paid','Card'),
(2,3.10,'Paid','Card'),
(3,3.50,'Paid','Wallet'),
(4,4.20,'Pending','Card'),
(5,1.90,'Paid','Card'),
(6,2.00,'Paid','Wallet'),
(7,3.80,'Paid','Card'),
(8,2.10,'Pending','Card'),
(9,3.60,'Paid','Wallet'),
(10,3.00,'Paid','Card');

INSERT INTO Staff (full_name, role, city) VALUES
('Alice Hender', 'Branch Manager', 'London'),
('Marcus Thor', 'Assistant Manager', 'Leeds'),
('Titan Williams', 'Customer Success', 'Cardiff'),
('Nevil Robertson', 'Sales Lead', 'Edinburgh'),
('Priya Sharma', 'Technical Support', 'London'),
('Gareth Evans', 'Inventory Clerk', 'Cardiff'),
('Fiona Campbell', 'Floor Supervisor', 'Edinburgh'),
('Jordan Patel', 'Sales Associate', 'Leeds'),
('Dominic Torento', 'Security Lead', 'London'),
('Jay Price', 'Junior Associate', 'Cardiff');

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO Maintenance (scooter_id, staff_id, issue_report, repair_date, status) 
VALUES 
(3,1,'Brake repair','2024-03-02','Completed'), 
(6,2,'Battery replacement','2024-03-03','Completed'), 
(8,3,'Wheel alignment','2024-03-05','Completed'), 
(4,2,'Firmware update','2024-03-06','Completed'), 
(2,1,'Battery issue','2024-03-06','In Progress'), 
(5,3,'Loose handle','2024-03-07','Completed'), 
(7,1,'GPS error','2024-03-07','In Progress'), 
(9,2,'Tyre change','2024-03-08','Completed'), 
(10,3,'Brake repair','2024-03-08','Completed'), 
(1,1,'Screen fault','2024-03-09','Completed');

SET FOREIGN_KEY_CHECKS = 1;


SELECT start_city, COUNT(*) AS trip_count
FROM Trips
GROUP BY start_city
ORDER BY trip_count DESC;

SELECT C.membership_type,
AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS avg_minutes
FROM Trips T
JOIN Customers C ON T.customer_id = C.customer_id
GROUP BY membership_type;

SELECT 
    S.full_name, 
    COUNT(M.maintenance_id) AS jobs_completed
FROM Staff S
LEFT JOIN Maintenance M 
    ON S.staff_id = M.staff_id 
    AND M.status = 'Completed'
GROUP BY S.full_name
ORDER BY jobs_completed DESC, S.full_name ASC;


SELECT C.full_name, P.amount
FROM Payments P
JOIN Trips T ON P.trip_id = T.trip_id
JOIN Customers C ON T.customer_id = C.customer_id
WHERE payment_status = 'Pending';


SELECT S.model, COUNT(*) AS usage_count
FROM Trips T
JOIN Scooters S ON T.scooter_id = S.scooter_id
GROUP BY S.model
ORDER BY usage_count DESC;



CREATE TABLE Monthly_Revenue AS 
SELECT  
  DATE_FORMAT(T.start_time, '%Y-%m') AS revenue_month, 
  SUM(P.amount) AS total_revenue, 
  COUNT(*) AS total_trips 
FROM Payments P 
JOIN Trips T ON P.trip_id = T.trip_id 
WHERE P.payment_status = 'Paid' 
GROUP BY revenue_month;

select * from Monthly_Revenue