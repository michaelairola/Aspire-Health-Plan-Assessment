WITH
	hedis_claims_union AS (
		SELECT member_id, hedis_measure, date_of_service, result FROM hedis
		UNION ALL
		SELECT member_id, hedis_measure, date_of_service, NULL FROM claims
	),
	current_measures AS (SELECT 
		hedis_claims_union.member_id,
		hedis_claims_union.hedis_measure,
		hedis_claims_union.date_of_service,
		hedis_claims_union.result
	FROM hedis_claims_union 
	INNER JOIN (
		SELECT 
		 member_id, 
		 hedis_measure,
		 MAX(date_of_service) AS date_of_service
		FROM hedis_claims_union
		GROUP BY member_id, hedis_measure 
	) h ON hedis_claims_union.member_id = h.member_id AND hedis_claims_union.hedis_measure = h.hedis_measure AND hedis_claims_union.date_of_service = h.date_of_service
) 
SELECT 
	eligibility.member_id AS "Member Id",
	eligibility.name AS "Member Name",
	a1c.date_of_service AS "A1c DOS",
	a1c.result AS "A1c Result",
	bmi.date_of_service AS "BMI DOS",
	bmi.result AS "BMI Result",
	col.date_of_service AS "COL DOS",
	bcs.date_of_service AS "BCS DOS"
FROM eligibility
LEFT JOIN (
	SELECT 
	 member_id, 
	 date_of_service,
	 result
	FROM current_measures 
	WHERE hedis_measure = 'A1C'
) a1c ON eligibility.member_id = a1c.member_id
LEFT JOIN (
	SELECT 
	 member_id, 
	 date_of_service,
	 result
	FROM current_measures 
	WHERE hedis_measure = 'BMI'
) bmi ON eligibility.member_id = bmi.member_id
LEFT JOIN (
	SELECT 
	 member_id, 
	 date_of_service,
	 result
	FROM current_measures 
	WHERE hedis_measure = 'COL'
) col ON eligibility.member_id = col.member_id
LEFT JOIN (
	SELECT 
	 member_id, 
	 date_of_service,
	 result
	FROM current_measures 
	WHERE hedis_measure = 'COL'
) bcs ON eligibility.member_id = bcs.member_id
WHERE end_date IS NULL;