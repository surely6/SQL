CREATE DATABASE Food_Ordering;
USE Food_Ordering;

CREATE TABLE Chef(
ChefID varchar(50) PRIMARY KEY,
ChefName varchar(50) NOT NULL);

CREATE TABLE DispatchWorker( 
DispatchWorkerID varchar(50) PRIMARY KEY,
DispatchWorkerName varchar(50) NOT NULL);

CREATE TABLE Member(
MemberID varchar(50) PRIMARY KEY,
MemberName varchar(50) NOT NULL,
Gender varchar(7) 
CHECK (Gender IN ('Male', 'Female')) NOT NULL,
ContactNum varchar(20) NOT NULL,
Role varchar(50) 
CHECK (Role IN ('Student', 'Staff')) NOT NULL);

CREATE TABLE Food(
FoodID varchar(50) PRIMARY KEY,
FoodName varchar(50) NOT NULL,
FoodPrice decimal(10,2) 
CHECK (FoodPrice > 0) NOT NULL);

CREATE TABLE OrderList(
OrderNum varchar (50) PRIMARY KEY,
Date date NOT NULL, 
PaymentMethod varchar(50) NOT NULL,
OrderReceivedTime time NOT NULL,
OrderDeliveredTime time,
OrderStatus varchar(50) 
CHECK (OrderStatus IN ('Delivered', 'Delivering', 'Ready To Pickup', 'Paid', 'Ordered')) NOT NULL, 
MemberID varchar (50) 
FOREIGN KEY REFERENCES Member(MemberID) NOT NULL,
DispatchWorkerID varchar (50) 
FOREIGN KEY REFERENCES DispatchWorker(DispatchWorkerID));

CREATE TABLE OrderFood(
OrderNum varchar(50) FOREIGN KEY REFERENCES OrderList(OrderNum),
FoodID varchar(50) FOREIGN KEY REFERENCES Food(FoodID)NOT NULL,
OrderItemQuantity int 
CHECK (OrderItemQuantity > 0) NOT NULL, 
ChefID varchar(50) FOREIGN KEY REFERENCES Chef(ChefID) NOT NULL,
FoodStatus varchar(50)
CHECK (FoodStatus IN ('Prepared', 'New')) NOT NULL,
Rating int 
CHECK (Rating > 0 AND Rating < 6 ),
PRIMARY KEY (OrderNum,FoodID));

INSERT INTO Chef
VALUES ('C01', 'John'),
('C02', 'Aiden'),
('C03', 'Jessica');

INSERT INTO DispatchWorker 
VALUES ('D01', 'Issac'),
('D02', 'Rohny'),
('D03', 'Michelle');

INSERT INTO Food
VALUES ('F01', 'Fried Rice', 7),
('F02', 'Fried Noodle' , 7),
('F03', 'Nasi Lemak', 8),
('F04', 'Pizza', 10.5),
('F05', 'Burger', 9),
('F06', 'Milo', 1.5),
('F07', 'Kopi O', 1.8),
('F08', 'Teh Tarik', 1.8),
('F09', 'Sprite', 2),
('F10', 'Watermelon Juice', 5);

INSERT INTO Member 
VALUES ('M01', 'Evelyn', 'Female', '60102313241', 'Staff'),
('M02', 'Ella', 'Female', '60122332323', 'Staff'),
('M03', 'Albert', 'Male', '60162262266', 'Student'),
('M04', 'Alex', 'Male', '60125556262', 'Staff'),
('M05', 'Thomas', 'Male', '60188865493', 'Student'),
('M06', 'Henry', 'Male', '60136899898', 'Staff'),
('M07', 'Alice', 'Female', '60179763535', 'Student'),
('M08', 'Floryn', 'Female', '60163395678', 'Student');

INSERT INTO OrderList 
VALUES ('O01', '2024-02-21', 'Cash', '14:50:23', '14:58:31', 'Delivered', 'M01', 'D01'), 
('O02', '2024-02-22', 'APCard', '10:05:11', '10:09:15', 'Delivered', 'M05', 'D02'), 
('O03', '2024-02-23', 'APCard', '12:34:56', '12:48:01', 'Delivered', 'M03', 'D01'), 
('O04', '2024-02-23', 'APCard', '19:11:42', '19:22:16', 'Delivered', 'M06', 'D03'), 
('O05', '2024-02-24', 'Cash', '09:25:34', '09:39:53', 'Delivered', 'M02', 'D03'), 
('O06', '2024-02-24', 'APCard', '11:56:59', NULL, 'Delivering', 'M07', 'D02'), 
('O07', '2024-02-24', 'APCard', '12:43:40', NULL, 'Delivering', 'M08', 'D01'), 
('O08', '2024-02-24', 'APCard', '12:57:35', NULL, 'Ready To Pickup', 'M04', 'D02'), 
('O09', '2024-02-24', 'APCard', '13:02:09', NULL, 'Ready To Pickup', 'M01', 'D03'), 
('O10', '2024-02-24', 'Cash', '13:14:05', NULL, 'Paid', 'M05', NULL), 
('O11', '2024-02-24', 'APCard', '16:33:00', NULL, 'Ordered', 'M01', NULL);

