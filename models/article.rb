class Article < Sequel::Model

  one_to_many :article_tags, :class => 'ArticleTags'

  many_to_many :tags, :left_key=>:article_id, :right_key=>:tag_id, :join_table=>:article_tags
  many_to_one  :user

  plugin :lazy_attributes, :body, :html_body

  plugin :timestamps, :create=>:created_at, :update=>:updated_at, :update_on_create=>true

  plugin :association_dependencies
  add_association_dependencies :article_tags => :destroy

  plugin :validation_helpers

  def validate
    super
    validates_presence :title
    validates_length_range 1..179, :title
    validates_presence :body
  end

  def before_save
    self.summary = (self.body.size > 140) ? self.body.summarize(:ratio => 25) : self.body
    self.html_body = self.to_html
    super
  end

  def to_html
    GitHub::Markdown.render_gfm(self.body)
  end

  def to_permalink
    result = self.title
    # Preserve escaped octets.
    result.gsub!(/-+/, '-')
    result.gsub!(/%([a-f0-9]{2})/i, '--\1--')
    # Remove percent signs that are not part of an octet.
    result.gsub!('%', '-')
    # Restore octets.
    result.gsub!(/--([a-f0-9]{2})--/i, '%\1')
    result.gsub!(/&.+?;/, '-') # kill entities
    result.gsub!(/[^%a-z0-9_-]+/i, '-')
    result.gsub!(/-+/, '-')
    result.gsub!(/(^-+|-+$)/, '')
    "#{self.id}-#{result.downcase}"
  end

  def tags_value
    self.tags.map { |t| t.name }.join(',')
  end

  def update_tags(new_tags)
    new_tags.each { |tag| self.add_tag(tag) unless self.tags.include?(tag) }
    self.tags.each { |tag| self.remove_tag(tag) unless new_tags.include?(tag) }
  end

end
