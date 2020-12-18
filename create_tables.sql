CREATE TABLE IF NOT EXISTS eligibility (
	member_id INT, name VARCHAR(255), 
	start_date DATE, end_date DATE
);
CREATE TABLE IF NOT EXISTS HEDIS (
	member_id INT, 
	hedis_measure ENUM('A1C', 'BMI', 'COL', 'BCS'),
	date_of_service date,
	result DECIMAL(10,1)
);
CREATE TABLE IF NOT EXISTS claims (
	member_id INT,
	hedis_measure ENUM('A1C', 'AWV', 'COL', 'BCS'),
	procedure_code INT,
	date_of_service date
);