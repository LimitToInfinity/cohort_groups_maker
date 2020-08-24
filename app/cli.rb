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

  def cohort_hashes
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
    @cohorts = []
    @lead_instructors = lead_instructors
    @coaches = coaches
    @staff = staff
    @groups = []
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
    @cohorts = prompt_multi_select('Which cohorts?', cohort_choices)
  end

  def cohort_choices
    cohort_hashes.each_with_object({}) do |(name, info), choices|
      if Date.parse(info['start_date']).cweek + 15 > Date.today.cweek
        choices[name] = info['names']
      end
      choices
    end
  end

  def list_selection
    prompt_select('List type?', list_selections)
  end

  def list_selections
    {
      groups: -> { make_groups },
      "1 list with staff": -> { one_list_with_staff },
      "3 lists with staff": -> { three_lists_with_staff },
      "1 list students only": -> { one_list_students_only }
    }
  end

  def make_groups
    puts '---student groups---'
    cohorts_by_biggest_size = @cohorts.sort_by(&:length).reverse!
    cohorts_by_biggest_size.each.with_index(1) do |cohort, index|
      if index == 1
        cohort_size_divided_by_two = (cohort.length / 2.0).floor
        cohort_size_divided_by_two.times { @groups << [] }
      end
      group_index = 0
      while cohort.length.positive?
        @groups[group_index] << cohort.delete(cohort.sample)
        group_index = group_index < (@groups.length - 1) ? (group_index + 1) : 0
      end
    end
    @groups.each { |group| puts group.join('   |   ') }
  end

  def one_list_with_staff
    remove_staff_who_are_out
    puts '---one list with staff---'
    all_people = (@lead_instructors + @coaches + @staff + @cohorts).flatten
    all_people = all_people.shuffle.shuffle.shuffle.shuffle.shuffle
    all_people.each { |person| puts person }
  end

  def three_lists_with_staff
    remove_staff_who_are_out
    puts '---three lists with staff---'
    add_instructors
    add_coaches_and_staff
    add_students
    display_each_list
  end

  def one_list_students_only
    puts '---one list students only---'
    mixed_students = @cohorts.flatten.shuffle.shuffle.shuffle.shuffle
    mixed_students.each { |student| puts student }
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
    @cohorts.each do |cohort|
      list_index = 0
      while cohort.length.positive?
        @three_lists[list_index] << cohort.delete(cohort.sample)
        list_index = list_index == 2 ? 0 : (list_index + 1)
      end
    end
  end

  def display_each_list
    @three_lists.each.with_index(1) do |list, index|
      puts "---List #{index}---- #{list.first}"
      list.shuffle.shuffle.shuffle.each { |person| puts person }
    end
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