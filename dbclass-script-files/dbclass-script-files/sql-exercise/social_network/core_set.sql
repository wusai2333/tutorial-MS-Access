-- Q1
-- Find the names of all students who are friends with someone named Gabriel. 
select distinct name
from Highschooler H, Friend F, (select ID as GID from Highschooler where name = 'Gabriel')
where (H.ID = F.ID1 and GID = F.ID2) or (H.ID = F.ID2 and GID = F.ID1);

-- Q2
-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes
where H1.ID = Likes.ID1 and H2.ID = Likes.ID2 and H1.grade - H2.grade >= 2;

-- Q3
-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, (
    select L1.ID1, L1.ID2
    from Likes L1, Likes L2
    where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1
    ) as Pair
where H1.ID = Pair.ID1 and H2.ID = Pair.ID2 and H1.name < H2.name;

-- Q4
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select name, grade
from Highschooler natural join (
    select ID1 as ID
    from Friend
    except
    select A.ID as ID
    from (Friend join Highschooler on (ID1 = ID)) A, (Highschooler join Friend on (ID2 = ID)) B
    where A.ID = B.ID1 and B.ID = A.ID2 and A.grade <> B.grade
    )
 order by grade, name;


--  Q5
-- Find the name and grade of all students who are liked by more than one other student. 
select name, grade
from Highschooler natural join (
    select ID2 as ID
    from Likes
    group by ID2
    having count(*) > 1
 );