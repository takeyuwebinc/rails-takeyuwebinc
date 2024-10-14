class Client < ApplicationRecord
  has_many :works
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :name, presence: true
  validates :kana, presence: true
  validates :private, inclusion: { in: [ true, false ] }

  # 公開名
  def public_name
    private? ? "非公開" : name
  end
end
