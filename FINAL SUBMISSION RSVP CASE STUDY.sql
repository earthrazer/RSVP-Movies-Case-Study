USE imdb;
/* Now that you have imported the data sets, let’s explore some of the tables.
To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*)
FROM   movie;

-- Number of rows = 7997
SELECT Count(*)
FROM   genre;

-- Number of rows = 14662
SELECT Count(*)
FROM   director_mapping;

-- Number of rows = 3867
SELECT Count(*)
FROM   role_mapping;

-- Number of rows = 15615
SELECT Count(*)
FROM   names;

-- Number of rows = 25735
SELECT Count(*)
FROM   ratings;

-- Number of rows = 7997


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(
       CASE
              WHEN id IS NULL THEN 1
              ELSE 0
       end) AS ID,
       Sum(
       CASE
              WHEN title IS NULL THEN 1
              ELSE 0
       end ) AS Title,
       Sum(
       CASE
              WHEN year IS NULL THEN 1
              ELSE 0
       end ) AS YEAR,
       Sum(
       CASE
              WHEN date_published IS NULL THEN 1
              ELSE 0
       end ) AS DatePublished,
       Sum(
       CASE
              WHEN duration IS NULL THEN 1
              ELSE 0
       end ) AS Duration,
       Sum(
       CASE
              WHEN country IS NULL THEN 1
              ELSE 0
       end ) AS Country,
       Sum(
       CASE
              WHEN worlwide_gross_income IS NULL THEN 1
              ELSE 0
       end ) AS WorldWide,
       Sum(
       CASE
              WHEN languages IS NULL THEN 1
              ELSE 0
       end ) AS Language,
       Sum(
       CASE
              WHEN production_company IS NULL THEN 1
              ELSE 0
       end ) AS production_company
FROM   movie;

-- Columns with null values are country, worlwide_gross_income, languages and production_company

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year.
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:
+---------------+-------------------+
| Year      |  number_of_movies|
+-------------------+----------------
|  2017    |  2134      |
|  2018    |    .      |
|  2019    |    .      |
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|  month_num  |  number_of_movies|
+---------------+----------------
|  1      |   134      |
|  2      |   231      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:
-- Number of movies released each year
SELECT   year         AS YEAR,
         Count(title) AS number_of_movies
FROM     movie
GROUP BY year;

-- Number of movies released month wise
SELECT   Month(date_published) AS month_num,
         Count(id)             AS number_of_movies
FROM     movie
GROUP BY Month(date_published)
ORDER BY Month(date_published);

-- Maximum number of movies were released during year 2017 & there is a decreasing trend towards 2019.
-- Maximum number of movies are released in January,March,September,October and least number of movies is in month of December.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table.
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(DISTINCT m.id) AS number_of_movies,
       year
FROM   movie m
WHERE  year = 2019
AND    (
              country LIKE '%INDIA%'
       OR     country LIKE '%USA%' );

-- 1059 movies were produced in the USA or India during the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!!
Let’s find out the different genres in the dataset.*/
-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT(genre)
FROM            genre;

-- There are 13 genres in the dataset & they are Mystery, Family, Adventure, Romance, Others, Fantasy, Thriller, Horror, Action, Drama, Comedy, Sci-Fi, Crime

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */
-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT     g.genre,
           Count(m.id) AS num_of_movie
FROM       genre g
INNER JOIN movie m
ON         g.movie_id = m.id
GROUP BY   genre
ORDER BY   Count(id) DESC;

