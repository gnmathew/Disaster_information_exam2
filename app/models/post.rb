class Post < ApplicationRecord
  before_create :assign_unique_short_url
  default_scope { where(deleted_at: nil) }

  validates :title, presence: true
  validates :content, presence: true
  validates :address, presence: true

  has_many :comments
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'

  geocoded_by :ip_address

  def destroy
    update(deleted_at: Time.current)
  end

  private

  def assign_unique_short_url
    loop do
      self.short_url = format('%04d', rand(10_000))
      break unless Post.exists?(short_url: self.short_url)
    end
  end
end
