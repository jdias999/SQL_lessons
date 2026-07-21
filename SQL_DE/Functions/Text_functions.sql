--vamos limpar isso, utilizando as text functions

WITH title_lower AS (--vamos criar uma cte que deixe tudo em lower case, para puxar todos sem erro
    SELECT 
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM
        job_postings_fact
)


SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;