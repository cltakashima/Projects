  -- Select data that we are going to be using
SELECT
  location,
  date,
  total_cases,
  total_deaths,
  population
FROM
  sql-practice-407916.COVID.deaths
WHERE
  total_cases IS NOT NULL
ORDER BY
  1,2
  
  -- Looking at Total Cases vs Total Deaths
  -- Shows likelihood of dying if you contract COVID in your country
  
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE location like 'United States'
AND continent IS NOT NULL
AND total_cases IS NOT NULL
ORDER BY 1,2

  -- GLOBAL NUMBERS
  
SELECT SUM(new_cases) total_cases, SUM(new_deaths) total_deaths, ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
--WHERE location like 'United States'
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL
--AND total_cases IS NOT NULL
--GROUP BY date
ORDER BY 1,2

  -- COVID VACCINATIONS
  -- Looking at total vaccinations vs. total population
  
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM sql-practice-407916.COVID.deaths dea
JOIN sql-practice-407916.COVID.vaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3

  -- USE CTE
  -- With Population vs Vaccination (Continent, location, date, population)
  -- SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION
  
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount

  -- Creating View to store data for later visualizations