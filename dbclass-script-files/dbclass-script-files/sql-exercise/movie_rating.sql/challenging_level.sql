-- Q1
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
select title, spread
from Movie natural join (
    select mID, max(stars)-min(stars) as spread
    from Rating
    group by mID)
order by spread DESC, title;

-- Q2
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
select avg(before_80.group_avg) - avg(post_80.group_avg)
from (
    select avg(stars) as group_avg
    from Rating natural join Movie
    where year <= 1980
    group by mID
) as before_80, (
    select avg(stars) as group_avg
    from Rating natural join Movie
    where year > 1980
    group by mID
) as post_80;

-- Q3
-- Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
-- with count
select title, director
from Movie
group by director
having count(*) > 1
order by director, title;

-- without count
select M1.title, M1.count
from Movie M1, Movie M2
where M1.director = M2.director and M1.title <> M2.title
order by director, title;

-- Q4
-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select title, group_avg
from Movie, (
    select max(group_avg) as max_avg
    from (
        select mID, avg(stars), as group_avg
        from Rating join Movie using (mID)
        group by mID
    )
) as MaxRating, (
    select mID, avg(stars) as group_avg
    from Rating join Moive using(mID)
    group by mID
) as GroupRating
where GroupRating.group_avg = MaxRating.max_avg
and Movie.mID = GroupRating.mID;

-- Q5
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
select title, group_avg
from Movie, (
    select min(group_avg) as min_avg
    from (
        select mID, avg(stars), as group_avg
        from Rating join Movie using (mID)
        group by mID
    )
) as MaxRating, (
    select mID, avg(stars) as group_avg
    from Rating join Moive using(mID)
    group by mID
) as GroupRating
where GroupRating.group_avg = MaxRating.min_avg
and Movie.mID = GroupRating.mID;

-- Q6
-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
select director, title, max(stars) as max_rating
from Movie natural join Rating
where director is not NULL
group by director;
