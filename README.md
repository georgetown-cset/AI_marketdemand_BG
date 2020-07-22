# AI_marketdemand_BG
code for AI job market analysis (Burning Glass)

## Market demand for AI talent report
We used Burning Glass job posting data for this report. The data was last queried on 06/22/2020.

We generated three main tables from which we performed our analysis on:
* US_AI_jobs
* US_coreAI_jobs
* US_adjacentAI_jobs

All other queries reference these three tables for the Burning Glass analysis.

We manually identified occupation names and occupation codes that did not relate to AI which we use in our queries:
* [occupation_name.csv](https://github.com/georgetown-cset/AI_marketdemand_BG/blob/master/occupation_name.csv)
* [occupation_codes_notAI.csv](https://github.com/georgetown-cset/AI_marketdemand_BG/blob/master/occupation_codes_notAI.csv)

The last query is a normalized count of "artificial intelligence" mentions in LexisNexis. 

We include the list of job titles for the Core AI & AI Adjacent job postings in 2019 in the U.S.:
*[US_AI_2019_jobtitles.csv](https://github.com/georgetown-cset/AI_marketdemand_BG/blob/master/US_AI_2019_jobtitles.csv)
