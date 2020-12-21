WITH RECURSIVE cte AS (
    SELECT name, start_date, end_date
    FROM eligibility WHERE start_date < IFNULL(end_date, "9999-12-31")
    UNION ALL
    SELECT e.name, cte.start_date, e.end_date
    FROM cte
    JOIN eligibility e ON cte.name = e.name and IFNULL(cte.end_date, "9999-12-31") <= DATE_ADD(e.start_date, INTERVAL 1 DAY)
), cte2 as (
    SELECT name, start_date, end_date, row_number() over (partition by name, end_date ORDER BY start_date) AS rn
    FROM cte
)
SELECT name, start_date, max(end_date) end_date
FROM cte2
WHERE rn=1
GROUP BY name, start_date
ORDER BY name, start_date;
