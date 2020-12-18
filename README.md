# Aspire Health Plan SQL assesment 

## Reproduce database
Run the following scripts in your mysql server
1) create_tables.sql - This creates the 3 tables (eligibility, claims, hedis) necessary for analysis. Make sure you have a database selected before running!
2) load_data.sql - This loads the text files in the /data directory into the proper tables.

# Solutions to Instructions.txt

# Section 1
## 1) What clarifications would you need before starting this process?
* Which dialect of SQL I should be using (I assumed mysql)
* Format of the text files (seperated by spaces, tabs, commas ect)
* More metadata would be helpful (what the tables are representing, all the enumerations of the HEDIS measure, what number type the 'result' value should be, ect.)

## 2) Load the attached data files into database tables:
* Identify the errors that you found with the data while loading the data.
  - First line is column definitions, not a row in the table
  - Date formats were not correct
  - Some columns are seperated by two tabs instead of 1 (not entirely sure if this is just the format of the txt file, or my computer is reading it wrong).
* Describe the process you would follow if errors are found.
  - For first line, use IGNORE 1 LINE clause
  - For date formats, used TEXT_TO_STRING function in loading file.
  - For tabs, replace all instances of 2 tabs with one (many ways to do this, easy way here is manually but there are other ways i.e. with linux shell, sed is a popular option). 

## 3) Proceed with your own assumptions to create the SQL statement that provides a query that returns the most current activity for each measure (A1C, BMI, COL, BSC) for active members. Each row in the result represents an active member without duplication.
  - Member Id
  - Member Name
  - A1c DOS
  - A1c Result
  - BMI DOS
  - BMI Result
  - COL DOS
  - COL Procedure
  - BCS DOS

Answer in ./problem-3.sql

## 4)

    +-----------+-----------------+------------+------------+------------+------------+------------+------------+
    | Member Id | Member Name     | A1c DOS    | A1c Result | BMI DOS    | BMI Result | COL DOS    | BCS DOS    |
    +-----------+-----------------+------------+------------+------------+------------+------------+------------+
    |         1 | Michael Jackson | NULL       |       NULL | 2020-03-06 |       29.3 | NULL       | NULL       |
    |         2 | Cyndi Lauper    | 2020-10-01 |        8.2 | 2020-06-02 |       32.9 | NULL       | NULL       |
    |         4 | Duran Duran     | NULL       |       NULL | NULL       |       NULL | NULL       | NULL       |
    |         5 | Fleetwood Mac   | 2020-04-05 |       12.9 | NULL       |       NULL | 2020-06-25 | 2020-06-25 |
    +-----------+-----------------+------------+------------+------------+------------+------------+------------+
    4 rows in set (0.01 sec)

## Section 2
There were a few problems in given query. The variables being selected were not specific enough (the table domains needed to be established). Also, the noncompliant table needed to be joined in order to be reference in the select statement. Upon firing this query, sql_modes 'ONLY_FULL_GROUP_BY' threw an error, not sure if this is important but I went ahead and disabled it. The query below works under this assumption.

	WITH compliant AS (
		SELECT REPORT_DATE, MEASURE, COUNT(*) COMPLIANT_COUNT FROM compliance WHERE COMPLIANCE_FLAG = 'Compliant' GROUP BY REPORT_DATE, MEASURE
	)
	, noncompliant AS (
		SELECT REPORT_DATE, MEASURE, COUNT(*) NON_COMPLIANT_COUNT FROM compliance WHERE COMPLIANCE_FLAG = 'Non-Compliant' GROUP BY REPORT_DATE, MEASURE
	)
	SELECT
	compliance.REPORT_DATE, compliance.MEASURE, COMPLIANT_COUNT, NON_COMPLIANT_COUNT, (COMPLIANT_COUNT / (COUNT(*) * 1.0) ) AS COMPLIANCE_RATE
	FROM compliance
	LEFT JOIN compliant ON compliance.REPORT_DATE = compliant.REPORT_DATE AND compliance.MEASURE = compliant.MEASURE
	LEFT JOIN noncompliant ON compliance.REPORT_DATE = noncompliant.REPORT_DATE AND compliance.MEASURE = noncompliant.MEASURE
	;

## Section 3
### Create a query that returns the minimum number of continuous date ranges where a member was active and provide the results.

So for this query, I did a little snooping online and found an amazing example of it [here](https://stackoverflow.com/questions/16595993/sql-find-continuous-date-ranges-across-multiple-rows). Turns out, a recursive common table expression (cte) is able to compare the start and end dates effectively, and returns the continuous values requested. I will admit, my knowledge of recursive tables and there capabilities is small. I am going to be looking into this tool/sql command in the next couple of days or so. In the meantime, my modified version of the link above (located in section-4.sql) solves our problem properly.

    +-----------------------+------------+------------+
    | name                  | start_date | end_date   |
    +-----------------------+------------+------------+
    | Popeye The Sailor Man | 2020-01-01 | 2020-12-31 |
    +-----------------------+------------+------------+
    1 row in set (0.00 sec)

