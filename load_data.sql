LOAD DATA LOCAL INFILE "./data/Eligibility table.txt" INTO TABLE eligibility
	IGNORE 1 LINES
(member_id, name, @start_date, @end_date)
SET start_date = STR_TO_DATE(@start_date,'%m/%d/%y'), end_date = STR_TO_DATE(@end_date,'%m/%d/%y');

LOAD DATA LOCAL INFILE "./data/HEDIS table.txt" INTO TABLE hedis
	IGNORE 1 LINES
	(member_id, hedis_measure, @date_of_service, result)
SET date_of_service = STR_TO_DATE(@date_of_service, '%m/%d/%y');

LOAD DATA LOCAL INFILE "./data/Claims table.txt" INTO TABLE claims 
	IGNORE 1 LINES
	(member_id, hedis_measure, procedure_code, @date_of_service)
SET date_of_service = STR_TO_DATE(@date_of_service, '%m/%d/%y');