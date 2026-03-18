## New Year Tasks

Local Tests:
1. Create Sim league
`thor leagues:create_sim_league`

2. Import Schools
- Add a new CSV of schools (e.g. db/20XX_teams.csv).
- Ensure that the regions are ordered so the first two regions listed play each other in one of the semifinals.
- Run the import task.
`thor schools:import_schools db/20XX_teams.csv`

Optional 3. Local Sim Automate Draft:
- `AutomateDraftJob.perform_now(League.last.id)`

4. Update Play-In Schools
- e.g. `rake "update_play_in_schools[20250314]"` for each play-in date

5. Turn On Update Scores + Game Times scheduled jobs in Heroku
