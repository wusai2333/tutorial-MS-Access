(: Q1 :)
(: Return the title of the course with the largest enrollment. :)
let $path := doc("courses.xml")
for $c in $path//Course
    where $c/@Enrollment = max($path//Course/@Enrollment)
return $c/Title

(: Q2 :)
(:Return course numbers of courses that have the same title as some other course. (Hint: You might want to use the "preceding" and "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.):)
let $path := doc("courses.xml")
for $c in $path//Course
    where $c/Title = $c/following::*/Title or $c/Title = $c/preceding::*/Title
return $c/data(@Number)

(: Q3 :)
(:Return the number (count) of courses that have no lecturers as instructors. :)
let $path := doc("courses.xml")//Course
return count( for $c in $path
                    where count($c/Instructors/Lecturer) = 0
                    return $c)

(: Q4 :)
(:Return titles of courses taught by the chair of a department. For this question, you may assume that all professors have distinct last names. :)
let $path := doc("courses.xml")//Course
for $c in $path
    where $c/Instructors//Last_Name = $c/parent::Department/Chair//Last_Name
return $c/Title

(: Q5 :)
(:Return titles of courses taught by a professor with the last name "Ng" but not by a professor with the last name "Thrun". :)
let $path := doc("courses.xml")//Course
for $c in $path
where $c//Professor/Last_Name = "Ng" and count($c//Professor[Last_Name = "Thrun"]) = 0
return $c/title

let $path := doc("courses.xml")//Course
for $c in (
    for $c1 in $path
        where every $name in $c1//Professor/Last_Name satisfies $name != "Thrun"
    return $c1
    )
where $c//Professor/Last_Name = "Ng"
return $c/Title

(: Q6 :)
(: Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite. :)
let $path := doc("courses.xml")//Course
for $c in $path
for $c2 in $path
    where $c//Prerequisites/data(Prereq) = $c2/data(@Number) and count($c2//Instructors/*[First_Name = "Eric" and Last_Name = "Roberts"]) != 0
return $c/data(@Number)

(: Q7 :)
(: Create a summary of CS classes: List all CS department courses in order of enrollment. For each course include only its Enrollment (as an attribute) and its Title (as a subelement). :)
<Summary>
{let $path := doc("courses.xml")//Course[parent::*/data(@Code) = "CS"]
for $c in $path
order by xs:int($c/@Enrollment)
return 
        <Course>
        {$c/@Enrollment}
        {$c/Title}
        </Course>
        }
</Summary>

(: Q8 :)
(:Return a "Professors" element that contains as subelements a listing of all professors in all departments, sorted by last name with each professor appearing once. The "Professor" subelements should have the same structure as in the original data. For this question, you may assume that all professors have distinct last names. Watch out -- the presence/absence of middle initials may require some special handling. (This problem is quite challenging; congratulations if you get it right.) 
:)
let $path := doc("courses.xml"), $professors := $path//Professor

let $distinct_prof := (for $p in $professors 
				where count($p/preceding::*[Last_Name = $p/Last_Name]) = 0 and count($p/preceding::*[First_Name = $p/First_Name]) = 0 
				return $p)

return <Professors> 
	{for $d in $distinct_prof order by $d/data(Last_Name) return $d}
	</Professors>

let $path := doc("courses.xml"), $professors := $path//Professor
(: another version :)
let $distinct_prof := (
	$professors except (
		for $p in $professors
			where ($p/Last_Name = $p/following::*/Last_Name and $p/First_Name = $p/following::*/First_Name)
			return $p
		)
	)

return <Professors> 
	{for $d in $distinct_prof order by $d/data(Last_Name) return $d}
	</Professors>

<?xml version="1.0" encoding="UTF-8"?>
<Professors>
   <Professor>
          <First_Name>Alex</First_Name>
          <Middle_Initial>S.</Middle_Initial>
          <Last_Name>Aiken</Last_Name>    
        </Professor>
   <Professor>
          <First_Name>William</First_Name>
          <Middle_Initial>J.</Middle_Initial>
          <Last_Name>Dally</Last_Name>
        </Professor>
   <Professor>
        <First_Name>Mark</First_Name>
        <Middle_Initial>A.</Middle_Initial>
        <Last_Name>Horowitz</Last_Name>
      </Professor>
   <Professor>
          <First_Name>Dan</First_Name>
          <Last_Name>Jurafsky</Last_Name>    
        </Professor>
   <Professor>
          <First_Name>Daphne</First_Name>
          <Last_Name>Koller</Last_Name>    
        </Professor>
   <Professor>
        <First_Name>Beth</First_Name>
        <Last_Name>Levin</Last_Name>    
      </Professor>
   <Professor>
          <First_Name>Subhasish</First_Name>
          <Last_Name>Mitra</Last_Name>
        </Professor>
   <Professor>
          <First_Name>Andrew</First_Name>
          <Last_Name>Ng</Last_Name>    
        </Professor>
   <Professor>
          <First_Name>Oyekunle</First_Name>
          <Last_Name>Olukotun</Last_Name>
        </Professor>
   <Professor>
          <First_Name>Eric</First_Name>
          <Last_Name>Roberts</Last_Name>
        </Professor>
   <Professor>
          <First_Name>Mehran</First_Name>
          <Last_Name>Sahami</Last_Name>
        </Professor>
   <Professor>
          <First_Name>Sebastian</First_Name>
          <Last_Name>Thrun</Last_Name>    
        </Professor>
   <Professor>
          <First_Name>Jennifer</First_Name>
          <Last_Name>Widom</Last_Name>    
        </Professor>
</Professors>

(: Question 9 :)
(: Expanding on the previous question, create an inverted course listing: Return an :)
(: "Inverted_Course_Catalog" element that contains as subelements professors together :)
(: with the courses they teach, sorted by last name. You may still assume that all professors :)
(: have distinct last names. The "Professor" subelements should have the same structure :)
(: as in the original data, with an additional single "Courses" subelement under Professor, :)
(: containing a further "Course" subelement for each course number taught by that professor. :)
(: Professors who do not teach any courses should have no Courses subelement at all. :)
let $path := doc("courses.xml"), $professors := $path//Professor

let $distinct_prof := (for $p in $professors 
				where count($p/preceding::*[Last_Name = $p/Last_Name]) = 0 and count($p/preceding::*[First_Name = $p/First_Name]) = 0 
				return $p)

let $courses := $path//Course
return <Inverted_Course_Catalog> 
	{
        for $p in $distinct_prof
        order by $p/Last_Name
        return <Professor>
        {$p/*}
        {
            if ($courses//Professor = $p)
            then (
                <Courses> {
                    for $c in $courses
                    where $c//Professor = $p
                    return <Course> {$c/@Number} {$c/Title} </Course>
                }
                </Courses>
            ) else ()
        }
        </Professor>
    }
	</Inverted_Course_Catalog>


