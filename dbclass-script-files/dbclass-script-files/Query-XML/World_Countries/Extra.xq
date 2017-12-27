(: Q1 :)
(: Return the names of all countries with population greater than 100 million. :)
doc("countries.xml")//country[@population > 100000000]/data(@name)

(: Q2 :)
(: Return the names of all countries where a city in that country contains more than one-third of the country's population. :)
let $countries := doc("countries.xml")//country
for $c in $countries
    where $c/city/population > $c/@population div 3
    return $c/data(@name)

(: Q3 :)
(:Return the population density of Qatar. Note: Since the "/" operator has its own meaning in XPath and XQuery, the division operator is "div". To compute population density use "(@population div @area)".:)
let $Qatar := doc("countries.xml")//country[@name = "Qatar"]
return $Qatar/@population div $Qatar/@area\

(: Q4 :)
(: Return the names of all countries whose population is less than one thousandth that of some city (in any country). :)
let $countries := doc("countries.xml")//country
let $most_p_of_city := max($countries//city/population)
for $c in $countries
    where $c/@population < $most_p_of_city div 1000
    return $c/data(@name)

(: Q5 :)
(: Return all city names that appear more than once, i.e., there is more than one city with that name in the data. Return only one instance of each such city name. (Hint: You might want to use the "preceding" and/or "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)
let $cities := doc("countries.xml")//city
for $c in $cities
    where $c/name = $c/following::city/name
    return $c/name

(: Q6 :)
(: Return the names of all countries containing a city such that some other country has a city of the same name. (Hint: You might want to use the "preceding" and/or "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)
let $countries := doc("countries.xml")//country
for $c in $countries
      where $c/city/name = $c/following::*/city/name or $c/city/name = $c/preceding::*/city/name
      return $c/data(@name)

(: Q7 :)
(: Return the names of all countries whose name textually contains a language spoken in that country. For instance, Uzbek is spoken in Uzbekistan, so return Uzbekistan. (Hint: You may want to use ".", which refers to the "current element" within an XPath expression.) :)
let $countries := doc("countries.xml")//country
for $c in $countries
    where some $l in $c/language satisfies contains($c/@name, $l)
    return $c/data(@name)

(: Q8 :)
(: Return the names of all countries in which people speak a language whose name textually contains the name of the country. For instance, Japanese is spoken in Japan, so return Japan. (Hint: You may want to use ".", which refers to the "current element" within an XPath expression.) :)
let $countries := doc("countries.xml")//country
for $c in $countries
    where some $l in $c/language satisfies contains($l, $c/@name)
    return $c/data(@name)

(: Q9 :)
(: Return all languages spoken in a country whose name textually contains the language name. For instance, German is spoken in Germany, so return German. (Hint: Depending on your solution, may want to use data(.), which returns the text value of the "current element" within an XPath expression.) :)
let $countries := doc("countries.xml")//country
let $languages := $countries/language
for $l in $languages
    where contains($l/parent::country/@name, $l)
    return $l/data(.)

(: Q10 :)
(: Return all languages whose name textually contains the name of a country in which the language is spoken. For instance, Icelandic is spoken in Iceland, so return Icelandic. (Hint: Depending on your solution, may want to use data(.), which returns the text value of the "current element" within an XPath expression.) :)
let $languages := doc("countries.xml")//country/language
for $l in $languages
    where contains($l, $l/parent::country/@name)
    return $l/data(.)
(: Q11 :)
(: Return the number of countries where Russian is spoken. :)
let $Russian_spoken := doc("countries.xml")//country[language = "Russian"]
return count($Russian_spoken)

(: Q12 :)
(: Return the names of all countries for which the data does not include any languages or cities, but the country has more than 10 million people. :)
let $countries := doc("countries.xml")//country
for $c in $countries
    where count($c/language) = 0 and count($c/city) = 0 and $c/@population > 10000000
    return $c/data(@name)

(: Q13 :)
(: Return the name of the country that has the city with the highest population. (Hint: You may need to explicitly cast population numbers as integers with xs:int() to get the correct answer.) :)
let $countries := doc("countries.xml")//country
let $maxcity := max($countries/city/xs:int(population))
for $c in $countries
where $c/city/xs:int(population) = $maxcity
return $c/data(@name)