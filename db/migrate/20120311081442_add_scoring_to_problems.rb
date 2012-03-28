class AddScoringToProblems < ActiveRecord::Migration
 add_column :problems, :scoring, :text
end
