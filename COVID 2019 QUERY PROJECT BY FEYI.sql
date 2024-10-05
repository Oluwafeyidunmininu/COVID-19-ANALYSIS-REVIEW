SELECT * FROM [Portfolio Project ]..[covid-data death]  where continent is not null ORDER BY 3,4
SELECT * FROM [Portfolio Project ]..[covid-data vaccination] ORDER BY 3,4


--PROJECT STARTS  

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED WITH POPULATION
SELECT location, population, MAX(total_cases) as HighestInfectedCountry, Max((total_cases/population)*100) PercentagePopulationInfected FROM [Portfolio Project ]..[covid-data death]
	where continent is not null
	group by location, population 
	ORDER BY PercentagePopulationInfected desc

--SHOWING THE COUNTRIES WITH  HIGHEST DEATH COUNT BY POPULATION WHERE CONTINENT IS NOT NULL
SELECT location, max(cast(total_deaths as int)) as TotalDeathcount FROM [Portfolio Project ]..[covid-data death] 
	where continent is not null
	group by location, population ORDER BY TotalDeathcount desc 

--SHOWING THE COUNTRIES WITH  HIGHEST DEATH COUNT BY POPULATION  (NOted)
SELECT location, max(cast(total_deaths as int)) as TotalDeathcount FROM [Portfolio Project ]..[covid-data death] 
	where continent is null
	group by location, population ORDER BY TotalDeathcount desc 
	  
--SHOWING THE CONTINENT  WITH  HIGHEST DEATH COUNT BY POPULATION
SELECT continent, max(cast(total_deaths as int)) as TotalDeathcount FROM [Portfolio Project ]..[covid-data death] 
	where continent is  not null
	group by continent ORDER BY TotalDeathcount desc 

-- TOTAL DEATH GROUP BY LOCATION  
SELECT  location, sum(total_deaths)as TotalDeath from [Portfolio Project ]..[covid-data death] group by location
	  
 --GLOBAL NUMBERS  
 SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases)*100 AS Death_Percentage 
 FROM [Portfolio Project ]..[covid-data death] 
	WHERE continent is not null group by Date  ORDER BY 1,2 

 SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases)*100 AS Death_Percentage 
 FROM [Portfolio Project ]..[covid-data death] 
	WHERE continent is not null group by Date  ORDER BY 1,2 

	
SELECT * FROM [Portfolio Project ]..[covid-data death] dea
		join
		[Portfolio Project ]..[covid-data vaccination] vacc
		on dea.location = vacc.location and dea.date = vacc.date  

--Looking at Total Population vs Vaccination 
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(convert(int, vacc.new_vaccinations))
		OVER (partition by dea .location order by dea.location,dea.date) as Rolling_People_Vaccinated
		from [Portfolio Project ]..[covid-data death] dea
			join
		[Portfolio Project ]..[covid-data vaccination] vacc
		on dea.location = vacc.location and dea.date = vacc.date 
		where dea.continent is not null order by 2,3
	
	--(Rolling_People_Vaccination/population)*100
	-- USE CTE 
	WITH POPVSVACC (continent, location, date, population, New_vaccinations, Rolling_People_Vaccinated)
	as 
	(
		SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(convert(int, vacc.new_vaccinations))
		OVER (partition by dea .location order by dea.location,dea.date) as Rolling_People_Vaccinated 
		from [Portfolio Project ]..[covid-data death] dea
			join
		[Portfolio Project ]..[covid-data vaccination] vacc
		on dea.location = vacc.location and dea.date = vacc.date 
		where dea.continent is not null 
		) 
		SELECT *, (Rolling_People_Vaccinated/population)*100
		FROM POPVSVACC

-- TEM TABLE
	DROP TABLE IF EXISTS #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric, New_vaccinations numeric,Rolling_People_Vaccinated numeric)

	INSERT INTO #PercentPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(convert(int, vacc.new_vaccinations))
		OVER (partition by dea .location order by dea.location,dea.date) as Rolling_People_Vaccinated 
		from [Portfolio Project ]..[covid-data death] dea
			join
		[Portfolio Project ]..[covid-data vaccination] vacc
		on dea.location = vacc.location and dea.date = vacc.date 
		SELECT *, (Rolling_People_Vaccinated/population)*100
		FROM #PercentPopulationVaccinated
		  

	-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
	Create View PercentPopulationVaccinated as
	SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(convert(int, vacc.new_vaccinations))
		OVER (partition by dea .location order by dea.location,dea.date) as Rolling_People_Vaccinated 
		from [Portfolio Project ]..[covid-data death] dea
			join
		[Portfolio Project ]..[covid-data vaccination] vacc
		on dea.location = vacc.location and dea.date = vacc.date 
		WHERE dea.continent is not null
		
Select *from PercentPopulationVaccinated