-- Drama genre had the highest number of movies produced

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre.
But wait, it is too early to decide. A movie can belong to two or more genres.
So, let’s find out the count of movies that belong to only one genre.*/
-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movies_one_genre
AS
  (
           SELECT   movie_id
           FROM     genre
           GROUP BY movie_id
           HAVING   count(DISTINCT genre) = 1 )
  SELECT count(*) AS movies_one_genre
  FROM   movies_one_genre;
  
  -- 3289 movies belong to only one genre

  /* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant.
Now, let's find out the possible duration of RSVP Movies’ next project.*/
  -- Q8.What is the average duration of movies in each genre?
  -- (Note: The same movie can belong to multiple genres.)
  /* Output format:
+---------------+-------------------+
| genre      |  avg_duration  |
+-------------------+----------------
|  thriller  |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
  -- Type your code below:
  SELECT     g.genre                    AS genre,
             Round( Avg(m.duration),2 ) AS avg_duration
  FROM       movie m
  INNER JOIN genre g
  ON         m.id = g.movie_id
  GROUP BY   genre
  ORDER BY   Avg(m.duration) DESC;
  
  -- Action genre has the highest average of 112.88 followed by Romance with 109.53 and Crime with 107.05. The least is Horror genre with 92.72.

  /* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/
  -- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?
  -- (Hint: Use the Rank function)
  /* Output format:
+---------------+-------------------+---------------------+
| genre      |    movie_count  |    genre_rank    |
+---------------+-------------------+---------------------+
|drama      |  2312      |      2      |
+---------------+-------------------+---------------------+*/
  -- Type your code below:
  SELECT     g.genre                                   AS genre,
             Count(m.id)                               AS movie_count,
             Rank() over ( ORDER BY count(m.id) DESC )    genre_rank
  FROM       movie m
  INNER JOIN genre g
  ON         m.id = g.movie_id
  GROUP BY   genre
  ORDER BY   genre_rank;
  
  -- Rank of genre thriller is 3

  /*Thriller movies is in top 3 among all genres in terms of number of movies
In the previous segment, you analysed the movies and genres tables.
In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/
  -- Segment 2:
  -- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
  /* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|  max_avg_rating  |  min_total_votes   |  max_total_votes    |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|    0    |      5    |         177      |     2000           |    0         |  8       |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
  -- Type your code below:
  SELECT Min(avg_rating)    AS min_avg_rating,
         Max(avg_rating)    AS max_avg_rating,
         Min(total_votes)   AS min_total_votes,
         Max(total_votes)   AS max_total_votes,
         Min(median_rating) AS min_median_rating,
         Max(median_rating) AS max_median_rating
  FROM   ratings;
  
  /* So, the minimum and maximum values in each column of the ratings table are in the expected range.
This implies there are no outliers in the table.
Now, let’s find out the top 10 movies based on average rating.*/
  -- Q11. Which are the top 10 movies based on average rating?
  /* Output format:
+---------------+-------------------+---------------------+
| title      |    avg_rating  |    movie_rank    |
+---------------+-------------------+---------------------+
| Fan      |    9.6      |      5        |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
+---------------+-------------------+---------------------+*/
  -- Type your code below:
  -- It's ok if RANK() or DENSE_RANK() is used too
  WITH avg_rating_rank
