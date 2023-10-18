-- create a view to store data for later visualizations
--use PortfolioProject
--drop view if exists PercentPopulationVaccinated
create view PercentPopulationVaccinated as
	select   CD.continent, CV.location, CV.date, CD.population, CV.new_vaccinations
		, sum(CV.new_vaccinations) over (partition by CV.location order by CV.location, CV.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths CD
	join PortfolioProject..CovidVaccinations CV
		on CD.location = CV.location
		and CD.date = CV.date
	where CD.location is not null 

select  continent, location, population, RollingPeopleVaccinated
from PortfolioProject..PercentPopulationVaccinated