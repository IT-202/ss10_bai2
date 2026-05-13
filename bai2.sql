CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE InsertPatients()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 500000 DO

        INSERT INTO Patients(FullName, Phone, Address)
        VALUES (
            CONCAT('Patient ', i),
            CONCAT('09', FLOOR(10000000 + RAND() * 89999999)),
            CONCAT('Address ', i)
        );

        SET i = i + 1;

    END WHILE;
END $$

DELIMITER ;

CALL InsertPatients();

SELECT * 
FROM Patients
WHERE Phone = '0912345678';

EXPLAIN
SELECT * 
FROM Patients
WHERE Phone = '0912345678';

CREATE INDEX idx_phone
ON Patients(Phone);

SELECT * 
FROM Patients
WHERE Phone = '0912345678';

EXPLAIN
SELECT * 
FROM Patients
WHERE Phone = '0912345678';

DROP INDEX idx_phone
ON Patients;

DELIMITER $$

CREATE PROCEDURE Insert1000_NoIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients(FullName, Phone, Address)
        VALUES (
            CONCAT('New Patient ', i),
            CONCAT('09', FLOOR(10000000 + RAND() * 89999999)),
            'Test Address'
        );

        SET i = i + 1;

    END WHILE;
END $$

DELIMITER ;

CALL Insert1000_NoIndex();

CREATE INDEX idx_phone
ON Patients(Phone);

DELIMITER $$

CREATE PROCEDURE Insert1000_WithIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients(FullName, Phone, Address)
        VALUES (
            CONCAT('New Patient ', i),
            CONCAT('09', FLOOR(10000000 + RAND() * 89999999)),
            'Test Address'
        );

        SET i = i + 1;

    END WHILE;
END $$

DELIMITER ;

CALL Insert1000_WithIndex();


/*
NHẬN XÉT:

- Khi chưa có INDEX:
  + SELECT chậm vì quét toàn bộ bảng.
  + INSERT nhanh hơn.

- Khi có INDEX:
  + SELECT nhanh hơn rất nhiều.
  + INSERT chậm hơn một chút vì phải cập nhật INDEX.

KẾT LUẬN:
Nên tạo INDEX cho cột Phone trong hệ thống bệnh viện để tăng tốc độ tra cứu bệnh nhân.
*/