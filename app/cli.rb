# frozen_string_literal: true

# cli class to hold app logic
class Cli
  def cohorts
    cohorts_unsorted = JSON.parse(File.read('app/cohorts.json'))
    cohorts_unsorted.sort_by { |_, info| info['start_date'] }.reverse!
  end

  def initialize
    @cohorts = cohorts
  end

  def menu
    puts "Enter the menu number of the cohort(s) you want to include in the grouping.\n"
    if @cohort_3
      list_three_cohort_options
    else
      list_two_cohort_options
    end
    cohort_choice = gets.chomp.to_i
    chosen_cohorts = cohort_map[cohort_choice]

    puts "Do you want groups of 2, 3, 4, or 5?\n"
    group_choice = gets.chomp.to_i

    student_list = chosen_cohorts.inject([]) do |all_students, cohort|
      cohort.students.each do |student|
        all_students.push(student)
      end
      all_students
    end

    cohort_students = Cohort.new(nil, student_list)
    cohort_students.pairs_of(group_choice)
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
