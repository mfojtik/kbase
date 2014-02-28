Sequel.migration do
  up do
    add_column :articles, :edited_by, Integer
  end

  down do
  end
end
