class Client < ApplicationRecord
  has_many :works
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :name, presence: true
  validates :kana, presence: true
  validates :private, inclusion: { in: [ true, false ] }

  scope :public_only, -> { where(private: false) }

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "id_value", "kana", "name", "private", "slug", "updated_at", "website" ]
  end

  # 公開名
  def public_name(suffix: "")
    private? ? "非公開のお客様" : "#{name}#{suffix}"
  end
end
