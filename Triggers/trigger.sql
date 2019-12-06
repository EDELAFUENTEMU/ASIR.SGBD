DELIMITER $$
DROP PROCEDURE IF EXISTS `PROCEDIMIENTO1` $$
CREATE DEFINER=`server`@`%` PROCEDURE `PROCEDIMIENTO1`(IN `parametro` BIGINT)
BEGIN 
    SET @contador = parametro;
    SET @resultado = 1;
        
    WHILE (@contador > 0) DO
	           
		IF (@contador > 15 && (@contador%3 = 0 || @contador%5 = 0))
		THEN
			SET @resultado =  @resultado*(@contador-15);
		ELSEIF (@contador > 5 && @contador%2 = 0)
		THEN 
			SET @resultado =  @resultado*(@contador-5);
		ELSE
			SET @resultado =  @resultado*@contador;
		END IF;
		
        SET @contador = @contador - 1;
    END WHILE;
    SELECT @resultado;
END$$
DELIMITER ;

/* SEGUNDO EJERCICIO */
DELIMITER $$
DROP FUNCTION IF EXISTS fMBeneficio $$
CREATE FUNCTION fMBeneficio (parametro VARCHAR(20)) RETURNS INT 
BEGIN 
    SET @resultado = 0;  
    SET parametro = CONCAT("%",parametro,"%");
    SET @resultado = (SELECT AVG(beneficio) FROM hoteles WHERE hotel LIKE parametro);
	RETURN @resultado; 
END$$

DROP PROCEDURE IF EXISTS pMBeneficio $$
CREATE PROCEDURE pMBeneficio (IN parametro VARCHAR(20))
BEGIN 
   SELECT fMBeneficio(parametro) AS BENEFICIO;
END$$
DELIMITER ;


/* TERCER EJERCICIO */
DELIMITER $$
DROP TRIGGER IF EXISTS tBenHabit $$
CREATE TRIGGER `tBenHabit` BEFORE INSERT ON `hoteles`
FOR EACH ROW BEGIN
	SET new.benHab = (new.beneficio/new.habitaciones);
END $$
DELIMITER ;


/* CUARTO EJERCICIO */
DELIMITER $$
DROP TRIGGER IF EXISTS tBen10 $$
CREATE TRIGGER tBen10 BEFORE UPDATE 
ON `hoteles`
FOR EACH ROW BEGIN
   IF(OLD.hotel LIKE '%NUEVO%')
   THEN
	 SET new.beneficio = new.beneficio+new.beneficio/10;
   END IF;
END $$


/*  QUINTO EJERCICIO */
DELIMITER $$
DROP PROCEDURE IF EXISTS pMayorQue $$
CREATE PROCEDURE pMayorQue (IN campo VARCHAR(20), IN valor INT)
BEGIN 
   SET @stn = CONCAT('SELECT * FROM hoteles  WHERE ',campo,' > ',valor);
   PREPARE stmt FROM @stn;
   EXECUTE stmt;
END$$