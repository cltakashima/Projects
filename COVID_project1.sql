-- COVID PROJECT: DEPICTING DIFFERENT FIGURES (FROM COVID INFECTION CONTRACTION TO DEATHS IN THE US AND WORLDWIDE)

-- Data Sources:  1. https://ourworldindata.org/
                  2. https://github.com/owid/covid-19-data/tree/master/public/data

-- The data was downloaded Jan 8, 2024
                    
-- Downloaded information was edited, cleaned, and processed in Excel into different data CSV file sets, then uploaded to BigQuery Sandbox

-- The following queries were run in BigQuery Sandbox to explore the data.

SELECT *
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM sql-practice-407916.COVID.vaccinations
ORDER BY 3, 4

-- SELECT DAT THAT WE ARE GOING TO USE

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM sql-practice-407916.COVID.deaths
ORDER BY 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- Shows likelihood of dying if you contract(ed) COVID in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE total_cases IS NOT NULL
AND continent IS NOT NULL
AND location = "United States"
ORDER BY 1,2

-- LOOKING AT THE TOTAL CASES VS POPULATION
-- Shows what percentage of the population got COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE total_cases IS NOT NULL
AND continent IS NOT NULL
AND location = "United States"
ORDER BY 1,2

-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopInfected
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopInfected DESC

-- SHOWING THE COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- BROKEN DOWN BY CONTINENT
-- SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
-- 1. BY DATE
SELECT date, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
AND Total_cases IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- 2. TOTAL
SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS
-- Use CTE

WITH PopVsVac AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count_vac
FROM sql-practice-407916.COVID.deaths dea
JOIN sql-practice-407916.COVID.vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
)

SELECT *, (rolling_count_vac/population)*100 AS vaccination_percentage
FROM PopVsVac;

-- TEMP TABLE


WITH PercentPopulationVaccinated AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count_vac
FROM sql-practice-407916.COVID.deaths dea JOIN
sql-practice-407916.COVID.vaccinations vac ON
dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
)

SELECT *, (rolling_count_vac / population) * 100 AS vaccination_percentage
FROM PercentPopulationVaccinated;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW COVID.PercentPopulationVaccinated AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count_vac,
(SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) / dea.population) * 100 AS vaccination_percentage
FROM sql-practice-407916.COVID.deaths dea JOIN
sql-practice-407916.COVID.vaccinations vac 
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
);

-- CREATE VIEW - LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- Shows likelihood of dying if you contract(ed) COVID in your country

CREATE VIEW COVID.CovidDeathView 
AS (
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM sql-practice-407916.COVID.deaths
WHERE total_cases IS NOT NULL
AND continent IS NOT NULL
AND location = "United States"
ORDER BY 1,2
)
