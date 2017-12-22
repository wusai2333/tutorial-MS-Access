-- Q1
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
select name, grade
from Highschooler
where ID not in (
    select ID1 from Likes
    UNION
    select ID2 from Likes
)
order by grade, name;

-- Q2
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, (
    select * from Likes
    except
    select Likes.ID1, Likes.ID2
    from Likes, Friend
    where Friend.ID1 = Likes.ID1 and Friend.ID2 = Likes.ID2
) as LikeNotFriend
where F1.ID1 = LikeNotFriend.ID1
and F2.ID1 = LikeNotFriend.ID2
and F1.ID2 = F2.ID2
and H1.ID = LikeNotFriend.ID1
and H2.ID = LikeNotFriend.ID2
and H3.ID = F1.ID2;

-- Q3
-- Find the difference between the number of students in the school and the number of different first names. 
select count(ID)-count(distinct name)
from Highschooler;

-- Q4
-- What is the average number of friends per student? (Your result should be just one number.) 
select avg(num)
from (
    select count(ID2) as num
    from Friend
    group by ID1
);

-- Q5
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
select count(distinct F1.ID2) + count(distinct F2.ID2)
from Friend F1, Friend F2, Highschooler
where name = 'Cassandra'
and ID = F1.ID1
and F2.ID1 = F1.ID2
and F2.ID1 <> ID
and F2.ID2 <> ID;

-- Q6
-- Find the name and grade of the student(s) with the greatest number of friends. 
select name, grade
from Highschooler natural join (
    select ID1 as ID
    from Friend
    group by ID1
    having count(*) >= all(select count(*)
                            from Friend
                            group by ID1)
);