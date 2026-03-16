## New Year Tasks

Local Tests:
1. Create Sim league
`thor leagues:create_sim_league`

2. Import Schools
- Add a new CSV of schools (e.g. db/20XX_teams.csv).
- Ensure that the regions are ordered so the first two regions listed play each other in one of the semifinals.
- Run the import task.
`thor schools:import_schools db/20XX_teams.csv`

## Nice-to-haves:

1. Automate or make it easier to input actual game times
2. Add checkbox inputs for recording whether an owner has paid
3. Add auto-draft checkbox.
4. Give each owner a place for a gif.
