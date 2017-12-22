-- dbtext: SQLite; DB name = movie_rating.db

-- Q1
-- Find the titles of all movies directed by Steven Spielberg. 
Select title
from Movie
where director = 'Steven Spielberg';

-- Q2
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
Select distinct year
from Movie natural join Rating
where stars = 4 or stars = 5;

-- Q3
-- Find the titles of all movies that have no ratings. 
select title
from Movie
where mID not in (select mID from Rating);

-- Q4
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
select name
from Reviewer natural join Rating
where ratingDate is NULL;

-- Q5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
select name, title, stars, ratingDate
from (Reviewer natural join Rating) natural join Movie
order by name, title;

-- Q6
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select distinct name, title
from (Movie natural join Rating) natural join Reviewer
where rID in (select rID from
           Rating R1 join Rating R2 using(rID, mID)
           where  R1.ratingDate < R2.ratingDate and R1.stars < R2.stars);


-- Q7
-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select title, max(stars)
from Movie natural join Rating
group by mID
order by title;

-- Q8
-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select title, avg(stars) as avgRating
from Movie natural join Rating
group by mID
order by avg(stars) desc, title;

-- Q9
-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from Reviewer natural join Rating
group by rID
having count(*) >= 3;

select name
from Reviewer
where rID in (
    select R1.rID from Rating R1, Rating R2, Rating R3
    where R1.rID = R2.rID and (R1.mID <> R2.mID or R1.ratingDate <> R2.ratingDate)
        and R1.rID = R3.rID and (R1.mID <> R3.mID or R1.ratingDate <> R3.ratingDate)
        and (R2.mID <> R3.mID or R2.ratingDate <> R3.ratingDate) );