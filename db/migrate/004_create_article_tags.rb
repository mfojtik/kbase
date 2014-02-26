Sequel.migration do
  up do
    create_table :article_tags do
      primary_key :id
      foreign_key :tag_id, :tags
      foreign_key :article_id, :articles
      index [ :tag_id, :article_id ], :unique=>true
    end
  end

  down do
    drop_table :article_tags
  end
end
