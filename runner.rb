# frozen_string_literal: true

require_relative 'config/environment'

app = Cli.new
binding.pry
app.cohort_selection
app.list_selection
