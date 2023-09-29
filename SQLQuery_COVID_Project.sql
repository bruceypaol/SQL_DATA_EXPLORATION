 select * from portfolioProject.dbo.Covid_deaths
where continent is not null
order by 3, 4

select * from portfolioProject.dbo.Covid_vaccinations
order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from portfolioProject.dbo.Covid_deaths
where continent is not null
order by 1,2
;

-- Total Cases vs Total Deaths
 
select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as percentage
from portfolioProject.dbo.Covid_deaths
where continent is not null
order by 1,2


--Looking at Total Cases VS Population
--Shows what percentage of people got COVID-19
select location, date, total_cases, population, (total_cases / population)*100 as percentage
from portfolioProject.dbo.Covid_deaths
where continent is not null
order by 1,2

-- Looking at country with Highest Infection Rate compared to Population

select location, Max(total_cases) as HighestInfectionCount, population, MAX((total_cases / population))*100 as PercentagePopulationInfected
from portfolioProject.dbo.Covid_deaths
where continent is not null
group by location, population
order by PercentagePopulationInfected DESC

-- Showing the country with Highest Death count per Population

select location, Max(total_deaths) as TotalDeathCount
from portfolioProject.dbo.Covid_deaths
where continent is not null
group by location
order by TotalDeathCount DESC

-- Showing the continent with Highest Death Count Per Population

select location, Max(total_deaths) as TotalDeathCount
from portfolioProject.dbo.Covid_deaths
where continent is not null
group by location
order by TotalDeathCount DESC

-- Global Numbers 

select date, SUM(new_cases) as NewCases, Sum(new_deaths) as NewDeaths, Sum(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from Covid_deaths
where continent is not null
and new_cases <> 0
group by date 
order by 1,2

---- Looking at Total Population VS Vaccinations

Select cod.location, cod.date, cod.population, cov.new_vaccinations, SUM(cov.new_vaccinations)
OVER(partition by cod.location order by cod.location, cov.date) as PeopleVaccinated 
-----Note----(PeopleVaccinated/population)*100 --- We cannot use PeopleVaccinated here because we have just created this column using aliase
---To check the how much percent of the total population got vaccinated we have to create CTE--
from portfolioProject.dbo.Covid_deaths cod
Join portfolioProject.dbo.Covid_vaccinations cov
On cod.location = cov.location
and cod.date = cov.date
where cod.continent is not null
order by 1,2,3

--- USING CTE 
with PopulationVsVaccination ( continent, location,date, population, new_vaccinations, PeopleVaccinated)
--- We have to mention all the column we are using in the query below to generated a temporary table
as (
Select cod.continent,cod.location, cod.date, cod.population, cov.new_vaccinations, SUM(new_vaccinations) 
OVER(partition by cod.location order by cod.location, cov.date) as PeopleVaccinated
from portfolioProject.dbo.Covid_deaths cod
Join portfolioProject.dbo.Covid_vaccinations cov
On cod.location = cov.location
and cod.date = cov.date
where cod.continent is not null
--order by 1,2,3
)
Select *, (PeopleVaccinated/population)*100 from PopulationVsVaccination




