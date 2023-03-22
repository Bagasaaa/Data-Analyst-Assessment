LOAD DATA INFILE "D:\\Data Career\\Schoters\\dataset\\Customer.csv"
INTO TABLE customers_schoters
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Name, Domisili, Usia, Gender);

SELECT * FROM customers_schoters;

CREATE TABLE marketing_campaign (
  Name VARCHAR(255) NOT NULL,
  Start_Date DATE NOT NULL,
  End_Date DATE NOT NULL,
  Budget VARCHAR(255) NOT NULL
);

SELECT * FROM marketing_campaign;

LOAD DATA INFILE 'D://Data Career//Schoters//dataset//Marketing Campaign.csv'
INTO TABLE marketing_campaign
FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Name, @StartDate, @EndDate, Budget)
SET Start_Date = STR_TO_DATE(@StartDate, '%d/%m/%Y'),
    End_Date = STR_TO_DATE(@EndDate, '%d/%m/%Y');
    
LOAD DATA INFILE 'D://Data Career//Schoters//dataset//Marketing Campaign.csv'
INTO TABLE marketing_campaign
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Name, @Start_Date, @End_Date, Budget)
SET Start_Date = STR_TO_DATE(@Start_Date, '%d/%m/%Y'),
    End_Date = STR_TO_DATE(@End_Date, '%d/%m/%Y');

SELECT * FROM marketing_campaign;

ALTER TABLE marketing_campaign MODIFY COLUMN Start_Date DATE;

CREATE TABLE review_perusahaan (
  Name VARCHAR(255) NOT NULL,
  Rating INT NOT NULL
);

LOAD DATA INFILE "D:\\Data Career\\Schoters\\dataset\\Review Perusahaan.csv"
INTO TABLE review_perusahaan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Name, Rating);

select * from review_perusahaan;

CREATE TABLE transaksi_main_product (
  Tanggal_Transaksi VARCHAR(255) NOT NULL,
  Nama_Sales VARCHAR(255) NOT NULL,
  Harga_Asli VARCHAR(255) NOT NULL,
  Customer VARCHAR(255) NOT NULL,
  Customer_copy VARCHAR(255) NOT NULL,
  Tipe_produk VARCHAR(255) NOT NULL,
  ID_Transaksi INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY(ID_Transaksi)
);

LOAD DATA INFILE "D:\\Data Career\\Schoters\\dataset\\Transaksi Main Product.csv"
INTO TABLE transaksi_main_product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Tanggal_Transaksi,Nama_Sales,Harga_Asli,Customer,Customer_copy,Tipe_Produk,ID_Transaksi);

UPDATE transaksi_main_product SET Harga_Asli = REPLACE(REPLACE(REPLACE(TRIM(Harga_Asli), 'Rp', ''), '.00', ''), ',', '');

ALTER TABLE transaksi_main_product MODIFY Harga_Asli INT;

select * from transaksi_main_product;

CREATE TABLE transaksi_service (
  Tanggal_Service VARCHAR(255) NOT NULL,
  Harga_Service VARCHAR(255) NOT NULL,
  Customer VARCHAR(255) NOT NULL,
  Tipe_Jasa VARCHAR(255) NOT NULL,
  ID int not NULL AUTO_INCREMENT,
  PRIMARY KEY(ID)
);

LOAD DATA INFILE "D:\\Data Career\\Schoters\\dataset\\Transaksi Service.csv"
INTO TABLE transaksi_service
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Tanggal_Service,Harga_Service,Customer,Tipe_Jasa,ID);

select * from transaksi_service;

UPDATE transaksi_service SET Harga_Service = REPLACE(REPLACE(REPLACE(TRIM(Harga_Service), 'Rp', ''), '.00', ''), ',', '');

ALTER TABLE transaksi_service MODIFY Harga_Service INT;

CREATE TABLE review_produk (
  ID_Review INT NOT NULL AUTO_INCREMENT,
  Review INT DEFAULT NULL,
  PRIMARY KEY (ID_Review)
);

LOAD DATA INFILE "D:\\Data Career\\Schoters\\dataset\\Review Produk.csv"
INTO TABLE review_produk
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ID_Review, @Review)
SET Review = NULLIF(@Review, 0);

select * from review_produk;

select * from transaksi_service;

UPDATE marketing_campaign SET Budget = REPLACE(TRIM(Budget), ',', '');

ALTER TABLE marketing_campaign MODIFY Budget INT;

select * from marketing_campaign;

SELECT 
    tm.Customer,
    count(tm.Customer) AS Total_Transaksi,
    SUM(tm.Harga_Asli) AS Total_Harga_Asli
