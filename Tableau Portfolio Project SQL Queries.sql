/*

Queries used for Tableau Project

*/



-- 1. 

select  SUM(new_cases) as total_covid_infected, SUM(new_deaths) as total_death_count, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from portfolioProject..covid_death
--where location like '%india%' 
where continent is not null
--group by date
order by 1,2


--2


select continent, SUM(cast(new_deaths as int)) as total_death_count
from portfolioProject..covid_death 
where continent is not null
group by continent
order by total_death_count desc



---3

select location, population, max(total_cases) as  highest_infection_count, max((total_cases/population))*100 as percentage_of_population_infected
from portfolioProject..covid_death 
where continent is not null
group by  location,population
order by percentage_of_population_infected desc


---4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from portfolioProject..covid_death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


