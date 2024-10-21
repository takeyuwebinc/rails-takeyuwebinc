class JobsController < ApplicationController
  def index
    @work_styles = WorkStyle.all
    @benefits = [
      Benefit.new(title: "完全リモートワーク", description: "オンラインで仕事ができる環境さえあれば 地方でもOK", image: "undraw-trip-dv-9-f.svg"),
      Benefit.new(title: "公平な賃金", description: "地方による給与の格差はありません", image: "salary.svg"),
      Benefit.new(title: "自分のための時間", description: "フレックスタイム＋１日６時間労働＋完全週休２日なので 自分の時間をより多く作れます", image: "undraw-time-management-30-iu.svg"),
      Benefit.new(title: "希望する端末", description: "PCのOS・メーカー・スペックは選べます", image: "undraw-devices-e-67-q.svg"),
      Benefit.new(title: "快適な開発環境への補助", description: "自宅でストレスなく開発できるよう 机や椅子やディスプレイの購入費用を 一部補助する制度があります", image: "undraw-designer-life-w-96-d.svg"),
      Benefit.new(title: "RubyKaigiへの参加", description: "技術系カンファレンスに業務として 参加する制度があります", image: "ruby.svg"),
      Benefit.new(title: "有給休暇", description: "もちろん一般的な有給休暇の制度もあります", image: "undraw-camping-j-8-s-0.svg")
    ]
    @job_postings = JobPosting.all
  end

  def show
    @job_posting = JobPosting.find(params[:id])
    raise ActionController::RoutingError, "JobPosting '#{params[:id]}' is not found" unless @job_posting
    render template: "jobs/#{@job_posting.slug}"
  end
end
