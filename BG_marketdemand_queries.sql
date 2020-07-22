/* All AI Job Postings in the U.S.:
  generates the US_AI_jobs table
*/

SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date,
  c.canon_certification as certification
FROM `gcp-cset-projects.burning_glass.job` t
LEFT JOIN `gcp-cset-projects.burning_glass.certification` c USING(job_id, import_time, record_country)
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

/* Core AI Job Postings in the U.S.:
 generates the generates the US_coreAI_jobs table
*/
SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date,
  c.canon_certification as certification
FROM `gcp-cset-projects.burning_glass.job` t
LEFT JOIN `gcp-cset-projects.burning_glass.certification` c USING(job_id, import_time, record_country)
WHERE job_id IN (
  SELECT job_id
  FROM `gcp-cset-projects.burning_glass.skill`
  WHERE
    skill_cluster = "Artificial Intelligence"
    OR skill_cluster = "Data Science"
    OR skill_cluster = "Machine Learning"
    OR skill_cluster = "Natural Language Processing (NLP)"
    AND record_country = "US"
)
  AND career_area_name != "Hospitality, Food, and Tourism"
  AND career_area_name != "Performing Arts"
  AND career_area_name != "Health Care including Nursing"
  AND career_area_name != "Human Resources"
  AND occupation_name NOT IN(SELECT occupation_name FROM `gcp-cset-projects.burning_glass_ai.occupation_name`)
  AND occupation_code NOT IN(SELECT occupation_code FROM `gcp-cset-projects.burning_glass_ai.occupation_codes_notAI`)
  AND record_country = "US"

/* AI Ajdacent Job Postings in the U.S.:
  generates the generates the US_adjacentAI_jobs table
*/
SELECT t.*,
  CAST(retrieval_date AS DATETIME) AS job_posting_date,
  c.canon_certification as certification
FROM `gcp-cset-projects.burning_glass.job` t
LEFT JOIN `gcp-cset-projects.burning_glass.certification` c USING(job_id, import_time, record_country)
WHERE job_id IN (
  SELECT job_id
  -- jd: record_country again
  FROM `gcp-cset-projects.burning_glass.skill`
  WHERE skill_cluster = "Data Science" -- jd: is data science meant to be in both "core" and "adjacent"?
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
    OR skill_cluster = "Statistical Software" -- jd: typos
    OR skill_cluster = "Statistics"
    OR skill_cluster = "System Design and Implementation"
    OR skill_cluster = "Test Automation"
    AND record_country = "US")
  AND career_area_name != "Hospitality, Food, and Tourism"
  AND career_area_name != "Performing Arts"
  AND career_area_name != "Health Care including Nursing"
  AND career_area_name != "Human Resources"
  AND occupation_name NOT IN(SELECT occupation_name FROM `gcp-cset-projects.burning_glass_ai.occupation_name`)
  AND occupation_code NOT IN(SELECT occupation_code FROM `gcp-cset-projects.burning_glass_ai.occupation_codes_notAI`)
  AND record_country = "US"

/* Minimum Degree Requirement Over Time
(using Core AI table for example)
*/
SELECT COUNTIF(canon_minimum_degree = "High School") as high_school_count,
       COUNTIF(canon_minimum_degree = "High School") / COUNT(*)*100 as high_school_percent,
       COUNTIF(canon_minimum_degree = "Associate's") as associates_count,
       COUNTIF(canon_minimum_degree = "Associate's") / COUNT(*)*100 as associates_percent,
       COUNTIF(canon_minimum_degree = "Bachelor's") as bachelors_count,
       COUNTIF(canon_minimum_degree = "Bachelor's") / COUNT(*)*100 as bachelors_percent,
       COUNTIF(canon_minimum_degree = "Master's") as masters_count,
       COUNTIF(canon_minimum_degree = "Master's") / COUNT(*)*100 as masters_percent,
       COUNTIF(canon_minimum_degree = "PhD") as phd_count,
       COUNTIF(canon_minimum_degree = "PhD") / COUNT(*)*100 as phd_percent,
       COUNT(*) as total_count,
EXTRACT(YEAR FROM job_posting_date) as year
FROM `gcp-cset-projects.burning_glass_ai.US_coreAI_jobs`
WHERE canon_minimum_degree IS NOT NULL
GROUP BY year
ORDER BY year

/* Job posting counts by state in 2019 */
SELECT
  COUNT(*) as count,
  canon_state as state
FROM `gcp-cset-projects.burning_glass_ai.US_AI_jobs`
WHERE EXTRACT(YEAR FROM job_posting_date) = 2019
GROUP BY state
ORDER BY state

/* Count all U.S. job postings per year */
SELECT COUNT(*) as posting_count, EXTRACT(YEAR FROM job_posting_date) as year
FROM ( SELECT * FROM ( SELECT job_id, CAST(retrieval_date AS DATETIME) AS job_posting_date FROM `gcp-cset-projects.burning_glass.job` WHERE record_country = "US"))
WHERE job_id IN (SELECT job_id FROM `gcp-cset-projects.burning_glass.job` WHERE record_country = "US")
GROUP BY year
ORDER BY year

