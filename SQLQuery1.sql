Select *
From [Portfolio project]..coviddeaths
Where continent is not null
order by 3,4

--Select *
--From [Portfolio project]..Covidvaccines
--order by 3,4

select location,date, total_cases, new_cases, total_deaths, population
From [Portfolio project]..coviddeaths
order by 1,2

--Total cases vs Total Deaths
--Shows likelihood of dying from covid in your country

select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio project]..coviddeaths
where location like '%canada%'
order by 1,2

--Total cases vs population
Shows percentange of population that got Covid

select location,date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [Portfolio project]..coviddeaths
where location like '%canada%'
order by 1,2

--Countries with highest infection rates compared to population

Select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as PercentPopulationinfected
From [Portfolio project]..coviddeaths
--where location like '%canada%'
Group by location, population
order by PercentPopulationinfected desc

--Showing Countries with highest death count per population

Select location, max(cast(Total_deaths as int)) as TotalDeathcount
From [Portfolio project]..coviddeaths
--where location like '%canada%'
where continent is not null
Group by location
order by TotalDeathcount desc

--Breaking things down by Continent

Select continent, max(cast(Total_deaths as int)) as TotalDeathcount
From [Portfolio project]..coviddeaths
--where location like '%canada%'
where continent is not null
Group by continent
order by TotalDeathcount desc

--Global numbers

Select date, SUM(new_cases)--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio project]..coviddeaths
--where location like '%canada%'
where continent is not null
Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio project]..coviddeaths dea
Join [Portfolio project]..Covidvaccines vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project]..coviddeaths dea
Join [Portfolio project]..Covidvaccines vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3	
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac



--TEMP TABLE


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project]..coviddeaths dea
Join [Portfolio project]..Covidvaccines vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3	
)
Select*, (#PercentPopulation/Population*100
From PopvsVac


--Creating View to store data for later visualisations

Create View RollingPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project]..coviddeaths dea
Join [Portfolio project]..Covidvaccines vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3	

Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac










