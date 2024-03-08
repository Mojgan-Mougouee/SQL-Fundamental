Select *
from dbo.CovidDeath
where continent is not null

--Select *
--from dbo.CovidVaccinations



--select data that we are going to be using

Select location, date,total_cases,new_cases,total_deaths,population
from dbo.CovidDeath
ORDER BY location, date

--Looking at Total cases vs Toatal death

Select location, date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)
from dbo.CovidDeath
ORDER BY 1, 2

SELECT location, MIN(date) AS min_date, SUM(total_cases) AS total_cases, SUM(new_cases) AS new_cases
FROM dbo.CovidDeath
GROUP BY location;

Select location, date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)
from dbo.CovidDeath
Where location like '%states%'
ORDER BY 1, 2


Select location, date,total_cases,new_cases,total_deaths,(total_deaths/total_cases) as DeathPercentage
from dbo.CovidDeath
Where location like '%iran%'
ORDER BY 1, 2
--shows the likleihood of dying if you contract covid in your country

SELECT location,
    SUM(total_deaths) AS total_deaths,
    SUM(total_cases) AS total_cases,
    (SUM(total_deaths) / NULLIF(SUM(total_cases), 0)) * 100 AS DeathPrecentage
FROM  dbo.CovidDeath
GROUP BY location;


--shows that percentage of population got covid
Select location, date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from dbo.CovidDeath

--looking at countries with highest infection rate compared to population
Select location,population,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from dbo.CovidDeath
GROUP BY LOCATION,population 
order by  PercentPopulationInfected desc


--showing the countries with the highest death count per population
Select location,population,max(total_deaths)as TotaltDeathCount
from dbo.CovidDeath
where continent is not null
GROUP BY LOCATION,population 
order by TotaltDeathCount desc

--let's break thing down by continent
Select location,max(total_deaths)as TotaltDeathCount
from dbo.CovidDeath
where continent is null
GROUP BY location
order by TotaltDeathCount desc



--showing the continent with the highest death count
Select continent,max(total_deaths)as TotaltDeathCount

where continent is not null
GROUP BY continent
order by TotaltDeathCount desc


--GLOBAL NUMBERS

Select date,sum(new_cases) as TotalCases,sum(new_deaths)as TotalDeath ,sum(new_deaths)/NULLIF(SUM(new_cases), 0) * 100 AS DeathPrecentage
from dbo.CovidDeath
where continent is not null
group by date


Select sum(new_cases) as TotalCases,sum(new_deaths)as TotalDeath ,sum(new_deaths)/NULLIF(SUM(new_cases), 0) * 100 AS DeathPrecentage
from dbo.CovidDeath
where continent is not null

Select *
from dbo.CovidVaccinations


--Looking at total population vs Vaccination
Select DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
sum(VAC.new_vaccinations)over(partition by DEA.location order by DEA.date,DEA.location)as RollingPeopleVccinated,
--( RollingPeopleVccinated/population)
from dbo.CovidDeath AS DEA
join
dbo.CovidVaccinations AS  VAC
    on DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
order BY DEA.location,DEA.date 


--USE CTE
WITH PopvsVac (Continent,Location,Date,Population,New_vaccinations ,RollingPeopleVccinated)
as
(
Select DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
sum(VAC.new_vaccinations)over(partition by DEA.location order by DEA.date,DEA.location)as RollingPeopleVccinated
from dbo.CovidDeath AS DEA
join
dbo.CovidVaccinations AS  VAC
    on DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
--order BY DEA.location,DEA.date
)
SELECT *,(RollingPeopleVccinated /cast(population as float))*100
FROM PopvsVac

--TEMP Table
DROP Table if exists #PercentPopulationVaccinate
Create Table #PercentPopulationVaccinate
(
Continent nvarchar(255),
Location nvarchar (255),
Date Datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVccinated numeric
)
insert into #PercentPopulationVaccinate
Select DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
sum(VAC.new_vaccinations)over(partition by DEA.location order by DEA.date,DEA.location)as RollingPeopleVccinated
from dbo.CovidDeath AS DEA
join
dbo.CovidVaccinations AS  VAC
    on DEA.location=VAC.location
	AND DEA.date=VAC.date
--where DEA.continent is not null
order BY DEA.location,DEA.date
SELECT *,(RollingPeopleVccinated /cast(population as float))*100
FROM #PercentPopulationVaccinate

--Creating view to store data for later visualisation
create View PercentPopulationVaccinate as
Select DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
sum(VAC.new_vaccinations)over(partition by DEA.location order by DEA.date,DEA.location)as RollingPeopleVccinated
from dbo.CovidDeath AS DEA
join
dbo.CovidVaccinations AS  VAC
    on DEA.location=VAC.location
	AND DEA.date=VAC.date
where DEA.continent is not null
--Order BY DEA.location,DEA.date 

select * from PercentPopulationVaccinate