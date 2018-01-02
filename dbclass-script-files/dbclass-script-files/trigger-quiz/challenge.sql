-- Q1
-- Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too. Don't worry about updates to the Friend table. 
CREATE TRIGGER F1_del
after delete on Friend
for each row
when exists (select * from friend
                where ID1 = Old.ID2 and ID2 = Old.ID1)
BEGIN
    delete from Friend
    where ID1 = Old.ID2 and ID2 = Old.ID1;
end

|
create trigger F2_insert
after insert on Friend
for each row
BEGIN
    insert into Friend values(New.ID2, New.ID1);
end;


-- Q2
-- Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends. 
create trigger Graduation
after update of grade on Highschooler
for each row
when new.grade > 12
begin
    delete from Highschooler
    where ID = new.ID;
end

|

create trigger Upgrade
after update of grade on Highschooler
for each row
when New.grade = Old.grade + 1
begin
    update Highschooler
    set grade = grade + 1
    where ID in (select ID2 from Friend 
                where ID1 = New.ID);
end;

-- Q3
-- Write a trigger to enforce the following behavior: 
-- If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. 
-- Don't forget to delete the friendship in both directions, and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed.
create trigger LikeAndFriendship
after update of ID2 on Likes
for each row
when Old.ID1 = New.ID1 and Old.ID2 <> New.ID2
BEGIN
    delete from Friend
    where (Friend.ID1 = Old.ID2 and Friend.ID2 = New.ID2)
    or (Friend.ID1 = New.ID2 and Friend.ID2 = Old.ID2);
end;