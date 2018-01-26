-- a
select a.name, count(distinct studioID) as numStudios
from Actors a, ActedIn ai, Movie m
where a.name = ai.name and ai.title = m.title
group by a.name
order by numStudios asc

-- b
select a.name, count(m.title) as numMovies
from Actors a, ActedIn ai, Movie m
where a.name = ai.name and ai.title = m.title
group by a.name
having count(m.title) >= 2
order by numMovies desc

-- c
select s.studioName ,count(distinct a.name) as numActors
from Actors a, ActedIn ai, Movie m, Studio s
where a.name = ai.name and ai.title = m.title and m.studioID = s.studioID and m.year >= 1950 and m.year <= 1999
group by s.studioName
having count(m.title) >=14

-- d
select m.title, max(s.[duration(sec)]) as songDuration
from Movie m, Soundtrack s
where m.title = s.title and m.genre = 'action'
group by m.title

-- e
select s.studioID, s.studioName, count(distinct a.name) as numActors, count(distinct m.title) as numMovies
from Studio s, Actors a, ActedIn ai, Movie m
where s.studioID = m.studioID and a.name = ai.name and ai.title = m.title and s.est > 1930
group by s.studioID, s.studioName

-- f
select m.title, AVG(s.rank) as avgRank
from Movie m, Keywords k, Soundtrack s
where m.title = k.title and s.title = m.title and (k.keyword = 'arson' or k.keyword = 'arsonist')
group by m.title