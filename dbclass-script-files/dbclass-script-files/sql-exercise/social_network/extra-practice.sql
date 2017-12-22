-- Q1
-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, (
    select Likes.ID1, Likes.ID2
    from Likes
    where Likes.ID2 not in (select ID1 from Likes)
    ) as  L , Highschooler H2
where H1.ID = L.ID1 and H2.ID = L.ID2;


-- Q2
-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from (Highschooler join Likes on (ID = ID1)) H1, (Highschooler join Likes on (ID = ID1)) H2, Highschooler H3
where H1.ID2 = H2.ID and H2.ID2 = H3.ID and H3.ID <> H1.ID;

-- Q3
-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
select name, grade
from Highschooler H1
where not exists (
    select ID 
    from Highschooler H2, Friend F
    where H1.ID = F.ID1 and H2.ID = F.ID2 and H1.grade = H2.grade
);