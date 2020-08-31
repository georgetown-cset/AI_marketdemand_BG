/* create table of core AI and AI adjacent jobs
US_AI_jobs */
SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date
FROM `gcp-cset-projects.burning_glass.job` t
WHERE job_id IN (
  SELECT job_id
  FROM `gcp-cset-projects.burning_glass.skill`
  WHERE skill_cluster = "Artificial Intelligence"
    OR skill_cluster = "Data Science"
    OR skill_cluster = "Machine Learning"
    OR skill_cluster = "Natural Language Processing (NLP)"
    OR skill_cluster = "Automation Engineering"
    OR skill_cluster = "Data Mining"
    OR skill_cluster = "Economics"
    OR skill_cluster = "Industrial Automation"
    OR skill_cluster = "IT Automation"
    OR skill_cluster = "Mathematical Modeling"
    OR skill_cluster = "Mathematical Software"
    OR skill_cluster = "Mathematics"
    OR skill_cluster = "Medical Research"
    OR skill_cluster = "Research Methodology"
    OR skill_cluster = "Robotics"
    OR skill_cluster = "Scripting Languages"
    OR skill_cluster = "Signal Processing"
    OR skill_cluster = "Statistical Software"
    OR skill_cluster = "Statistics"
    OR skill_cluster = "System Design and Implementation"
    OR skill_cluster = "Test Automation"
  AND record_country = "US")
  AND career_area_name != "Hospitality, Food, and Tourism"
  AND career_area_name != "Performing Arts"
  AND career_area_name != "Health Care including Nursing"
  AND occupation_name NOT IN(SELECT occupation_name FROM `gcp-cset-projects.burning_glass_ai.occupation_name`)
  AND occupation_code NOT IN(SELECT occupation_code FROM `gcp-cset-projects.burning_glass_ai.occupation_codes_notAI`)
  AND record_country = "US"


  /* generates table US_adjacentAI */
  SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date
FROM `gcp-cset-projects.burning_glass.job` t
WHERE job_id IN (
  SELECT job_id
  FROM `gcp-cset-projects.burning_glass.skill`
  WHERE skill_cluster = "Data Science"
    OR skill_cluster = "Automation Engineering"
    OR skill_cluster = "Data Mining"
    OR skill_cluster = "Economics"
    OR skill_cluster = "Industrial Automation"
    OR skill_cluster = "IT Automation"
    OR skill_cluster = "Mathematical Modeling"
    OR skill_cluster = "Mathematical Software"
    OR skill_cluster = "Mathematics"
    OR skill_cluster = "Medical Research"
    OR skill_cluster = "Research Methodology"
    OR skill_cluster = "Robotics"
    OR skill_cluster = "Scripting Languages"
    OR skill_cluster = "Signal Processing"
    OR skill_cluster = "Statistical Software"
    OR skill_cluster = "Statistics"
    OR skill_cluster = "System Design and Implementation"
    OR skill_cluster = "Test Automation"
  AND record_country = "US")
  AND career_area_name != "Hospitality, Food, and Tourism"
  AND career_area_name != "Performing Arts"
  AND career_area_name != "Health Care including Nursing"
  AND occupation_name NOT IN(SELECT occupation_name FROM `gcp-cset-projects.burning_glass_ai.occupation_name`)
  AND occupation_code NOT IN(SELECT occupation_code FROM `gcp-cset-projects.burning_glass_ai.occupation_codes_notAI`)
  AND record_country = "US"

  /* generates table US_coreAI */
  SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date
