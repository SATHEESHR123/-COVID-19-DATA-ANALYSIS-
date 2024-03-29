
---USING COVID DEATH

select * from portfolioProject..covid_death
where continent is not null

 
select location, date, total_cases, new_cases, total_deaths, population
from portfolioProject..covid_death
where continent is not null
order by 1,2


--looking at total cases Vs total deaths 
--shows likelihood of dying if you contact covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from portfolioProject..covid_death
where location like '%india%' and continent is not null
order by 1,2



--looking at total cases Vs population
--shows what percentage of population got covid

select location, date,  population, total_cases, (total_cases/population)*100 as percentage_of_population_infected
from portfolioProject..covid_death
where continent is not null
order by 1,2




--looking at countries with heightest infection rate compared to population

select location, population, max(total_cases) as  highest_infection_count, max((total_cases/population))*100 as percentage_of_population_infected
from portfolioProject..covid_death 
where continent is not null
group by  location,population
order by percentage_of_population_infected desc



--showing Countires with highest death count per population

select location, MAX(cast(total_deaths as int)) as total_death_count
from portfolioProject..covid_death 
where continent is not null
group by  location
order by total_death_count desc
 


--LETS BREAK THINGS DOWN BY CONTINENT

select location, MAX(cast(total_deaths as int)) as total_death_count
from portfolioProject..covid_death 
where continent is null
group by location
order by total_death_count desc

 

--Showing continents with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as total_death_count
from portfolioProject..covid_death 
where continent is not null
group by continent
order by total_death_count desc




--GLOBAL NUMBERS

---shows how many people got covid and death count per day in the entrie world 
---shows death percentage per day in the entire world

select date, SUM(new_cases) as total_covid_infected, SUM(new_deaths) as total_death_count, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from portfolioProject..covid_death
--where location like '%india%' 
where continent is not null
group by date
order by 1,2

---shows how many people got covid and its death count in the entire world
---shows death percentage of people in the entire world

select SUM(new_cases) as total_covid_infected, SUM(new_deaths) as total_death_count, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from portfolioProject..covid_death
--where location like '%india%' 
where continent is not null
order by 1,2




---USING COVID VACCINATION

select * from portfolioProject..covid_death

--looking at total population Vs Vaccination


select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccination
--(Rolling_people_vaccination/population)*100 as percentage_of_population
from portfolioProject..covid_death dea
join portfolioProject..covid_vaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3



--USE CTE(Common table Expression)

--show percentage of population vaccinated in each day using each location


with PopvsVac (continent, location, Date, population, new_vaccinations, Rolling_people_vaccination)
as
(
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccination
from portfolioProject..covid_death dea
join portfolioProject..covid_vaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Rolling_people_vaccination/population)*100 as percentage_of_population
from PopvsVac
order by 2,3




--USE TEMP TABLE

drop table if exists #percentage_population_vaccinated
create table #percentage_population_vaccinated 
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime,
population float,
new_vaccinations int,
Rolling_people_vaccination int
)

insert into #percentage_population_vaccinated
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccination
from portfolioProject..covid_death dea
join portfolioProject..covid_vaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (Rolling_people_vaccination/population)*100 as percentage_of_population
from #percentage_population_vaccinated
order by 2,3

 

 --create view to store data for later visualizations

Create View Percentagepopulationvaccinated as
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccination
from portfolioProject..covid_death dea
join portfolioProject..covid_vaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * from Percentagepopulationvaccinated

 
