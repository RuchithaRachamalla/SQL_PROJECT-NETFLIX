-- BUSINESS PROBLEMS AND SOLUTIONS
 
--1. Count the Number of Movies vs TV Shows

SELECT
      TYPE,
	  COUNT(*) AS TOTAL_CONTENT
FROM OTT
GROUP BY TYPE

--2. Find the Most Common Rating for Movies and TV Shows
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

--3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM OTT
WHERE 
     TYPE='Movie'
	 AND
	 RELEASE_YEAR=2020

--4 .Find the Top 5 Countries with the Most Content on Netflix

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

--5. Identify the Longest Movie

SELECT * FROM OTT
WHERE 
     TYPE='Movie'
	 AND 
	 DURATION=(SELECT MAX(DURATION)FROM OTT)

--6. Find Content Added in the Last 5 Years

SELECT * FROM OTT
WHERE TO_DATE(DATE_ADDED,'MONTH DD,YYYY')>=CURRENT_DATE-INTERVAL '5 YEARS'

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
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

--8. List All TV Shows with More Than 5 Seasons

SELECT 
      *
	  FROM OTT
WHERE 
     TYPE='TV Show'
	 AND 
	 SPLIT_PART(DURATION,' ',1):: NUMERIC > 5

--9. Count the Number of Content Items in Each Genre

SELECT 
    UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
    COUNT(*) AS TOTAL_GENRE
FROM OTT
GROUP BY 1

--10.Find each year and the average numbers of content release in India on netflix.
--return top 5 year with highest avg content release!

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

--11. List All Movies that are Documentaries

SELECT * FROM OTT
WHERE LISTED_IN ILIKE '%Documentaries%'

 --12. Find All Content Without a Director
 
SELECT * FROM OTT
WHERE DIRECTOR IS NULL

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * FROM OTT
WHERE CASTS ILIKE '%Salman Khan%'
      AND 
	  RELEASE_YEAR > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(CASTS, ',')) AS ACTORS,
    COUNT(*) AS TOTAL_CONTENT
FROM OTT
WHERE COUNTRY = 'India'
GROUP BY ACTORS
ORDER BY 2 DESC
LIMIT 10

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

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
