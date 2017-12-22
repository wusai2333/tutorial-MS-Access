-- Q1
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
delete from highschooler
where grade = 12;

-- Q2
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. delete from Likes
where ID1 in (
    select ID1 from (
        select L.ID1, L.ID2
        from Friend as F, Likes as L
        where F.ID1 = L.ID1 and F.ID2 = L.ID2
        except
        select L.ID1, L.ID2
        from Likes L, Likes L2
        where L.ID1 = L2.ID2
           and L.ID2 = L2.ID1
        )
);

-- Q3
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 

insert into Friend
    select distinct A.ID1, B.ID2
    from Friend A, Friend B
    where A.ID2 = B.ID1 and B.ID2 <> A.ID1 and A.ID1
    and not exists (select * from Friend where A.ID1 = Friend.ID1 and B.ID2 = Friend.ID2);


insert into Friend
    select distinct A.ID1, B.ID2
    from Friend A, Friend B
    where A.ID2 = B.ID1 and B.ID2 <> A.ID1 and A.ID1
    except
    select * from Friend;
    