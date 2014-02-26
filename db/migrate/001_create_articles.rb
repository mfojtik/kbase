Sequel.migration do
  up do
    create_table :articles do
      primary_key :id
      foreign_key :user_id, :users
      String :title, :size => 180, :null => false
      Text :body
      index :user_id
    end
  end

  down do
    drop_table :articles
  end
end
