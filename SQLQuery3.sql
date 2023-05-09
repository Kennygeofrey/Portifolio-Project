SELECT sum(new_cases) as Total_new_cases, sum(new_deaths) as Total_new_deaths
FROM CovidDeaths$


select	dea.continent,	 
		dea.population, 
		dea.location, 
		dea.date, 
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (Partition by dea.location order by dea.location, dea.date)
		as RollingPplVac
from CovidDeaths$ as dea
Join CovidVaccinations$ as vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent is not null and	VAC.new_vaccinations IS NOT NULL
	order by 3,4

	--create a CTE
with PopVsVac (continent,
population,
location,  
date,
new_vaccinations,
RollingPplVac) as
(
select	dea.continent,	 
		dea.population, 
		dea.location, 
		dea.date, 
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (Partition by dea.location order by dea.location, dea.date)
		as RollingPplVac
from CovidDeaths$ as dea
Join CovidVaccinations$ as vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent is not null and	VAC.new_vaccinations IS NOT NULL
	--order by 3,4
)
SELECT *, (RollingPplVac/population)*100 
FROM PopVsVac

CREATE VIEW rollingpeopleVac as
select	dea.continent,	 
		dea.population, 
		dea.location, 
		dea.date, 
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (Partition by dea.location order by dea.location, dea.date)
		as RollingPplVac
from CovidDeaths$ as dea
Join CovidVaccinations$ as vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent is not null and	VAC.new_vaccinations IS NOT NULL
	--order by 3,4