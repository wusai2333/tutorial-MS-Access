(: Q1 :)
(: Return all Title elements (of both departments and courses). :)
doc("courses.xml")//Title

let $path := doc("courses.xml")
return $path//Title

(: Q2 :)
(: Return last names of all department chairs. :)
doc("courses.xml")//Chair//Last_Name

(: Q3 :)
(: Return titles of courses with enrollment greater than 500. :)
doc("courses.xml")//Course[@Enrollment > 500]/Title

let $path := doc("courses.xml")
return $Path//Course[@Enrollment > 500]/Title

(: Q4 :)
(: Return titles of departments that have some course that takes "CS106B" as a prerequisite. :)
let $path := doc("courses.xml")
return $path//Department[Course/Prerequisites/Prereq = "CS106B"]/Title

(: Q5 :)
(:Return last names of all professors or lecturers who use a middle initial. Don't worry about eliminating duplicates. :)
doc("courses.xml")//(Professor|Lecturer)/Middle_Initial/parent::*/Last_Name

let $path := doc("courses.xml")
return $path//Middle_Initial/parent::*/Last_Name

(: Q6 :)
let $path := doc("courses.xml")
return count($path//Course[contains(Description, "Cross-listed")])

(: Q7 :)
(:Return the average enrollment of all courses in the CS department. :)
let $path := doc("courses.xml")//Course[parent::*/Title = "Computer Science"]/@Enrollment
return avg($path)

(: Q8 :)
(:Return last names of instructors teaching at least one course that has "system" in its description and enrollment greater than 100. :)
let $path := doc("courses.xml")//Course[contains(Description, "system") and @Enrollment > 100]/Instructors//Last_Name
return $path
