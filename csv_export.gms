

$call gdxdump results.gdx symb=report_tech format=csv header="Parameter, RES share, EV share, Prosumer share, Technology, Country, Value" output=results/report_tech.csv
$call gdxdump results.gdx symb=report_tech_hours format=csv header="type, RES share, EV share, Prosumer share, Technology, Hour, Country, Value" output=results/report_tech_hourly.csv
$call gdxdump results.gdx symb=report_hours format=csv header="type, RES share, EV share, Prosumer share, Hour, Country, Value" output=results/report_hourly.csv
$call gdxdump results.gdx symb=report format=csv header="Indicator, RES share, EV share, Prosumer share, Value" output=results/summary.csv
