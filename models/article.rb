class Article < Sequel::Model

  one_to_many :article_tags, :class => 'ArticleTags'

  many_to_many :tags, :left_key=>:article_id, :right_key=>:tag_id, :join_table=>:article_tags
  many_to_one  :user

  plugin :association_dependencies
  add_association_dependencies :article_tags => :destroy

  plugin :validation_helpers

  def validate
    super
    validates_presence :title
    validates_length_range 1..179, :title
    validates_presence :body
  end

end
