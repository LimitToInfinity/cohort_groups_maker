# frozen_string_literal: true

require_relative 'config/environment'

app = Cli.new
app.cohort_selection
app.remove_students_who_are_out
app.list_selection
