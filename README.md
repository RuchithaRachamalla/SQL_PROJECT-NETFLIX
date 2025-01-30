# Netflix Movies and TV Shows Data Analysis using SQL

![NETFLIX](https://github.com/RuchithaRachamalla/SQL_PROJECT-NETFLIX/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
/* CREATING DATABASE */

CREATE DATABASE NETFLIX

/* CREATING TABLE */

DROP TABLE IF EXISTS OTT
CREATE TABLE OTT
  (
        SHOW_ID VARCHAR(6),
		TYPE VARCHAR(10) ,
		TITLE VARCHAR(150),
		DIRECTOR VARCHAR(208),
		CASTS VARCHAR(1000),
		COUNTRY VARCHAR(150),
		DATE_ADDED VARCHAR(50),
		RELEASE_YEAR INT,
		RATING VARCHAR(10),
		DURATION VARCHAR(15),
		LISTED_IN VARCHAR(100),
		DESCRIPTION VARCHAR(250)
  )
```

## Business Problems and Solutions

**1. Count the Number of Movies vs TV Shows**

```sql
SELECT
      TYPE,
	  COUNT(*) AS TOTAL_CONTENT
FROM OTT
GROUP BY TYPE
```

**Objective:** Determine the distribution of content types on Netflix.

**2. Find the Most Common Rating for Movies and TV Shows**

```sql
SELECT
      TYPE,
	  RATING
FROM
(	  
     SELECT 
          TYPE,
	      RATING,
	      --MAX(RATING)
	      COUNT(*),
	      RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM OTT
GROUP BY 1,2 
) AS T1
WHERE RANKING = 1
```

**Objective:** Identify the most frequently occurring rating for each type of content.

**3. List All Movies Released in a Specific Year (e.g., 2020)**

```sql
SELECT * FROM OTT
WHERE 
     TYPE='Movie'
	 AND
	 RELEASE_YEAR=2020
```

**Objective:** Retrieve all movies released in a specific year.

**4. Find the Top 5 Countries with the Most Content on Netflix**

```sql
SELECT
     UNNEST(STRING_TO_ARRAY(COUNTRY,',')) AS NEW_COUNTRY,
	 COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM OTT
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT 
      UNNEST(STRING_TO_ARRAY(COUNTRY,',')) AS NEW_COUNTRY 
FROM OTT
```

**Objective:** Identify the top 5 countries with the highest number of content items.

**5. Identify the Longest Movie**

```sql
SELECT * FROM OTT
WHERE 
     TYPE='Movie'
	 AND 
	 DURATION=(SELECT MAX(DURATION)FROM OTT)
```

**Objective:** Find the movie with the longest duration.

**6. Find Content Added in the Last 5 Years**

```sql
SELECT * FROM OTT
WHERE TO_DATE(DATE_ADDED,'MONTH DD,YYYY')>=CURRENT_DATE-INTERVAL '5 YEARS'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

**7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'**

```sql
SELECT 
      *
FROM
(
SELECT
      *,
      UNNEST(STRING_TO_ARRAY(DIRECTOR,',')) AS  DIRECTOR_NAME
      FROM OTT
) AS T1
WHERE DIRECTOR_NAME='Rajiv Chilaka'

--OR

SELECT * FROM OTT
WHERE DIRECTOR ILIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

**8. List All TV Shows with More Than 5 Seasons**

```sql
SELECT 
      *
	  FROM OTT
WHERE 
     TYPE='TV Show'
	 AND 
	 SPLIT_PART(DURATION,' ',1):: NUMERIC > 5

```

**Objective:** Identify TV shows with more than 5 seasons.

**9. Count the Number of Content Items in Each Genre**

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
    COUNT(*) AS TOTAL_GENRE
FROM OTT
GROUP BY 1
```

**Objective:** Count the number of content items in each genre.

**10.Find each year and the average numbers of content release in India on netflix.**
return top 5 year with highest avg content release!

```sql
SELECT 
    COUNTRY,
    RELEASE_YEAR,
    COUNT(SHOW_ID) AS TOTAL_RELEASES,
    ROUND(
        COUNT(SHOW_ID)::NUMERIC /
        (SELECT COUNT(SHOW_ID) FROM OTT WHERE COUNTRY = 'India')::NUMERIC * 100, 2
    ) AS AVERAGE_RELEASE
FROM OTT
WHERE COUNTRY = 'India'
GROUP BY COUNTRY, RELEASE_YEAR
ORDER BY AVERAGE_RELEASE DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

**11. List All Movies that are Documentaries**

```sql
SELECT * FROM OTT
WHERE LISTED_IN ILIKE '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

**12. Find All Content Without a Director**

```sql
SELECT * FROM OTT
WHERE DIRECTOR IS NULL
```

**Objective:** List content that does not have a director.

**13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years**

```sql

SELECT * FROM OTT
WHERE CASTS ILIKE '%Salman Khan%'
      AND 
	  RELEASE_YEAR > EXTRACT(YEAR FROM CURRENT_DATE) - 10

```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

**14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India**

```sql

SELECT * FROM OTT
WHERE CASTS ILIKE '%Salman Khan%'
      AND 
	  RELEASE_YEAR > EXTRACT(YEAR FROM CURRENT_DATE) - 10

```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

**15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords**

```sql
SELECT 
    CATEGORY,
    COUNT(*) AS CONTENT_COUNT
FROM (
    SELECT 
        CASE 
            WHEN DESCRIPTION ILIKE '%kill%' OR DESCRIPTION ILIKE '%violence%' THEN 'Bad content'
            ELSE 'Good content'
        END AS CATEGORY
    FROM OTT
) AS CATEGORIZED_CONTENT
GROUP BY CATEGORY
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


## Author - Ruchitha Rachamalla 

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your interest in this project!
