select  *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

-- select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

-- Temp table
drop table  if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
	--select dea.continent, vac.location, vac.date, dea.population, vac.new_vaccinations
	--	, sum(vac.new_vaccinations) over (partition by vac.location order by vac.location, vac.date) as RollingPeopleVaccinated
	--from PortfolioProject..CovidDeaths dea
	--join PortfolioProject..CovidVaccinations vac
	--	on dea.location = vac.location
	--	and dea.date = vac.date
	--where dea.location is not null
	select   CD.continent, CV.location, CV.date, CD.population, CV.new_vaccinations
		, sum(CV.new_vaccinations) over (partition by CV.location order by CV.location, CV.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths CD
	join PortfolioProject..CovidVaccinations CV
		on CD.location = CV.location
		and CD.date = CV.date
	where CD.location is not null 

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated
order by 2, 3