FROM `gcp-cset-projects.burning_glass.job` t
WHERE job_id IN (
  SELECT job_id
  FROM `gcp-cset-projects.burning_glass.skill`
  WHERE skill_cluster = "Artificial Intelligence"
    OR skill_cluster = "Data Science"
    OR skill_cluster = "Machine Learning"
    OR skill_cluster = "Natural Language Processing (NLP)"
  AND record_country = "US")
  AND career_area_name != "Hospitality, Food, and Tourism"
  AND career_area_name != "Performing Arts"
  AND career_area_name != "Health Care including Nursing"
  AND occupation_name NOT IN(SELECT occupation_name FROM `gcp-cset-projects.burning_glass_ai.occupation_name`)
  AND occupation_code NOT IN(SELECT occupation_code FROM `gcp-cset-projects.burning_glass_ai.occupation_codes_notAI`)
  AND record_country = "US"

  /* generate a table for job posting info and degree major
  US_AI_withMajors */
  SELECT t.job_id, t.canon_employer, t.clean_job_title, t.naics2_name, t.canon_minimum_degree, t.canon_preferred_degree, t.job_posting_date, m.standard_major as degree_major FROM `gcp-cset-projects.burning_glass_ai.US_AI_jobs` t
  LEFT JOIN `gcp-cset-projects.burning_glass.major` m USING(job_id, record_country, import_time)

  /* generates table coreAI_withMajors */
  SELECT t.job_id, t.canon_employer, t.clean_job_title, t.naics2_name, t.canon_minimum_degree, t.canon_preferred_degree, t.job_posting_date, m.standard_major as degree_major FROM `gcp-cset-projects.burning_glass_ai.US_coreAI` t
  LEFT JOIN `gcp-cset-projects.burning_glass.major` m USING(job_id, record_country, import_time)

  /* generates table adjacentAI_withMajors */
  SELECT t.job_id, t.canon_employer, t.clean_job_title, t.naics2_name, t.canon_minimum_degree, t.canon_preferred_degree, t.job_posting_date, m.standard_major as degree_major FROM `gcp-cset-projects.burning_glass_ai.US_adjacentAI` t
  LEFT JOIN `gcp-cset-projects.burning_glass.major` m USING(job_id, record_country, import_time)

  /*degree breakdown*/
  SELECT COUNT(job_id) as posting_count, degree_major FROM `gcp-cset-projects.burning_glass_ai.US_AI_withMajors`
  WHERE job_id IN(SELECT job_id FROM(
  SELECT COUNT(degree_major) as degree_count, job_id FROM `gcp-cset-projects.burning_glass_ai.US_AI_withMajors`
  GROUP BY job_id)
  WHERE degree_count <= 10)
  AND canon_minimum_degree = "Bachelor's"
  GROUP BY degree_major
  ORDER BY posting_count DESC

  /* job title breakdown */
  SELECT COUNT(job_id) as posting_count, clean_job_title FROM `gcp-cset-projects.burning_glass_ai.US_AI_jobs`
  WHERE job_id IN(SELECT job_id FROM(
  SELECT COUNT(degree_major) as degree_count, job_id FROM `gcp-cset-projects.burning_glass_ai.US_AI_withMajors`
  GROUP BY job_id)
  WHERE degree_count <= 10)
  AND canon_minimum_degree = "Bachelor's"
  GROUP BY clean_job_title
  ORDER BY posting_count DESC

  /* skills associated with top job titles */

  SELECT COUNT(job_id) as posting_count, skill as skill FROM `gcp-cset-projects.burning_glass.skill`
  WHERE job_id IN(SELECT job_id FROM `gcp-cset-projects.burning_glass_ai.US_AI_jobs`
                  WHERE clean_job_title = "Software Engineer"
                  OR clean_job_title = "Systems Engineer"
                  OR clean_job_title = "Business Analyst"
                  OR clean_job_title = "Senior Software Engineer"
                  OR clean_job_title = "Project Manager"
                  OR clean_job_title = "Financial Analyst"
                  OR clean_job_title = "Java Developer"
                  OR clean_job_title = "Senior Systems Engineer"
                  OR clean_job_title = "Systems Administrator"
                  OR clean_job_title = "Systems Analyst"
                  OR clean_job_title = "Software Developer"
                  OR clean_job_title = "Quality Engineer"
                  OR clean_job_title = "Electrical Engineer"
                  OR clean_job_title = "Data Analyst"
                  OR clean_job_title = "Staff Accountant"
                  OR clean_job_title = "Business Systems Analyst"
                  OR clean_job_title = "Devops Engineer"
                  OR clean_job_title = "Senior Business Analyst"
                  OR clean_job_title = "Senior Java Developer"
                  OR clean_job_title = "Network Engineer"
                  OR clean_job_title = "Mechanical Engineer"
                  OR clean_job_title = "Quality Assurance Engineer"
                  OR clean_job_title = "Senior Financial Analyst"
                  OR clean_job_title = "Data Scientist"
                  OR clean_job_title = ".Net Developer"
                  AND canon_minimum_degree = "Bachelor's")
  GROUP BY skill
  ORDER BY posting_count DESC

  /* skills associated with core AI titles */
  SELECT COUNT(job_id) as posting_count, skill as skill FROM `gcp-cset-projects.burning_glass.skill`
  WHERE job_id IN(SELECT job_id FROM `gcp-cset-projects.burning_glass_ai.US_coreAI`
                  WHERE clean_job_title = "Data Scientist"
                  OR clean_job_title = "Software Engineer"
                  OR clean_job_title = "Data Engineer"
                  OR clean_job_title = "Data Analyst"
                  OR clean_job_title = "Senior Data Scientist"
                  OR clean_job_title = "Senior Software Engineer"
                  OR clean_job_title = "Senior Data Engineer"
                  OR clean_job_title = "Business Analyst"
                  OR clean_job_title = "Senior Data Analyst"
                  OR clean_job_title = "Software Developer"
                  OR clean_job_title = "Data Architect"
                  OR clean_job_title = "Machine Learning Engineer"
                  OR clean_job_title = "Product Manager"
                  OR clean_job_title = "Big Data Engineer"
                  OR clean_job_title = "Business Intelligence Analyst"
                  OR clean_job_title = "Java Developer"
                  OR clean_job_title = "Solutions Architect"
                  OR clean_job_title = "Project Manager"
                  OR clean_job_title = "Lead Data Scientist"
                  OR clean_job_title = "Senior Product Manager"
                  OR clean_job_title = "Software Development Engineer"
                  OR clean_job_title = "Associate Data Scientist"
                  OR clean_job_title = "Python Developer"
                  OR clean_job_title = "Marketing Analyst"
                  OR clean_job_title = "Big Data Architect"
                  AND canon_minimum_degree = "Bachelor's")
  GROUP BY skill
  ORDER BY posting_count DESC
