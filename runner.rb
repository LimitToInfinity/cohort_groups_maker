# frozen_string_literal: true

require_relative 'config/environment'

binding.pry


# Comment in/out code below to get pairs for desired cohort
# git_mon = Cohort.new("Git Money", git_money)

c1 = Cohort.new("Die Prying", die_prying)


c2 = Cohort.new("JSON Derulo", json_derulo)
c3 = Cohort.new("New Friends", new_friends)

cli = Cli.new(c1, c2, c3)
cli.menu