AS
  (
             SELECT     m.title                                   AS title,
                        a.avg_rating                              AS avg_rating,
                        rank() over( ORDER BY a.avg_rating DESC )    movie_rank
             FROM       movie m
             INNER JOIN ratings a
             ON         m.id = a.movie_id )
  SELECT *
  FROM   avg_rating_rank
  WHERE  movie_rank <= 10;
  
  -- Kirket and Love in Kilnerry has highest avg_rating of 10 followed by Gini Helida Kathe of 9.8.

  /* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/
  -- Q12. Summarise the ratings table based on the movie counts by median ratings.
  /* Output format:
+---------------+-------------------+
| median_rating  |  movie_count    |
+-------------------+----------------
|  1      |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
  -- Type your code below:
  -- Order by is good to have
  SELECT   median_rating,
           Count(movie_id) AS movie_count
  FROM     ratings
  GROUP BY median_rating
  ORDER BY movie_count DESC;
  
  -- Movies with a median rating of 7 is the highest in number with 2257 counts.

  /* Movies with a median rating of 7 is highest in number.
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/
  -- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
  /* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count         |  prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers     |    1       |      1       |
+------------------+-------------------+---------------------+*/
  -- Type your code below:
  SELECT     production_company,
             Count(id)                              AS movie_count,
             Rank() over( ORDER BY count(id) DESC )    prod_company_rank
  FROM       movie m
  INNER JOIN ratings a
  ON         m.id = a.movie_id
  WHERE      a.avg_rating > 8
  AND        m.production_company IS NOT NULL
  GROUP BY   m.production_company;
  
  --  Both Dream Warrior Pictures or National Theatre Live has most movie count of 3 each & company rank rated at 1

  -- It's ok if RANK() or DENSE_RANK() is used too
  -- Answer can be Dream Warrior Pictures or National Theatre Live or both
  -- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
  /* Output format:
+---------------+-------------------+
| genre      |  movie_count    |
+-------------------+----------------
|  thriller  |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
  -- Type your code below:
  SELECT     g.genre     AS genre,
             Count(m.id) AS movie_count
  FROM       genre g
  INNER JOIN movie m
  ON         m.id = g.movie_id
  INNER JOIN ratings r
  ON         r.movie_id = m.id
  WHERE      year = 2017
  AND        Month(date_published) = 3
  AND        country LIKE '%USA%'
  AND        total_votes > 1000
  GROUP BY   g.genre
  ORDER BY   movie_count DESC;
  
  -- Lets try to analyse with a unique problem statement.
  -- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
  /* Output format:
+---------------+-------------------+---------------------+
| title      |    avg_rating  |    genre        |
+---------------+-------------------+---------------------+
| Theeran    |    8.3      |    Thriller    |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
+---------------+-------------------+---------------------+*/
  -- Type your code below:
  SELECT     m.title      AS title,
             r.avg_rating AS avg_rating,
             g.genre      AS genre
  FROM       movie m
  INNER JOIN ratings r
  ON         r.movie_id = m.id
  INNER JOIN genre g
  ON         g.movie_id = m.id
  WHERE      m.title LIKE 'The%'
  AND        avg_rating > 8;
  
  -- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
  -- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
  -- Type your code below:
  SELECT     Count(m.id) AS movie_count
  FROM       movie m
  INNER JOIN ratings r
  ON         m.id = r.movie_id
  WHERE      (
                        date_published BETWEEN '2018-04-01' AND '2019-04-01' )
  AND        r.median_rating = 8
  GROUP BY   r.median_rating;
  
  -- movie_count = 361

  -- Once again, try to solve the problem given below.
  -- Q17. Do German movies get more votes than Italian movies?
  -- Hint: Here you have to find the total number of votes for both German and Italian movies.
  -- Type your code below:
  SELECT     country,
             Sum(total_votes) AS total_votes_count
  FROM       movie            AS m
  INNER JOIN ratings          AS r
  ON         m.id = r.movie_id
  WHERE      country = 'Germany'
  OR         country = 'Italy'
  GROUP BY   country;
  
  -- Answer is Yes

  /* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table.
Let’s begin by searching for null values in the tables.*/
  -- Segment 3:
  -- Q18. Which columns in the names table have null values??
  /*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls  |  height_nulls  |date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|    0    |      123    |         1234      |     12345         |
+---------------+-------------------+---------------------+----------------------+*/
  -- Type your code below:
