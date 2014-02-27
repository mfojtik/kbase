Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String :name, :null => false, :size => 60
      DateTime :created_at
      DateTime :updated_at
      index :name, :unique => true
    end
  end

  down do
    drop_table :tags
  end
end