FROM 
    transaksi_main_product tm
GROUP BY 
    tm.Customer
ORDER BY 
    Total_Harga_Asli DESC
LIMIT 5;

SELECT ts.Tanggal_Service, ts.Harga_Service, tm.Harga_Asli, tm.Customer, tm.Customer_copy, tm.Tipe_Produk, tm.ID_Transaksi, ts.Tipe_Jasa, ts.ID
FROM transaksi_service ts
JOIN transaksi_main_product tm
ON ts.Customer = tm.Customer;

ALTER TABLE `marketing_campaign` 
CHANGE COLUMN `Budget` `Budget` INT NOT NULL ;

select * from marketing_campaign;
select * from transaksi_main_product;
select * from transaksi_service;
select * from review_perusahaan;
select * from review_produk;
select * from customers_schoters;


SELECT cs.Domisili, SUM(tm.Harga_Asli) AS Revenue, COUNT(TM.Customer) as Total_Transaksi
FROM customers_schoters cs 
JOIN transaksi_main_product tm
ON cs.Name = tm.Customer 
GROUP BY cs.Domisili
ORDER BY Revenue DESC
LIMIT 5;

select * from transaksi_main_product;
select * from transaksi_service;

SELECT 
    DATE_FORMAT(Tanggal_Transaksi, '%Y-%m') AS Bulan, 
    SUM(Harga_Asli) AS Total_Revenue 
FROM 
    transaksi_main_product 
GROUP BY 
    Bulan 
UNION 
SELECT 
    DATE_FORMAT(Tanggal_Service, '%Y-%m') AS Bulan, 
    SUM(Harga_Service) AS Total_Revenue 
FROM 
    transaksi_service 
GROUP BY 
    Bulan;


select * from transaksi_main_product;
select * from customers_schoters;

SELECT
    tm.Tipe_Produk,
    COUNT(tm.Tipe_Produk) AS Total_Transaksi,
    c.Gender,
    c.Usia
FROM 
    customers_schoters c 
JOIN 
    transaksi_main_product tm ON c.Name = tm.Customer 
WHERE 
    c.Gender = 'Wanita' AND c.Usia BETWEEN 20 AND 29 
GROUP BY 
    tm.Tipe_Produk, c.Gender, c.Usia
ORDER BY 
    Total_Transaksi DESC 
LIMIT 3;

SELECT 
    tm.Tipe_Produk,
    c.Gender,
    c.Usia,
    COUNT(c.Name) AS Total_Transaksi 
FROM 
    customers_schoters c 
JOIN 
    transaksi_main_product tm ON c.Name = tm.Customer 
WHERE 
    c.Gender = 'Wanita' AND c.Usia BETWEEN 20 AND 29 
GROUP BY 
    tm.Tipe_Produk, c.Gender, c.Usia 
ORDER BY 
    Total_Transaksi DESC 
LIMIT 3;

select * from transaksi_main_product;
select * from transaksi_service;
select * from review_perusahaan;

SELECT 
    tm.Customer,
    r.Rating,
    SUM(tm.Harga_Asli) AS Total_Revenue 
FROM 
    transaksi_main_product tm
JOIN review_perusahaan r
ON tm.Customer = r.Name
WHERE r.Rating < 5
GROUP BY tm.Customer, r.Rating
UNION 
SELECT 
    ts.Customer,
    r.Rating,
    SUM(ts.Harga_Service) AS Total_Revenue 
FROM 
    transaksi_service ts
JOIN review_perusahaan r
ON ts.Customer = r.Name
WHERE r.Rating < 5
GROUP BY ts.Customer, r.Rating;

select * from marketing_campaign;
select * from transaksi_main_product;
select * from transaksi_service;
select * from review_perusahaan;
select * from review_produk;
select * from customers_schoters;

SELECT 
    mc.Name AS Campaign, 
    SUM(tm.Harga_Asli) AS Total_Revenue 
FROM 
    marketing_campaign mc
JOIN transaksi_main_product tm
ON DATE_FORMAT(tm.Tanggal_Transaksi, '%Y-%m-%d') = date_format(mc.Start_Date, '%Y-%m-%d')
GROUP BY Campaign
UNION 
SELECT 
    mc.Name AS Campaign, 
    SUM(ts.Harga_Service) AS Total_Revenue 
FROM 
    marketing_campaign mc
JOIN transaksi_service ts
ON DATE_FORMAT(ts.Tanggal_Service, '%Y-%m-%d') = date_format(mc.Start_Date, '%Y-%m-%d')
GROUP BY Campaign;
