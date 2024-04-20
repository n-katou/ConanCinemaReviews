class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.date :release_date
      t.string :poster_path
      t.text :overview

      t.timestamps
    end
  end
end
