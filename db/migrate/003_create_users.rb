Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :login, :null => false, :size => 150
      String :email, :null => false, :size => 150
      String :avatar_url, :size => 220

      index :login, :unique => true
    end
  end

  down do
    drop_table :users
  end
end