INSERT INTO OrderFood
VALUES ('O01', 'F05', 1, 'C01', 'Prepared', 5),
('O01', 'F10', 1, 'C02', 'Prepared', 4),
('O02', 'F04', 1, 'C03', 'Prepared', 5),
('O03', 'F08', 3, 'C02', 'Prepared', 2),
('O04', 'F03', 2, 'C01', 'Prepared', 4),
('O05', 'F02', 2, 'C03', 'Prepared', 1),
('O05', 'F01', 1, 'C01', 'Prepared', 3),
('O05', 'F06', 3, 'C02', 'Prepared', 4),
('O06', 'F01', 1, 'C01', 'Prepared', 2),
('O06', 'F07', 1, 'C02', 'Prepared', 5),
('O07', 'F09', 5, 'C02', 'Prepared', 3),
('O08', 'F05', 1, 'C03', 'Prepared', 4),
('O08', 'F03', 2, 'C01', 'Prepared', 3),
('O09', 'F06', 3, 'C02', 'Prepared', 5),
('O10', 'F08', 4, 'C02', 'Prepared', NULL),
('O10', 'F10', 1, 'C02', 'New', NULL),
('O10', 'F04', 4, 'C03', 'New', NULL),
('O11', 'F05', 2, 'C01', 'New', NULL);

--DML--
--1--
--List the food(s) which has the highest rating. Show food id, food name and the rating--
SELECT Food.FoodID, Food.FoodName, ROUND(AVG(CAST(Rating AS FLOAT)), 2) AS HighestRating FROM Food
JOIN OrderFood ON Food.FoodID = OrderFood.FoodID
WHERE Rating IS NOT NULL
GROUP BY Food.FoodID, Food.FoodName
HAVING ROUND(AVG(CAST(Rating AS FLOAT)), 2) = (SELECT MAX(AvgRating) FROM (SELECT AVG(Rating) AS AvgRating FROM OrderFood WHERE Rating IS NOT NULL GROUP BY FoodID) AS MaxRatingColumn);

--2--
--Find the total number of feedback per member. Show member id, member name and total number of feedback per member--
SELECT Member.MemberID, Member.MemberName, COUNT(OrderFood.Rating) AS TotalFeedback
FROM Member
JOIN OrderList ON Member.MemberID = OrderList.MemberID
JOIN OrderFood ON OrderList.OrderNum = OrderFood.OrderNum
WHERE Rating IS NOT NULL
GROUP BY Member.MemberID, MemberName;

--3--
--Find the total number of food(meal) ordered by manager from each chef--
SELECT Chef.ChefID, Chef.ChefName, COUNT (OrderFood.FoodID) AS TotalFoodCooked
FROM Chef
INNER JOIN OrderFood ON Chef.ChefID = OrderFood.ChefID
INNER JOIN OrderList ON OrderFood.OrderNum = OrderList.OrderNum
GROUP BY Chef.ChefID, Chef.ChefName;

SELECT c.ChefID, ChefName, SUM(OrderItemQUANTITY) AS NumberOdMealsAssigned 
FROM Chef c
LEFT JOIN OrderFood Orf ON c.ChefID = Orf.ChefID 
GROUP BY c.ChefID, ChefName;

--4--
--Find the total number of food(meal) cooked by each chef. Show chef id, chef name, and number of meals cooked--
SELECT c.ChefID, ChefName, SUM(OrderItemQuantity) AS NumberOfMealsCooked
FROM Chef c, OrderFood Orf
WHERE c.ChefID = Orf.ChefID AND FoodStatus = 'Prepared'
GROUP BY c.ChefID, ChefName;

--5--
--List all the food where its average rating is more than the average rating of all food--
SELECT Food.FoodID, FoodName, ROUND(AVG(CAST(Rating AS FLOAT)),2) AS AverageRating FROM OrderFood
JOIN Food ON OrderFood.FoodID = Food.FoodID
WHERE Rating IS NOT NULL
GROUP BY Food.FoodID, FoodName
HAVING ROUND(AVG(CAST(Rating AS FLOAT)),2) > (SELECT ROUND(AVG(CAST(Rating AS FLOAT)),2) FROM OrderFood);

--6--
--Find the top 3 bestselling food(s). The list should include id, name, price and quantity sold--
SELECT TOP 3 SUM (OrderFood.OrderItemQuantity) AS QuantitySold, Food.FoodID, Food.FoodName, Food.FoodPrice
FROM OrderFood
JOIN Food ON OrderFood.FoodID = Food.FoodID
GROUP BY Food.FoodID, Food.FoodName, Food.FoodPrice
ORDER BY SUM(OrderFood.OrderItemQuantity) DESC;

