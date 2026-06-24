--exemplos de subqueries

SELECT *
FROM (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR
    salary_hour_avg IS NOT NULL
)
LIMIT 10;

--outro exemplo

SELECT job_title, company_id, salary_year_avg
FROM data_jobs.job_postings_fact
WHERE salary_year_avg > (
    SELECT AVG(salary_year_avg) 
    FROM data_jobs.job_postings_fact 
    WHERE job_title_short = 'Data Engineer'
);

-- exemplo de cte

WITH valid_salary AS (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR
    salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salary
LIMIT 10;

--exemplos de subqueries
--usando no select
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
    ) AS market_median_salary
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL;

--usando no from
SELECT
    job_title_short,
    MEDIAN(salary_year_avg),
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_home_median_salary
    FROM (
        SELECT  
            job_title_short,
            salary_year_avg
        FROM 
            data_jobs.job_postings_fact
        WHERE 
            job_work_from_home = TRUE
        ) AS clean_jobs
    GROUP BY  job_title_short
    LIMIT 10;

--utilizando também no having

SELECT
    job_title_short,
    MEDIAN(salary_year_avg),
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_home_median_salary
    FROM (
        SELECT  
            job_title_short,
            salary_year_avg
        FROM 
            data_jobs.job_postings_fact
        WHERE 
            job_work_from_home = TRUE
        ) AS clean_jobs
    GROUP BY  job_title_short
    HAVING MEDIAN(salary_year_avg) > (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    )
    LIMIT 10;

--Exemplo de CTE


WITH title_median AS (
SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg) ::INT AS market_median_salary
FROM
    data_jobs.job_postings_fact
WHERE 
    job_country = 'United States'
GROUP BY 
    job_title_short,
    job_work_from_home
)

SELECT 
    r.job_title_short,
    o.market_median_salary AS not_remote_median_salary,
    r.market_median_salary AS remote_median_salary
FROM 
    title_median AS r
JOIN 
    title_median AS o ON 
    r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
AND o.job_work_from_home = FALSE;

--usado where exist, onde vamos pegar os trabalhos que não tem nenhuma skill relacionada

SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;