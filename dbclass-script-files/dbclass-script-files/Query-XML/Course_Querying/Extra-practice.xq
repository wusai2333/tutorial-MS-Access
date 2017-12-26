(: Q1 :)
(: Return the course number of the course that is cross-listed as "LING180". :)
let $path := doc("courses.xml"), $courses := $path//Course
return $courses[contains(Description, "LING180")]/data(@Number)

(: Q2 :)
(: Return course numbers of courses taught by an instructor with first name "Daphne" or "Julie". :)
let $path := doc("courses.xml"), $courses := $path//Course
return $courses[Instructor//First_Name = "Daphne" or Instructor//First_Name = "Julie"]/data(@Number)

(: Q3 :)
(: Return titles of courses that have both a lecturer and a professor as instructors. Return each title only once. :)
let $path := doc("courses.xml"), $courses := $path//Course
for $c in $courses
where count($c/Instructors/Professor) != 0 and count($c/Instructors/Lecturer) != 0 and $c/Title != $c/following::*/Title
return $c/Title