--7--
--Show the top 3 members who spent most on ordering food. List should include id and name and whether they student or staff--
SELECT TOP 3 Member.MemberID, MemberName, Role, SUM(OrderItemQuantity * FoodPrice) AS TotalSpending FROM Member
JOIN OrderList ON Member.MemberID = OrderList.MemberID
JOIN OrderFood ON OrderList.OrderNum = OrderFood.OrderNum
JOIN Food ON OrderFood.FoodID = Food.FoodID
GROUP BY Member.MemberID, Member.MemberName, Role
ORDER BY TotalSpending DESC;

--8--
--Show the total members based on gender who are registered as members. List should include id, name, role(student/staff) and gender--
SELECT Gender, COUNT(Gender) AS TotalMember FROM Member
GROUP BY Gender
SELECT MemberID, MemberName, Gender, Role FROM Member

--9--
--Show a list of ordered food which has not been delivered to members. The list should show member id, role(student/staff), contact number, food id, food name, quantity, date, and status of delivery--
SELECT OrderList.OrderNum AS OrderList, Member.MemberID, Member.Role, Member.ContactNum, Food.FoodID, Food.FoodName, OrderFood.OrderItemQuantity, OrderList.Date, OrderList.OrderStatus
FROM OrderList
JOIN OrderFood ON OrderList.OrderNum = OrderFood.OrderNum
JOIN Member ON OrderList.MemberID = Member.MemberID
JOIN Food ON OrderFood.FoodID = Food.FoodID
WHERE NOT OrderStatus='Delivered'
ORDER BY OrderList.OrderNum;

--10--
--Show a list of members who made more than 2 orders. The list should show their member id, name, and role(student/staff) and total orders--
SELECT OrderList.MemberID, COUNT(OrderList.MemberID) AS NumberOfOrders, Member.MemberName, Member.Gender, Member.ContactNum
FROM OrderList INNER JOIN Member ON OrderList.MemberID = Member.MemberID
GROUP BY OrderList.MemberID, Member.MemberName, Member.Gender, Member.ContactNum
HAVING COUNT (OrderList.MemberID)>2;

--TEST CASE--
--3--
--Can view the menu (the list of food and drinks offered their price) --
SELECT Food.FoodID, FoodName, FoodPrice, ROUND(AVG(CAST(Rating AS FLOAT)), 2) AS AverageRating FROM Food
JOIN OrderFood ON Food.FoodID = OrderFood.FoodID WHERE OrderFood.Rating IS NOT NULL
GROUP BY Food.FoodID, FoodName, FoodPrice;

--4--
--Can read reviews --
SELECT OrderFood.Rating, OrderFood.OrderNum, OrderFood.FoodID, OrderList.MemberID FROM OrderList
INNER JOIN OrderFood ON OrderFood.OrderNum = OrderList.OrderNum
WHERE Rating IS NOT NULL ORDER BY OrderList.MemberID;

--5--
--Can order with multiple food and/or drinks. After order, the order status = ¡°Ordered¡±--
UPDATE OrderList
SET OrderStatus = 'Ordered'
WHERE OrderNum = 'O01';

--6--
--Can see summary for an order and total money to be paid--
SELECT OrderList.OrderNum, OrderList.Date, OrderList.PaymentMethod,
SUM(Food.FoodPrice * OrderFood.OrderItemQuantity) AS TotalAmount
FROM OrderList
INNER JOIN OrderFood ON OrderList.OrderNum = OrderFood.OrderNum
INNER JOIN Food ON OrderFood.FoodID = Food.FoodID
WHERE OrderList.OrderNum = 'O10'
GROUP BY OrderList.OrderNum, OrderList.Date, OrderList.PaymentMethod;

--7--
--Can update payment status. After pay, the order status = ¡°Paid¡±--
UPDATE OrderList
SET PaymentMethod = 'APCard', OrderStatus = 'Paid'
WHERE OrderNum = 'O11';

--8--
--Manager assigns the chef to cook each food/drink and update the food/drink status = ¡°New¡± --
UPDATE OrderFood
SET ChefID = 'C02', FoodStatus = 'New'
WHERE OrderNum = 'O10' AND FoodID = 'F08';
USE Food_Ordering
SELECT * FROM OrderFood

--9--
--Chef cook/prepare and update the food/drink status = ¡°Prepared¡±--
UPDATE OrderFood
SET FoodStatus = 'Prepared'
WHERE OrderNum = 'O11' AND FoodID = 'F05';

--10--
--When all food in the order is cooked, the order status = ¡°Ready To Pickup¡± and dispatch worker is assigned to it --
UPDATE OrderList
SET OrderStatus = 'Ready To Pickup', DispatchWorkerID = 'D01'
WHERE OrderNum = 'O10'

--11--
--Dispatch worker picks up all food/drinks in the order and update order status = ¡°Delivering¡± --
UPDATE OrderList
SET OrderStatus = 'Delivering'
WHERE OrderNum = 'O09'

--12--
--Dispatch worker completed delivery and update order status = ¡°Delivered¡± --
UPDATE OrderList
SET OrderStatus = 'Delivered'
WHERE OrderNum = 'O07'

--13--
--Customer can add review for each food/drink they order --
UPDATE OrderFood
SET Rating = 5
WHERE OrderNum = 'O11' AND FoodID = 'F05'