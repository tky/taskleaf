class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_include_comma

  has_one_attached :image
  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  paginates_per 5

  def self.csv_attributes
    %w(name description created_at updated_at)
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{|attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |raw|
      task = new
      task.attributes = raw.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_include_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
