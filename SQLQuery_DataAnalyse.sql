select  *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

select top 1000 *
from PortfolioProject..CovidVaccinations
order by 3,4

-- select Data that we are going to be using

select top 1000 location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

-- Looking at Tatal Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in USA
select top 1000 location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2 

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid in USA

select top 1000 location, date, total_cases, population, (total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2 

---- Looking at Countries with Highest Infection Rate compared to Population
select  location, population, max(total_cases) as HighestInfectionCount,  max(total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
group by location, population
order by CovidPercentage desc

-- total_deaths is nvarchar, need change it to int
alter table PortfolioProject..CovidDeaths
alter column total_deaths int
GO

-- Showing Countries with Highest Death Count per Population

select top 1000 location, MAX(cast(total_deaths as int)) as MaxTotalDeath
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by MaxTotalDeath desc

-- Let's break things down by continent

select location, max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- showing continent with the highest death count per population
select location, population, max(total_deaths) as MaxTotalDeath, max(total_deaths)/population as totalDeathPerPopulation
from PortfolioProject..CovidDeaths
where continent is null
group by location, population
order by totalDeathPerPopulation desc

-- Showing Golbal Covid information
select sum(new_cases) as GolbalNewCasesPerDay, sum(new_deaths) as GobalDeathsPerDay, sum(new_deaths)/sum(new_cases) as DeathsPercentage
from PortfolioProject..CovidDeaths
where continent is not null 
order by 1

-- Looking at Total Population VS Vaccinations
--alter table PortfolioProject..CovidVaccinations
--alter column new_vaccinations bigint

-- Using CTE (Common Table Expression) to perform Calculation on Partition By in previous query
with PopVSVac 
--(Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
select   CD.continent, CV.location, CV.date, CD.population, CV.new_vaccinations
		, sum(CV.new_vaccinations) over (partition by CV.location order by CV.location, CV.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths CD
join PortfolioProject..CovidVaccinations CV
	on CD.location = CV.location
	and CD.date = CV.date
where CD.continent is not null 
)
select *, (RollingPeopleVaccinated/Population)*100
from PopVSVac
order by 2, 3
