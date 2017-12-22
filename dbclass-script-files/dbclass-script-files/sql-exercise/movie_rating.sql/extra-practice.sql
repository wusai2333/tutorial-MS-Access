-- Q1
-- Find the names of all reviewers who rated Gone with the Wind. 
select distinct name
from (Movie natural join Rating) natural join Reviewer
where title = 'Gone with the Wind'
order by name;

-- Q2
-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from (Movie natural join Rating) natural join Reviewer
where name = director;

-- Q3
-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

select name as names
from Reviewer
union
select title as names
from Movie 
order by names;

-- Q4
-- Find the titles of all movies not reviewed by Chris Jackson. 

select distinct title
from Movie
except
select distinct title
from (Movie natural join Rating) natural join Reviewer
where name = 'Chris Jackson';

-- Q5
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
select distinct R1.name, R2.name
from (Reviewer natural join Rating) R1, (Reviewer natural join Rating) R2
where R1.name < R2.name and R1.mID = R2.mID;

-- Q6
-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from ((Movie natural join Rating) natural join Reviewer), (
    select min(stars) as min_rating
    from Rating
    )
where stars = min_rating;

