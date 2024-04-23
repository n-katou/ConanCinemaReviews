class RemoveApiIdFromMovies < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :api_id, :integer
  end
end
