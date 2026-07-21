
--aqui, criamos uma temp table para cruzar com a tabela principal. Se, por exemplo, mudarmos um dado de priority_lvl,
--isso não atualizaria direto da main, sendo necessário criar esse processo

CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS update_at
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
ON jpf.company_id = cd.company_id
JOIN staging.priority_roles AS r
ON jpf.job_title_short = r.role_name;

--update

UPDATE 
    main.priority_jobs_snapshot AS tgt
SET 
    priority_lvl = src.priority_lvl,
    update_at = src.update_at
FROM
     src_priority_jobs AS src
WHERE
    tgt.job_id = src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;

--insert

INSERT INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    update_at
)
SELECT
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.update_at
FROM 
    src_priority_jobs AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM  main.priority_jobs_snapshot AS tgt
    WHERE tgt.job_id = src.job_id
);

-- delete

DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS  (
    SELECT 1
    FROM  src_priority_jobs_ AS src
    WHERE src.job_id = tgt.job_id
);








--agora, vamos fazer o merge

MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE 
        priority_lvl = src.priority_lvl,
        update_at = src.update_at
WHEN NOT MATCHED THEN  --aqui, nao precisaremos usar o where not exist, o merge faz isso de forma automática!!
    INSERT (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    update_at
)
VALUES (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.update_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;



-- query para verificar

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MAX(priority_lvl) AS priority_lvl,
    MIN(update_at) AS update_at
FROM
    priority_jobs_snapshot
GROUP BY 
    job_title_short
ORDER BY
    job_count DESC;
    