/* job posting counts broken down by naics2 for a given year */
SELECT
  COUNT(*) as count,
  naics2_name as naics2
FROM `gcp-cset-projects.burning_glass_ai.US_AI_jobs`
WHERE
  EXTRACT(YEAR FROM job_posting_date) = 2010
  AND naics2_name IS NOT NULL
GROUP BY naics2
ORDER BY naics2

/*LexisNexis Query: counting AI mentions over the years */

select
  ai_counts.num_articles * 20198399 / all_counts.num_articles as normalized_ai_count,
  ai_counts.pubyear
from (
  select
    extract(year from pubdate) as pubyear,
    count(duplicateGroupId) as num_articles
  from
  -- use rank to get the first article published within a duplicateGroup; this helps avoid double-counting
  (
    select
      duplicateGroupId,
	  (case publishedDate is null
        when true then estimatedPublishedDate
        else publishedDate end) as pubdate,
	RANK() over (partition by duplicateGroupId order by id asc) rank
  from gcp_cset_lexisnexis.raw_news
  where (regexp_contains(content, r"(?i)\bartificial intelligence\b")) and
  -- only use articles that had a source present in 2011; otherwise results will be skewed by the influx of non-licensed content after April
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2011 or extract(year from estimatedPublishedDate) = 2011)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2011 or extract(year from estimatedPublishedDate) = 2011)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2012 or extract(year from estimatedPublishedDate) = 2012)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2012 or extract(year from estimatedPublishedDate) = 2012)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2013 or extract(year from estimatedPublishedDate) = 2013)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2013 or extract(year from estimatedPublishedDate) = 2013)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2014 or extract(year from estimatedPublishedDate) = 2014)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2014 or extract(year from estimatedPublishedDate) = 2014)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2015 or extract(year from estimatedPublishedDate) = 2015)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2015 or extract(year from estimatedPublishedDate) = 2015)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2016 or extract(year from estimatedPublishedDate) = 2016)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2016 or extract(year from estimatedPublishedDate) = 2016)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2017 or extract(year from estimatedPublishedDate) = 2017)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2017 or extract(year from estimatedPublishedDate) = 2017)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2018 or extract(year from estimatedPublishedDate) = 2018)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2018 or extract(year from estimatedPublishedDate) = 2018)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2019 or extract(year from estimatedPublishedDate) = 2019)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2019 or extract(year from estimatedPublishedDate) = 2019)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2020 or extract(year from estimatedPublishedDate) = 2020)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2020 or extract(year from estimatedPublishedDate) = 2020)))))
where (rank = 1) and (extract(year from pubdate) > 2010) and (extract(year from pubdate) < 2021) -- there are some obviously incorrect pubdates so we have to check < 2021!
group by pubyear order by pubyear desc) as ai_counts
left join
(select extract(year from pubdate) as pubyear, count(duplicateGroupId) as num_articles from
  -- use rank to get the first article published within a duplicateGroup; this helps avoid double-counting
  (select duplicateGroupId,
	(case publishedDate is null when true then estimatedPublishedDate else publishedDate end) as pubdate,
	RANK() over (partition by duplicateGroupId order by id asc) rank
  from gcp_cset_lexisnexis.raw_news
  where
  -- only use articles that had a source present in 2011; otherwise results will be skewed by the influx of non-licensed content after April
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2011 or extract(year from estimatedPublishedDate) = 2011)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2011 or extract(year from estimatedPublishedDate) = 2011)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2012 or extract(year from estimatedPublishedDate) = 2012)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2012 or extract(year from estimatedPublishedDate) = 2012)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2013 or extract(year from estimatedPublishedDate) = 2013)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2013 or extract(year from estimatedPublishedDate) = 2013)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2014 or extract(year from estimatedPublishedDate) = 2014)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2014 or extract(year from estimatedPublishedDate) = 2014)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2015 or extract(year from estimatedPublishedDate) = 2015)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2015 or extract(year from estimatedPublishedDate) = 2015)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2016 or extract(year from estimatedPublishedDate) = 2016)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2016 or extract(year from estimatedPublishedDate) = 2016)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2017 or extract(year from estimatedPublishedDate) = 2017)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2017 or extract(year from estimatedPublishedDate) = 2017)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2018 or extract(year from estimatedPublishedDate) = 2018)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2018 or extract(year from estimatedPublishedDate) = 2018)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2019 or extract(year from estimatedPublishedDate) = 2019)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2019 or extract(year from estimatedPublishedDate) = 2019)))) and
  ((source.name in (select distinct source.name from gcp_cset_lexisnexis.raw_news where extract(year from publishedDate) = 2020 or extract(year from estimatedPublishedDate) = 2020)) or
  (source.id in (select distinct source.id from gcp_cset_lexisnexis.raw_news where (extract(year from publishedDate) = 2020 or extract(year from estimatedPublishedDate) = 2020)))))
where (rank = 1) and (extract(year from pubdate) > 2010) and (extract(year from pubdate) < 2021) -- there are some obviously incorrect pubdates so we have to check < 2021!
group by pubyear order by pubyear desc) as all_counts
on ai_counts.pubyear = all_counts.pubyear
