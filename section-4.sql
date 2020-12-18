WITH RECURSIVE cte AS (
    SELECT name, start_date, end_date
    FROM eligibility
    UNION ALL
    SELECT e.name, cte.start_date, e.end_date
    FROM cte
    JOIN eligibility e ON cte.name = e.name and cte.end_date < e.start_date + 1
), cte2 as (
    SELECT name, start_date, end_date, row_number() over (partition by name, end_date ORDER BY start_date) AS rn
    FROM cte
)
SELECT name, start_date, max(end_date) end_date
FROM cte2
WHERE rn=1
GROUP BY name, start_date
ORDER BY name, start_date;
