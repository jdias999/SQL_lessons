--Exemplo de array

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)

SELECT ARRAY_AGG(skill) as skills_array --tranformar a Cte em array, porém em uma ordem não fixa de index
FROM skills;

--Exemplo de struct

SELECT { skill: 'python', type: 'programming'} AS skill_struct;

WITH skill_struct AS (
SELECT 
    STRUCT_PACK (
        skill := 'Python',
        type := 'Programming'
    ) AS S
)

SELECT 
    S.skill,
    S.type
FROM skill_struct;

--Outra struct

WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT 
    STRUCT_PACK (
        skill := skills,
        type := types
    ) 
FROM skill_table;


--Exemplo de json


WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK (
        skill := json_extract_string(skill_json, '$.skill'),
        types := json_extract_string(skill_json, '$.type')
    )
FROM
    raw_skill_json;

--Exemplo transformando skills de uma unica vaga, em uma list

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM
    job_postings_fact AS jpf
LEFT JOIN
    skills_job_dim AS sjd 
ON jpf.job_id = sjd.job_id
LEFT JOIN
    skills_dim AS sd
ON sd.skill_id = sjd.skill_id
GROUP BY ALL;
