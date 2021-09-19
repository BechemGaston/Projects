##Data Exploration
##Table 1
select *
from coviddeath
where continent is not null
ORDER BY 3,4
##Table 2
SELECT *
from covidvacc
where continent is not null
ORDER BY 3,4

##extracting some important data from the database

select location,date,total_cases,new_cases,total_deaths,population
from coviddeath
order by 1,2

##Looking at the Total deaths per Cases. this result shows the likelihood of dying 
 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeath
order by 1,2

##results from a particular country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeath
where location="China"
order by 1,2

##total cases vs the population. shows us the percentage of population infected

select location,date,total_cases,population,(total_cases/population)*100 as PopPercentage
from coviddeath
order by 1,2

## in a particular country, for example; USA

select location,date,total_cases,population,(total_cases/population)*100 as PopPercentage
from coviddeath
where location="United States"
order by 1,2

##looing at countries with highest infection rate compared to population

select location,population,MAX(total_cases) as highestinfectioncount, MAX(total_cases/population)*100 as infectedpercent
from coviddeath
GROUP BY location,population
order by infectedpercent DESC

#looking at countries with highest death count per population
select location,MAX(total_deaths) as TotalDeathCount
from coviddeath
GROUP BY location
order by TotalDeathCount desc

##looking by continent
select
continent,MAX(total_deaths) as TotalDeathCount
from coviddeath
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

##global numbers
select 
DISTINCT date,new_cases,total_cases,new_deaths, (new_deaths/new_cases)*100 as worlddeathpercent
from coviddeath
GROUP BY date
order by 1,2

##looking at table 2

SELECT * from covidvacc

##joining the two tables

SELECT * 
from coviddeath dea
JOIN covidvacc vac
ON dea.location = vac.location
and dea.date = vac.date

##looking at total population vs vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) as cumulative
from coviddeath dea
JOIN covidvacc vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
ORDER BY 1,2,3

##calculating total number vaccinnated in Albania
##using a CTE

WITH PopVaccinated (continent,location,date,population,new_vaccinations,cumulative)
as 
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) as cumulative
from coviddeath dea
JOIN covidvacc vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
ORDER BY 1,2,3
)
SELECT *, (cumulative/population)*100 as PofPopVaccinated
from PopVaccinated

## creating views for visualizations

create view PercentofPop
as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) as cumulative
from coviddeath dea
JOIN covidvacc vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
ORDER BY 1,2,3

##

create view globalnumbers
as
select 
DISTINCT date,new_cases,total_cases,new_deaths, (new_deaths/new_cases)*100 as worlddeathpercent
from coviddeath
GROUP BY date
order by 1,2

##
create view PopVsVac
as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date) as cumulative
from coviddeath dea
JOIN covidvacc vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
ORDER BY 1,2,3

##
create view continents
as
select
continent,MAX(total_deaths) as TotalDeathCount
from coviddeath
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

##
create view deathrate
as
select location,MAX(total_deaths) as TotalDeathCount
from coviddeath
GROUP BY location
order by TotalDeathCount desc

##
create view generalinfo
as
select location,date,total_cases,new_cases,total_deaths,population
from coviddeath
order by 1,2

##
create view chinadeathrate
as
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeath
where location="China"
order by 1,2

##
create view USAinfected
as
select location,date,total_cases,population,(total_cases/population)*100 as PopPercentage
from coviddeath
where location="United States"
order by 1,2

##
create view nationaldeathrates
as
select location,population,MAX(total_cases) as highestinfectioncount, MAX(total_cases/population)*100 as infectedpercent
from coviddeath
GROUP BY location,population
order by infectedpercent DESC