SELECT Sum(
         CASE
                WHEN name IS NULL THEN 1
                ELSE 0
         end ) AS name_nulls,
         Sum(
         CASE
                WHEN height IS NULL THEN 1
                ELSE 0
         end ) AS height_nulls,
         Sum(
         CASE
                WHEN date_of_birth IS NULL THEN 1
                ELSE 0
         end ) AS date_of_birth_nulls,
         Sum(
         CASE
                WHEN known_for_movies IS NULL THEN 1
                ELSE 0
         end ) AS known_for_movies_nulls
  FROM   names;
  
  -- Columns other than name have null values

  /* There are no Null value in the column 'name'.
The director is the most important person in a movie crew.
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/
  -- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
  -- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
  /* Output format:
+---------------+-------------------+
| director_name  |  movie_count    |
+---------------+-------------------|
|James Mangold  |    4      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
  -- Type your code below:
WITH top_genre
AS
  (
             SELECT     g.genre,
                        count(g.movie_id) AS movie_count
             FROM       genre g
             INNER JOIN ratings r
             ON         g.movie_id = r.movie_id
             WHERE      r.avg_rating > 8
             GROUP BY   genre
             ORDER BY   movie_count DESC
             LIMIT      3 ),-- Drama,Action,Comedy are top 3
  top_director
AS
  (
             SELECT     n.name                                         AS director_name,
                        count(d.movie_id)                              AS movie_count,
                        rank() over( ORDER BY count(d.movie_id) DESC )    director_rank
             FROM       names n
             INNER JOIN director_mapping d
             ON         n.id = d.name_id
             INNER JOIN ratings r
             ON         r.movie_id = d.movie_id
             INNER JOIN genre g
             ON         g.movie_id = d.movie_id,
                        top_genre
             WHERE      r.avg_rating > 8
             AND        g.genre IN (top_genre.genre)
             GROUP BY   n.name
             ORDER BY   movie_count DESC )
  SELECT director_name,
         movie_count
  FROM   top_director
  LIMIT  3;
  
  /* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'.
Now, let’s find out the top two actors.*/
  -- Q20. Who are the top two actors whose movies have a median rating >= 8?
  /* Output format:
+---------------+-------------------+
| actor_name  |  movie_count    |
+-------------------+----------------
|Christain Bale  |    10      |
|  .      |    .      |
+---------------+-------------------+ */
  -- Type your code below:
  SELECT     n.name      AS actor_name,
             Count(m.id) AS movie_count
  FROM       movie m
  INNER JOIN role_mapping r1
  ON         m.id = r1.movie_id
  INNER JOIN names n
  ON         n.id = r1.name_id
  INNER JOIN ratings r
  ON         r.movie_id = m.id
  WHERE      r.median_rating >= 8
  AND        r1.category ='Actor'
  GROUP BY   name
  ORDER BY   movie_count DESC
  LIMIT      2;
  
  -- Mammootty and Mohanlal made it to top 2 actors.

  /* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again.
RSVP Movies plans to partner with other global production houses.
Let’s find out the top three production houses in the world.*/
  -- Q21. Which are the top three production houses based on the number of votes received by their movies?
  /* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count      |    prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers    |    830      |    1          |
|  .        |    .      |      .      |
|  .        |    .      |      .      |
+-------------------+-------------------+---------------------+*/
  -- Type your code below:
  SELECT     production_company,
             Sum(total_votes)                              AS vote_count,
             Rank() over( ORDER BY sum(total_votes) DESC ) AS prod_comp_rank
  FROM       movie                                         AS m
  INNER JOIN ratings                                       AS r
  ON         r.movie_id = m.id
  GROUP BY   production_company
  ORDER BY   vote_count DESC
  LIMIT      3;
  
  -- Top three production houses based on the votes received are Marvel Studios followed by Twentieth Century Fox and Warner Bros. respectively

  /*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.
Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience.
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel.
Let’s find who these actors could be.*/
  -- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
  -- Note: The actor should have acted in at least five Indian movies.
  -- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
  /* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name | total_votes  | movie_count    | actor_avg_rating   |actor_rank    |
+---------------+-------------------+---------------------+----------------------+-----------------+
| Yogi Babu |   3455 |        11    |    8.42        |  1        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
  -- Type your code below:
  SELECT     n.name                                                                                            AS actor_name,
             Sum(r.total_votes)                                                                                AS total_votes,
             Count(r.movie_id)                                                                                 AS movie_count,
             Round(Sum(avg_rating*total_votes)/Sum(total_votes),2)                                             AS actor_avg_rating,
             Rank() over(ORDER BY round(sum(avg_rating*total_votes)/sum(total_votes),2) DESC,total_votes DESC) AS actor_rank
  FROM       names n
  INNER JOIN role_mapping rm
  ON         n.id = rm.name_id
  INNER JOIN ratings r
  ON         rm.movie_id = r.movie_id
  INNER JOIN movie m
  ON         m.id = r.movie_id
  WHERE      rm.category="actor"
  AND        m.country="India"
  GROUP BY   n.name
  HAVING     count(r.movie_id) >= 5;
  
  -- Top actor is Vijay Sethupathi

  -- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings?
  -- Note: The actresses should have acted in at least three Indian movies.
  -- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
  /* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name | total_votes  | movie_count    | actress_avg_rating   |actress_rank    |
+---------------+-------------------+---------------------+----------------------+-----------------+
| Tabu  |   3455 |        11    |    8.42        |  1        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
  -- Type your code below:
SELECT     name AS actress_name,
             total_votes,
             Count(m.id)                                                                                         AS movie_count,
             Round(Sum(avg_rating*total_votes)/Sum(total_votes),2)                                               AS actress_avg_rating,
             Rank() over (ORDER BY round(sum(avg_rating*total_votes)/sum(total_votes),2) DESC, total_votes DESC) AS actress_rank
  FROM       names n
  INNER JOIN role_mapping ro
  ON         n.id=ro.name_id
  INNER JOIN movie m
  ON         ro.movie_id=m.id
  INNER JOIN ratings r
  ON         m.id=r.movie_id
  WHERE      country LIKE '%India%'
  AND        languages LIKE '%Hindi%'
  AND        ro.category='Actress'
  GROUP BY   name
  HAVING     count(m.id) >= 3
  LIMIT      5;

  
  /* Taapsee Pannu tops with average rating 7.74.

Now let us divide all the thriller movies in the following categories and find out their numbers.*/
  /* Q24. Select thriller movies as per avg rating and classify them in the following category:
Rating > 8: Superhit movies
Rating between 7 and 8: Hit movies
Rating between 5 and 7: One-time-watch movies
Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
  -- Type your code below:
SELECT     title,
             avg_rating,
             CASE
                        WHEN avg_rating > 8 THEN 'Superhit movies'
                        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
                        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
                        ELSE 'Flop movies'
             end AS rating_category
  FROM       movie m
  INNER JOIN ratings r
  ON         m.id=r.movie_id
  INNER JOIN genre g
  ON         r.movie_id=g.movie_id
  WHERE      genre='thriller';
  
  /* Until now, you have analysed various tables of the data set.
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/
  -- Segment 4:
  -- Q25. What is the genre-wise running total and moving average of the average movie duration?
  -- (Note: You need to show the output table in the question.)
  /* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre   | avg_duration |running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
| comdy  |   145  |        106.2   |    128.42       |
|  .  |   .  |        .    |    .        |
|  .  |   .  |        .    |    .        |
|  .  |   .  |        .    |    .        |
+---------------+-------------------+---------------------+----------------------+*/
  -- Type your code below:
