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

  def lead_instructors
    %w[Kyle\ Coberly Damon\ Chivers Ahmed\ Gaber]
  end

  def coaches
    %w[Kristine\ Du Jon\ Higger]
  end

  def staff
    %w[Brian\ Firooz Josh\ Couper]
  end

  def initialize
    @prompt = tty_prompt
    @cohorts = cohorts
    @students = []
    @lead_instructors = lead_instructors
    @coaches = coaches
    @staff = staff
    @three_lists = [[], [], []]
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

  def cohort_selection
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

  def list_selection
    prompt_select('List type?', second_menu_selections)
  end

  def second_menu_selections
    {
      groups: -> { make_groups },
      "1 list with staff": -> { one_list_with_staff },
      "3 lists with staff": -> { three_lists_with_staff },
      "1 list students only": -> { one_list_students_only }
    }
  end

  def make_groups
    puts 'make groups'
  end

  def one_list_with_staff
    remove_staff_who_are_out
    puts '---one list with staff---'
    all_people = (@students + @staff).flatten.shuffle.shuffle.shuffle.shuffle
    all_people.each do |person|
      puts person
    end
  end

  def three_lists_with_staff
    remove_staff_who_are_out
    puts '---three lists with staff---'
    add_instructors
    add_coaches_and_staff
    add_students
    display_each_list
  end

  def add_instructors
    @lead_instructors << @coaches.shift while @lead_instructors.length < 3
    list_index = 0
    @lead_instructors.each do |instructor|
      @three_lists[list_index] << instructor
      list_index += 1
    end
  end

  def add_coaches_and_staff
    list_index = rand(0..2)
    (@coaches + @staff).shuffle.shuffle.each do |coach|
      @three_lists[list_index] << coach
      list_index = list_index == 2 ? 0 : (list_index + 1)
    end
  end

  def add_students
    @students.each do |student_array|
      list_index = 0
      while student_array.length.positive?
        @three_lists[list_index] << student_array.delete(student_array.sample)
        list_index = list_index == 2 ? 0 : (list_index + 1)
      end
    end
  end

  def display_each_list
    @three_lists.each.with_index(1) do |list, index|
      puts "---List #{index}---- #{list.first}"
      list.shuffle.shuffle.shuffle.each do |person|
        puts person
      end
    end
  end

  def one_list_students_only
    puts 'one list students only'
  end

  def remove_staff_who_are_out
    anyone_is_off = prompt_select_yes?('Are any staff off today?')
    return unless anyone_is_off

    staff_who_are_out = prompt_multi_select(
      'Who is off?',
      (@lead_instructors + @coaches + @staff)
    )
    @lead_instructors -= staff_who_are_out
    @coaches -= staff_who_are_out
    @staff -= staff_who_are_out
  end
end
