-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for view gymdataset.adultmalemembers
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `adultmalemembers` (
	`member_id` INT(10) NOT NULL,
	`name` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date_of_birth` DATE NULL,
	`gender` VARCHAR(50) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`contact` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for table gymdataset.classes
CREATE TABLE IF NOT EXISTS `classes` (
  `class_id` int NOT NULL,
  `class_name` varchar(255) DEFAULT NULL,
  `instructor_id` int DEFAULT NULL,
  `schedule` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`class_id`),
  KEY `instructor_id` (`instructor_id`),
  KEY `idx_class_name_schedule` (`class_name`,`schedule`),
  CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.classes: ~5 rows (approximately)
INSERT INTO `classes` (`class_id`, `class_name`, `instructor_id`, `schedule`) VALUES
	(1, 'Kelas Yoga Pagi', 1, 'Senin 07:00 - 08:30'),
	(2, 'Kelas Aerobik Sore', 2, 'Selasa 17:00 - 18:30'),
	(3, 'Kelas Zumba Malam', 3, 'Rabu 19:00 - 20:30'),
	(4, 'Kelas Pilates Siang', 4, 'Kamis 12:00 - 13:30'),
	(5, 'Kelas Boxing Pagi', 5, 'Jumat 07:00 - 08:30');

-- Dumping structure for table gymdataset.enrollments
CREATE TABLE IF NOT EXISTS `enrollments` (
  `enrollment_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  KEY `member_id` (`member_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.enrollments: ~5 rows (approximately)
INSERT INTO `enrollments` (`enrollment_id`, `member_id`, `class_id`, `enrollment_date`) VALUES
	(1, 1, 1, '2024-01-01'),
	(2, 2, 2, '2024-01-02'),
	(3, 3, 3, '2024-01-03'),
	(4, 4, 4, '2024-01-04'),
	(5, 5, 5, '2024-01-05');

-- Dumping structure for procedure gymdataset.GetAllMembers
DELIMITER //
CREATE PROCEDURE `GetAllMembers`()
BEGIN
    SELECT * FROM Members;
END//
DELIMITER ;

-- Dumping structure for procedure gymdataset.GetClassDetailsByInstructorAndSchedule
DELIMITER //
CREATE PROCEDURE `GetClassDetailsByInstructorAndSchedule`(
    IN instructor INT,
    IN class_schedule VARCHAR(255)
)
BEGIN
    SELECT * FROM Classes
    WHERE instructor_id = instructor
      AND schedule = class_schedule;
END//
DELIMITER ;

-- Dumping structure for function gymdataset.GetInstructorName
DELIMITER //
CREATE FUNCTION `GetInstructorName`(instructorID INT) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE instructorName VARCHAR(255);

    SELECT name INTO instructorName
    FROM Instructors
    WHERE instructor_id = instructorID;

    RETURN instructorName;
END//
DELIMITER ;

-- Dumping structure for function gymdataset.GetTotalEnrollmentsByMemberAndDate
DELIMITER //
CREATE FUNCTION `GetTotalEnrollmentsByMemberAndDate`(
    MemberID INT,
    StartDate DATE
) RETURNS int
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE totalEnrollments INT;

    SELECT COUNT(*)
    INTO totalEnrollments
    FROM Enrollments e
    WHERE e.member_id = MemberID
      AND e.enrollment_date >= StartDate;

    RETURN totalEnrollments;
END//
DELIMITER ;

-- Dumping structure for table gymdataset.instructors
CREATE TABLE IF NOT EXISTS `instructors` (
  `instructor_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`instructor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.instructors: ~5 rows (approximately)
INSERT INTO `instructors` (`instructor_id`, `name`, `specialty`, `contact`) VALUES
	(1, 'Budi Santoso', 'Yoga', '081234567890'),
	(2, 'Siti Aminah', 'Aerobik', '081345678901'),
	(3, 'Agus Wijaya', 'Zumba', '081456789012'),
	(4, 'Rina Wati', 'Pilates', '081567890123'),
	(5, 'Dono Prasetyo', 'Boxing', '081678901234');

-- Dumping structure for table gymdataset.instructorswithindex
CREATE TABLE IF NOT EXISTS `instructorswithindex` (
  `instructor_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `specialty` varchar(255) NOT NULL,
  `contact` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`instructor_id`,`specialty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.instructorswithindex: ~0 rows (approximately)

-- Dumping structure for procedure gymdataset.ListAllMembers
DELIMITER //
CREATE PROCEDURE `ListAllMembers`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE m_id INT;
    DECLARE m_name VARCHAR(255);
    DECLARE m_date_of_birth DATE;
    DECLARE m_gender VARCHAR(50);
    DECLARE m_contact VARCHAR(255);
    
    DECLARE member_cursor CURSOR FOR
        SELECT member_id, name, date_of_birth, gender, contact
        FROM Members;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN member_cursor;
    
    read_loop: LOOP
        FETCH member_cursor INTO m_id, m_name, m_date_of_birth, m_gender, m_contact;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Here you would output the details, for simplicity we use SELECT
        SELECT m_id, m_name, m_date_of_birth, m_gender, m_contact;
    END LOOP;
    
    CLOSE member_cursor;
END//
DELIMITER ;

-- Dumping structure for table gymdataset.logtable
CREATE TABLE IF NOT EXISTS `logtable` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `log_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `event_type` varchar(50) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `old_data` text,
  `new_data` text,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.logtable: ~0 rows (approximately)
INSERT INTO `logtable` (`log_id`, `log_date`, `event_type`, `table_name`, `old_data`, `new_data`) VALUES
	(1, '2024-07-15 13:08:22', 'BEFORE INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Joko Pambudi'),
	(2, '2024-07-15 13:08:22', 'AFTER INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Joko Pambudi'),
	(3, '2024-07-15 13:08:22', 'BEFORE INSERT', 'Members', NULL, 'Member ID Baru: 7, Nama: Trisno Eko Wibowo'),
	(4, '2024-07-15 13:08:22', 'AFTER INSERT', 'Members', NULL, 'Member ID Baru: 7, Nama: Trisno Eko Wibowo'),
	(5, '2024-07-15 13:14:03', 'BEFORE UPDATE', 'Members', 'Member ID Lama: 1, Nama: Slamet Riyadi', 'Member ID Baru: 1, Nama: Johnathan Andi'),
	(6, '2024-07-15 13:14:03', 'AFTER UPDATE', 'Members', 'Member ID Lama: 1, Nama: Slamet Riyadi', 'Member ID Baru: 1, Nama: Johnathan Andi'),
	(7, '2024-07-15 13:14:03', 'BEFORE UPDATE', 'Members', 'Member ID Lama: 2, Nama: Sri Wahyuni', 'Member ID Baru: 2, Nama: Janet Budiono'),
	(8, '2024-07-15 13:14:03', 'AFTER UPDATE', 'Members', 'Member ID Lama: 2, Nama: Sri Wahyuni', 'Member ID Baru: 2, Nama: Janet Budiono'),
	(9, '2024-07-15 22:26:12', 'BEFORE DELETE', 'Members', 'Member ID Lama: 6, Nama: Joko Pambudi', NULL),
	(10, '2024-07-15 22:26:12', 'AFTER DELETE', 'Members', 'Member ID Lama: 6, Nama: Joko Pambudi', NULL),
	(11, '2024-07-15 22:26:12', 'BEFORE DELETE', 'Members', 'Member ID Lama: 7, Nama: Trisno Eko Wibowo', NULL),
	(12, '2024-07-15 22:26:12', 'AFTER DELETE', 'Members', 'Member ID Lama: 7, Nama: Trisno Eko Wibowo', NULL),
	(13, '2024-07-16 01:03:25', 'BEFORE INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Agung Reza'),
	(14, '2024-07-16 01:03:25', 'AFTER INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Agung Reza'),
	(15, '2024-07-16 01:07:09', 'BEFORE DELETE', 'Members', 'Member ID Lama: 6, Nama: Agung Reza', NULL),
	(16, '2024-07-16 01:07:09', 'AFTER DELETE', 'Members', 'Member ID Lama: 6, Nama: Agung Reza', NULL),
	(17, '2024-07-16 01:07:14', 'BEFORE INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Agung Reza'),
	(18, '2024-07-16 01:07:14', 'AFTER INSERT', 'Members', NULL, 'Member ID Baru: 6, Nama: Agung Reza'),
	(19, '2024-07-16 01:08:57', 'BEFORE UPDATE', 'Members', 'Member ID Lama: 6, Nama: Agung Reza', 'Member ID Baru: 6, Nama: Agung Reza'),
	(20, '2024-07-16 01:08:57', 'AFTER UPDATE', 'Members', 'Member ID Lama: 6, Nama: Agung Reza', 'Member ID Baru: 6, Nama: Agung Reza');

-- Dumping structure for view gymdataset.membercontacts
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `membercontacts` (
	`name` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`contact` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for table gymdataset.members
CREATE TABLE IF NOT EXISTS `members` (
  `member_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  KEY `idx_member_name_contact` (`name`,`contact`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.members: ~5 rows (approximately)
INSERT INTO `members` (`member_id`, `name`, `date_of_birth`, `gender`, `contact`) VALUES
	(1, 'Johnathan Andi', '1990-01-15', 'Laki-laki', '0889097768'),
	(2, 'Janet Budiono', '1985-03-22', 'Perempuan', '08123499089'),
	(3, 'Dwi Prasetyo', '1992-07-10', 'Laki-laki', '081789012345'),
	(4, 'Tuti Hartono', '1994-05-25', 'Perempuan', '081890123456'),
	(5, 'Heri Susanto', '1988-11-30', 'Laki-laki', '081901234567'),
	(6, 'Agung Reza', '1995-03-10', 'Laki-laki', '081353444676');

-- Dumping structure for table gymdataset.membershipdetails
CREATE TABLE IF NOT EXISTS `membershipdetails` (
  `membership_detail_id` int NOT NULL,
  `membership_type` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `duration` int DEFAULT NULL,
  PRIMARY KEY (`membership_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.membershipdetails: ~5 rows (approximately)
INSERT INTO `membershipdetails` (`membership_detail_id`, `membership_type`, `price`, `duration`) VALUES
	(1, 'Bulanan', 150000.00, 1),
	(2, 'Triwulan', 400000.00, 3),
	(3, 'Tahunan', 1500000.00, 12),
	(4, 'Mingguan', 50000.00, 0),
	(5, 'Harian', 10000.00, 0);

-- Dumping structure for table gymdataset.memberships
CREATE TABLE IF NOT EXISTS `memberships` (
  `membership_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `membership_detail_id` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`membership_id`),
  KEY `member_id` (`member_id`),
  KEY `membership_detail_id` (`membership_detail_id`),
  CONSTRAINT `memberships_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `memberships_ibfk_2` FOREIGN KEY (`membership_detail_id`) REFERENCES `membershipdetails` (`membership_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.memberships: ~5 rows (approximately)
INSERT INTO `memberships` (`membership_id`, `member_id`, `membership_detail_id`, `start_date`, `end_date`) VALUES
	(1, 1, 1, '2024-01-01', '2024-01-31'),
	(2, 2, 2, '2024-01-01', '2024-03-31'),
	(3, 3, 3, '2024-01-01', '2024-12-31'),
	(4, 4, 4, '2024-01-01', '2024-01-07'),
	(5, 5, 5, '2024-01-01', '2024-01-01');

-- Dumping structure for view gymdataset.memberslakilaki
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `memberslakilaki` (
	`member_id` INT(10) NOT NULL,
	`name` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date_of_birth` DATE NULL,
	`gender` VARCHAR(50) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`contact` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for table gymdataset.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `member_id` (`member_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table gymdataset.payments: ~5 rows (approximately)
INSERT INTO `payments` (`payment_id`, `member_id`, `class_id`, `payment_date`) VALUES
	(1, 1, 1, '2024-01-01'),
	(2, 2, 2, '2024-01-02'),
	(3, 3, 3, '2024-01-03'),
	(4, 4, 4, '2024-01-04'),
	(5, 5, 5, '2024-01-05');

-- Dumping structure for trigger gymdataset.after_delete_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `after_delete_members` AFTER DELETE ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, old_data)
    VALUES ('AFTER DELETE', 'Members', CONCAT('Member ID Lama: ', OLD.member_id, ', Nama: ', OLD.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gymdataset.after_insert_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `after_insert_members` AFTER INSERT ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, new_data)
    VALUES ('AFTER INSERT', 'Members', CONCAT('Member ID Baru: ', NEW.member_id, ', Nama: ', NEW.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gymdataset.after_update_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `after_update_members` AFTER UPDATE ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, old_data, new_data)
    VALUES ('AFTER UPDATE', 'Members', CONCAT('Member ID Lama: ', OLD.member_id, ', Nama: ', OLD.name), CONCAT('Member ID Baru: ', NEW.member_id, ', Nama: ', NEW.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gymdataset.before_delete_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_delete_members` BEFORE DELETE ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, old_data)
    VALUES ('BEFORE DELETE', 'Members', CONCAT('Member ID Lama: ', OLD.member_id, ', Nama: ', OLD.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gymdataset.before_insert_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_members` BEFORE INSERT ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, new_data)
    VALUES ('BEFORE INSERT', 'Members', CONCAT('Member ID Baru: ', NEW.member_id, ', Nama: ', NEW.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gymdataset.before_update_members
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_update_members` BEFORE UPDATE ON `members` FOR EACH ROW BEGIN
    INSERT INTO LogTable (event_type, table_name, old_data, new_data)
    VALUES ('BEFORE UPDATE', 'Members', CONCAT('Member ID Lama: ', OLD.member_id, ', Nama: ', OLD.name), CONCAT('Member ID Baru: ', NEW.member_id, ', Nama: ', NEW.name));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for view gymdataset.adultmalemembers
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `adultmalemembers`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `adultmalemembers` AS select `memberslakilaki`.`member_id` AS `member_id`,`memberslakilaki`.`name` AS `name`,`memberslakilaki`.`date_of_birth` AS `date_of_birth`,`memberslakilaki`.`gender` AS `gender`,`memberslakilaki`.`contact` AS `contact` from `memberslakilaki` where ((year(curdate()) - year(`memberslakilaki`.`date_of_birth`)) >= 18) WITH CASCADED CHECK OPTION;

-- Dumping structure for view gymdataset.membercontacts
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `membercontacts`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `membercontacts` AS select `members`.`name` AS `name`,`members`.`contact` AS `contact` from `members`;

-- Dumping structure for view gymdataset.memberslakilaki
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `memberslakilaki`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `memberslakilaki` AS select `members`.`member_id` AS `member_id`,`members`.`name` AS `name`,`members`.`date_of_birth` AS `date_of_birth`,`members`.`gender` AS `gender`,`members`.`contact` AS `contact` from `members` where (`members`.`gender` = 'Laki-laki');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
