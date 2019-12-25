namespace :db do

  desc 'Create Rubric for assignments'
  task :rubric => :environment do
    puts 'Add Rubric To Assignments'
    require 'faker'
    I18n.reload!

    def pos_rand(range)
      rand(range) + 1
    end

    def random_words(range)
      Faker::Lorem.words(number: pos_rand(range)).join(' ')
    end

    def random_sentences(range)
      Faker::Lorem.sentence(word_count: pos_rand(range))
    end

    Assignment.all.each do |assignment|
      5.times do |index|
        ac = AnnotationCategory.create(assignment: assignment,
                                       position: index + 1,
                                       annotation_category_name: random_words(3))

        (rand(10) + 3).times do
          AnnotationText.create(annotation_category: ac, content: random_sentences(3), user: Admin.first)
        end
      end

      3.times do |index|
        attributes = []
        5.times do |number|
          lvl = { name: random_words(1), number: number,
                  description: random_sentences(5), mark: number }
          attributes.push(lvl)
        end

        params = { rubric: {
          name: random_sentences(1), assignment_id: assignment.id,
          position: index + 1, max_mark: 4, levels_attributes: attributes
        } }

        RubricCriterion.create!(params[:rubric])
      end

      3.times do |index|
        FlexibleCriterion.create(
            name:                    random_sentences(1),
            assignment_id:           assignment.id,
            description:             random_sentences(5),
            position:                index + 4,
            max_mark:                pos_rand(3),
            created_at:              nil,
            updated_at:              nil,
            assigned_groups_count:   nil
        )
      end

      3.times do |index|
        CheckboxCriterion.create(
            name:                    random_sentences(1),
            assignment_id:           assignment.id,
            description:             random_sentences(5),
            position:                index + 7,
            max_mark:                1,
            created_at:              nil,
            updated_at:              nil,
            assigned_groups_count:   nil
        )
      end
    end
  end
end
