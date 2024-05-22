DELIMITER //

CREATE PROCEDURE BackupDatabase()
BEGIN
    SET @dbBackup := CONCAT('mysqldump -u root -p  your_database_name > /path/to/backup/', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), '_your_database_name.sql');
    PREPARE stmt FROM @dbBackup;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE RestoreDatabase(IN backupFilePath VARCHAR(255))
BEGIN
    SET @dbRestore := CONCAT('mysql -u your_username -pyour_password your_database_name < ', backupFilePath);
    PREPARE stmt FROM @dbRestore;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;