SELECT     genre,
             Round(Avg(duration),2)                           AS avg_duration,
             Sum(Round(Avg(duration),2)) over(ORDER BY genre) AS running_total_duration,
             avg(round(avg(duration),2)) over(ORDER BY genre) AS moving_avg_duration
  FROM       movie m
  INNER JOIN genre g
  ON         m.id = g.movie_id
  GROUP BY   genre;
  
  -- Round is good to have and not a must have; Same thing applies to sorting
  -- Let us find top 5 movies of each year with top 3 genres.
  -- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres?
  -- (Note: The top 3 genres would have the most number of movies.)
  /* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre   | year   | movie_name    |worldwide_gross_income|movie_rank    |
+---------------+-------------------+---------------------+----------------------+-----------------+
| comedy  |   2017 |        indian   |    $103244842      |  1        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
  -- Type your code below:
  -- Top 3 Genres based on most number of movies
WITH top3_genre
AS
(
SELECT
genre,
COUNT(movie_id) as movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
), movie_summary
AS
  (
             SELECT     genre,
                        year,
                        title                                                                                                                                      AS movie_name,
                        cast(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                                     AS worlwide_gross_income ,
                        dense_rank() over(partition BY year ORDER BY cast(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC ) AS movie_rank
             FROM       movie                                                                                                                                      AS m
             INNER JOIN genre                                                                                                                                      AS g
             ON         m.id = g.movie_id
             WHERE      genre IN
                        (
                               SELECT genre
                               FROM   top3_genre)
             GROUP BY   movie_name )
  SELECT   *
  FROM     movie_summary
  WHERE    movie_rank<=5
  ORDER BY year;
  
  -- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
  -- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
  /* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count  |  prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers  |  830   |  1       |
| .    |  .   |   .    |
| .    |  .   |   .    |
+-------------------+-------------------+---------------------+*/
  -- Type your code below:
  SELECT     production_company,
             Count(id)                               AS movie_count,
             Rank() over ( ORDER BY count(id) DESC ) AS prod_comp_rank
  FROM       movie m
  INNER JOIN ratings r
  ON         m.id = r.movie_id
  WHERE      median_rating >= 8
  AND        production_company IS NOT NULL
  AND        position(',' IN languages)> 0
  GROUP BY   production_company
  LIMIT      2;
  
  -- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
  -- If there is a comma, that means the movie is of more than one language
  -- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
  /* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name | total_votes  | movie_count    |actress_avg_rating  |actress_rank    |
+---------------+-------------------+---------------------+----------------------+-----------------+
| Laura Dern |   1016 |        1    |    9.60        |  1        |
|  .  |   .  |        .    |    .        |  .        |
|  .  |   .  |        .    |    .        |  .        |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
  -- Type your code below:
  SELECT     name                                                  AS actress_name,
             Sum(total_votes)                                      AS total_votes,
             Count(m.id)                                           AS movie_count,
             Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
             Rank() over ( ORDER BY count(m.id) DESC )             AS actress_rank
  FROM       names n
  INNER JOIN role_mapping r
  ON         n.id = r.name_id
  INNER JOIN movie m
  ON         r.movie_id = m.id
  INNER JOIN genre g
  ON         m.id = g.movie_id
  INNER JOIN ratings ra
  ON         m.id = ra.movie_id
  WHERE      r.category = 'actress'
  AND        g.genre = 'drama'
  AND        avg_rating > 8
  GROUP BY   name
  LIMIT      3;
  
  /* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations
Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id | director_name | number_of_movies  | avg_inter_movie_days | avg_rating | total_votes  | min_rating | max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967  | A.L. Vijay  |   5    |        177    |    5.65     | 1754    | 3.7  | 6.9   |  613    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
--------------------------------------------------------------------------------------------*/
  -- Type you code below:
WITH summary
AS
  (
             SELECT     d.name_id,
                        name,
                        d.movie_id,
                        duration,
                        r.avg_rating,
                        total_votes,
                        m.date_published,
                        lead(date_published, 1) over( partition BY d.name_id ORDER BY date_published, movie_id ) AS next_date_published
             FROM       director_mapping                                                                         AS d
             INNER JOIN names                                                                                    AS n
             ON         n.id = d.name_id
             INNER JOIN movie AS m
             ON         m.id = d.movie_id
             INNER JOIN ratings AS r
             ON         r.movie_id = m.id ),
  top_director
AS
  (
         SELECT *,
                datediff( next_date_published, date_published ) AS date_difference
         FROM   summary )
  SELECT   name_id                          AS director_id,
           name                             AS director_name,
           count(movie_id)                  AS number_of_movies,
           round( avg(date_difference), 2 ) AS avg_inter_movie_days,
           avg_rating,
           sum(total_votes) AS total_votes,
           min(avg_rating)  AS min_rating,
           max(avg_rating)  AS max_rating,
           sum(duration)    AS total_duration
  FROM     top_director
  GROUP BY director_id
  ORDER BY count(movie_id) DESC
  LIMIT    9;
