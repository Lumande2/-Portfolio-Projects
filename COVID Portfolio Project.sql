SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4



SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4



SELECT location, date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2



SELECT location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2



SELECT location, date,population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
ORDER BY 1,2


--Showing Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount ,MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population 
ORDER BY PercentagePopulationInfected DESC


--Showing Countries with Highest Death Count per Population


SELECT location, MAX(cast(total_deaths as int))as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--Showing by Continent

SELECT continent, SUM(cast(new_deaths as int)) TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT  NULL
GROUP BY continent
ORDER BY  TotalDeathCount DESC


--Global Numbers

SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



SELECT date,SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY 1,2


--Total Population vs Vaccinations


SELECT dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
ORDER BY 2,3	


WITH PopvsVac (continent, location, date, population,New_vaccinations,RollingPeopleVaccinated)
as 
(
SELECT dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
--ORDER BY 2,3	
)
SELECT *, (RollingPeopleVaccinated/Population)
FROM PopvsVac


--View to store Data for later visualisations

Create View PercentPopulationVacinnated as
SELECT dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
--ORDER BY 2,3	




















































































