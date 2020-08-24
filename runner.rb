# frozen_string_literal: true

require_relative 'config/environment'

app = Cli.new
app.cohort_selection
app.list_selection
