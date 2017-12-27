(: Q1 :)
(: Return the area of Mongolia. :)
let $path := doc("countries.xml")
return $path//country[@name = "Mongolia"]/data(@area)

(: Q2 :)
(: Return the names of all cities that have the same name as the country in which they are located.  :)
let $path := doc("countries.xml")
let $cities := $path//city
for $c in $cities
where $c/parent::*/@name = $c/name
return $c/name

(: Q3 :)
(: Return the average population of Russian-speaking countries. :)
let $path := doc("countries.xml")
return avg(for $c in $path//country where $c/language = "Russian" return $c/data(@population))

(: Q4 :)
(: Return the names of all countries where over 50% of the population speaks German. (Hint: Depending on your solution, you may want to use ".", which refers to the "current element" within an XPath expression.) :)
let $path := doc("countries.xml")//country
return $path//language[. = "German" and @percentage > 50]/parent::country/data(@name)

(: Q5 :)
(: Return the name of the country with the highest population. (Hint: You may need to explicitly cast population numbers as integers with xs:int() to get the correct answer.) :)
let $path := doc("countries.xml")//country
return (for $c in $path
order by -xs:int($c/@population)
return $c)[1]/data(@name)