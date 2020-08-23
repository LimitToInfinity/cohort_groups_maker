# frozen_string_literal: true

# cli class to hold app logic
class Cli
  def cohorts
    cohorts_unsorted = JSON.parse(File.read('app/cohorts.json'))
    cohorts_unsorted.sort_by { |_, info| info['start_date'] }.reverse!
  end

  def tty_prompt
    TTY::Prompt.new(
      symbols: { marker: '💃' },
      # active_color: :cyan,
      # help_color: :bright_cyan
    )
  end

  def initialize
    @cohorts = cohorts
    @prompt = tty_prompt
  end

  def prompt_ask(prompt, options = {})
    @prompt.ask(prompt, options) { |q| q.modify :strip }
  end

  def prompt_select(prompt, choices)
    @prompt.select(prompt, choices, per_page: 5, filter: true)
  end

  def prompt_select_yes?(prompt)
    prompt_select(prompt, yes: true, no: false)
  end

  def prompt_multi_select(prompt, choices)
    @prompt.multi_select(prompt, choices, min: 1, per_page: 5, filter: true)
  end

  def welcome_menu
    prompt_multi_select('Which cohorts are involved?', cohort_choices)
  end

  def cohort_choices
    
  end

  def main_menu
    loop do
      value = prompt_select('What would you like to do?', menu_options)
      break if value == 'exit'
    end
  end

  private

  def list_two_cohort_options
    puts "
    1. #{@cohort_1.name}
    2. #{@cohort_2.name}
    4. #{@cohort_1.name} and #{@cohort_2.name}"
  end

  def list_three_cohort_options
    puts "
    1. #{@cohort_1.name}
    2. #{@cohort_2.name}
    3. #{@cohort_3.name}
    4. #{@cohort_1.name} and #{@cohort_2.name}
    5. #{@cohort_1.name} and #{@cohort_3.name}
    6. #{@cohort_2.name} and #{@cohort_3.name}
    7. #{@cohort_1.name} and #{@cohort_2.name} and #{@cohort_3.name}"
  end

  def cohort_map
    {
      1 => [@cohort_1],
      2 => [@cohort_2],
      3 => [@cohort_3],
      4 => [@cohort_1, @cohort_2],
      5 => [@cohort_1, @cohort_3],
      6 => [@cohort_2, @cohort_3],
      7 => [@cohort_1, @cohort_2, @cohort_3]
    }
  end
end
