# Easy Cohort Grouping Engine

### To Use
1. `git clone git@github.com:LimitToInfinity/cohort_groups_maker.git` to your local machine.
2. `cd cohort_groups_maker`
3. `ruby runner.rb` and just **follow along**
4. Copy and paste the pairs when you're done!
5. Options:
    - Groups (single cohort or mixed cohort)
    - 1 List with Staff (like mods 2 & 4 feelings)
    - 3 Lists each with a Staff Leader (like mods 1, 3, & 5 feelings)
    - 1 List Students Only


### Upkeep
* Add cohorts to `app/cohorts.json` when cohorts start. (automatically doesn't display cohorts that started more than 15 weeks ago using start_date)
* Update cohort names in `app/cohorts.json` after each mod for those who stay another six weeks
* Update instructors, coaches, and/or staff arrays/methods in `Cli.rb` when needed

#### Making Groups
![Making Groups](/assets/gifs/student_groups.gif)
---

#### 3 Lists with Staff (like feelings)
![3 Lists with Staff (like feelings)](/assets/gifs/3_lists_with_staff_like_feelings.gif)
---

#### Where to Update Students and Staff
![Where to Update Students and Staff](/assets/gifs/students_&_staff.gif)
