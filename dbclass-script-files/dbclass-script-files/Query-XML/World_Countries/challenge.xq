(: Q1 :)
(: Return the names of all countries that have at least three cities with population greater than 3 million.  :)
let $path := doc("countries.xml")//country
for $c in $path
where count($c/city[population > 3000000]) >= 3
return $c/data(@name)

(: Q2 :)
(:Create a list of French-speaking and German-speaking countries. The result should take the form:)
let $path := doc("countries.xml")//country
return <result>
            <French>
            {for $c in $path where $c/language = "French" return <country>{$c/data(@name)} </country>}
            </French>
            <German>
            {for $c in $path where $c/language = "German" return <country>{$c/data(@name)} </country>}
            </German>
        </result>

(: Q3 :)
(: Return the names of all countries containing a city such that some other country has a city of the same name. (Hint: You might want to use the "preceding" and/or "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)
let $path := doc("countries.xml")//country
for $c in $path
where $c/preceding::country/city/name = $c/city/name or $c/following::country/city/name = $c/city/name
return $c/data(@name)

(: Q4 :)
(: Return the average number of languages spoken in countries where Russian is spoken. :)
let $path := doc("countries.xml")//country
return avg( for $c in $path
            where $c/language = "Russian"
            return count($c/language))

let $path := doc("countries.xml")//country
return avg($path[language = "Russian"]/count(language))

(: Q5 :)
(: Return all country-language pairs where the language is spoken in the country and the name of the country textually contains the language name. Return each pair as a country element with language attribute, e.g.,
<country language="French">French Guiana</country>:)
let $path := doc("countries.xml")//country
for $c in $path
    for $l in $c/language
        where contains(data($c/@name), $l)
    return <country language="{$l}">{$c/data(@name)}</country>

(: Q6 :)
(: Return all countries that have at least one city with population greater than 7 million. For each one, return the country name along with the cities greater than 7 million, in the format:
<country name="country-name">
  <big>city-name</big>
  <big>city-name</big>
  ...
</country>:)
let $countries := doc("countries.xml")//country
for $c in $countries
where $c/city/population > 7000000
return <country name = "{$c/data(@name)}">
    {for $city in $c/city
    where $city/population > 7000000
    return <big>{$city/name}</big>}
    </country>

(: Q7 :)
(: Return all countries where at least one language is listed, but the total percentage for all listed languages is less than 90%. Return the country element with its name attribute and its language subelements, but no other attributes or subelements. :)
let $countries := doc("countries.xml")//country
for $c in $countries[language]
where sum($c/language/data(@percentage)) < 90
return <country>{$c/@name}{$c/language}</country>

(: Q8 :)
(: Return all countries where at least one language is listed, and every listed language is spoken by less than 20% of the population. Return the country element with its name attribute and its language subelements, but no other attributes or subelements. :)
let $countries := doc("countries.xml")//country
for $c in $countries[language]
where every $l in $c/language satisfies $l/@percentage < 20
return <country>{$c/@name}{$c/language}</country>

(: Q9 :)
(: Find all situations where one country's most popular language is another country's least popular, and both countries list more than one language. (Hint: You may need to explicitly cast percentages as floating-point numbers with xs:float() to get the correct answer.) Return the name of the language and the two countries, each in the format:
<LangPair language="lang-name">
  <MostPopular>country-name</MostPopular>
  <LeastPopular>country-name</LeastPopular>
</LangPair>:)
let $countries := doc("countries.xml")//country[count(language) > 1]
for $c1 in $countries
 for $c2 in $countries
 	let $most_popular := (for $l1 in $c1/language where xs:float($l1/data(@percentage)) = xs:float(max($c1/language/data(@percentage))) return $l1)
    let $least_popular := (for $l2 in $c2/language where xs:float($l2/data(@percentage)) = xs:float(min($c2/language/data(@percentage))) return $l2)
	for $l1 in $most_popular
    for $l2 in $least_popular
        where $l1 = $l2
        return <LangPair language="{$l1}">
                <MostPopular>{$c1/data(@name)}</MostPopular>
                <LeastPopular>{$c2/data(@name)}</LeastPopular>
                </LangPair>
(:another version:)
let $countries := doc('countries.xml')/countries/country[count(language) > 1],
  $most_popular := 
    for $c in $countries
      for $l in $c/language
        where xs:float($l/data(@percentage)) = xs:float(max($c/language/data(@percentage)))
        return $l,

  $least_popular := 
    for $c in $countries
      for $l in $c/language
        where xs:float($l/data(@percentage)) = xs:float(min($c/language/data(@percentage)))
        return $l

  for $m in $most_popular
    for $l in $least_popular
      where data($m) = data($l)
        return
          <LangPair language="{data($l)}">
            <MostPopular>{$m/parent::country/data(@name)}</MostPopular>
            <LeastPopular>{$l/parent::country/data(@name)}</LeastPopular>
          </LangPair>

(: Q10 :)
(: For each language spoken in one or more countries, create a "language" element with a "name" attribute and one "country" subelement for each country in which the language is spoken. The "country" subelements should have two attributes: the country "name", and "speakers" containing the number of speakers of that language (based on language percentage and the country's population). Order the result by language name, and enclose the entire list in a single "languages" element. For example, your result might look like:
<languages>
  ...
  <language name="Arabic">
    <country name="Iran" speakers="660942"/>
    <country name="Saudi Arabia" speakers="19409058"/>
    <country name="Yemen" speakers="13483178"/>
  </language>
  ...
</languages>:)
let $countries := doc("countries.xml")//country[language]
let $languages := doc("countries.xml")//language
let $languages_name := distinct-values($languages)
return <languages>
        {
            for $l_name in $languages_name
            order by $l_name
            return <language name = "{$l_name}">
                {
                    for $l in $languages
                    where data($l) = $l_name
                    return <country name="{data($l/parent::country/@name)}" speakers="{xs:int($l/parent::country/@population * $l/@percentage div 100)}"/>
                }
                </language>
        }
        </languages>
