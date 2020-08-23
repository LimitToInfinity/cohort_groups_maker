# frozen_string_literal: true

# cli class to hold app logic
class Cli
  def tty_prompt
    TTY::Prompt.new(
      symbols: { marker: '💃' },
      # active_color: :cyan,
      # help_color: :bright_cyan
    )
  end

  def cohorts
    cohorts_unsorted = JSON.parse(File.read('app/cohorts.json'))
    cohorts_unsorted.sort_by { |_, info| info['start_date'] }.reverse!
  end

  def staff
    %w[
      Kyle\ Coberly
      Damon\ Chivers
      Ahmed\ Gaber
      Kristine\ Du
      Brian\ Firooz
      Josh\ Couper
    ]
  end

  def initialize
    @prompt = tty_prompt
    @cohorts = cohorts
    @students = []
    @staff = staff
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

  def opening_menu
    @students = prompt_multi_select('Which cohorts?', cohort_choices)
  end

  def cohort_choices
    @cohorts.each_with_object({}) do |(name, info), choices|
      if Date.parse(info['start_date']).cweek + 15 > Date.today.cweek
        choices[name] = info['names']
      end
      choices
    end
  end

  def second_menu
    prompt_select('List type?', second_menu_selections)
  end

  def second_menu_selections
    {
      groups: -> { make_groups },
      "1 list with staff": -> { one_list_with_staff },
      "1 list students only": -> { one_list_students_only },
    }
  end

  def make_groups
    puts 'make groups'
  end

  def one_list_with_staff
    puts 'one list with staff'
  end

  def one_list_students_only
    puts 'one list students only'
  end
end
