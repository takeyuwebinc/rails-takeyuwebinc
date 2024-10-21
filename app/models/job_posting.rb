JobPosting = Data.define(:title, :slug)

class JobPosting
  def self.all
    [
      JobPosting.new(title: "Railsエンジニア", slug: "rails_engineer")
    ]
  end

  def self.find(slug)
    all.find { |job_posting| job_posting.slug == slug }
  end
end
