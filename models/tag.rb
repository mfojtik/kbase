class Tag < Sequel::Model

  many_to_many :articles, :left_key=>:tag_id, :right_key=>:article_id,
    :join_table=>:article_tags

  one_to_many :article_tags, :class => 'ArticleTags'

  plugin :timestamps, :create=>:created_at, :update=>:updated_at, :update_on_create=>true

  plugin :association_dependencies
  add_association_dependencies :article_tags => :destroy

  plugin :validation_helpers

  def validate
    super
    validates_presence :name
    validates_length_range 1..59, :name
    validates_format(/^([a-zA-Z0-9_]+)$/, :name)
    validates_unique :name
  end

  def ordered_articles
    self.articles_dataset.order(Sequel.desc(:updated_at)).all
  end

end
