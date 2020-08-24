# Easy Cohort Grouping Engine

### To Use
1. `git clone git@github.com:LimitToInfinity/cohort_groups_maker.git` to your local machine.
2. `cd cohort_groups_maker`
3. `ruby runner.rb` and just **follow along**
4. Copy and paste the pairs when you're done!

### Upkeep
* Add cohorts to `app/cohorts.json` when cohorts start. (automatically doesn't display cohorts that started more than 15 weeks ago using start_date)
* Update cohort names in `app/cohorts.json` after each mod for those who stay another six weeks
* Update instructors, coaches, and/or staff arrays/methods in `Cli.rb` when needed
