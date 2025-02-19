class ServicesController < ApplicationController
  include EnableCacheControlPublic

  def index
    @clients = Client.public_only.order(:kana)
    @services = find_services
  end

  def show
    slug = params[:id].to_s
    slug.gsub!(/[^a-z0-9_]/, "")
    @services = find_services(slug)
    render template: "services/#{slug}"
  rescue ActionView::MissingTemplate
    raise ActionController::RoutingError, "'services/#{slug}' is not found"
  end

  private

  def find_services(key = nil)
    service_names = {
      "remote_team" => [ "Webサービス開発", "インフラ開発", "コードベース改善", "新規サービス開発", "保守開発" ],
      "technichal_advisor" => [ "技術顧問", "コードレビュー", "開発基盤改善", "Ruby on Rails アップグレード", "システム設計" ],
      "outsourcing" => []
    }
    services = {
      "コードベース改善" => { outline: "テスト品質・カバレッジの向上、リファクタリング、技術的負債の返済。\n保守しやすく事業環境の変化に早く対応できる優れたコードに。", image: "undraw-maintenance-cn-7-j.svg" },
      "Ruby on Rails アップグレード" => { outline: "セキュアで開発効率の高い最新の Ruby on Rails に対応。", image: "undraw_upgrade_re_gano.svg" },
      "技術顧問" => { outline: "高度な技能を持つエンジニアがお客様のチームの技術向上をお助けします。\n技術選択の支援、品質管理、コードレビューなど、多種多様な要望にお応えできます。", image: "undraw-co-workers-ujs-6.svg" },
      "クラウドネイティブ開発" => { outline: "ジネスの成功にあわせて増加するアクセスにも対応でき安心。\nAWS 等の各種クラウドを活用し、スケール可能なサービスを開発します。", image: "undraw-cloud-hosting-aodd.svg" },
      "新規サービス開発" => { outline: "まずは小さなものから、ユーザーの反応を確かめながら無駄なく開発を進めます。", image: "undraw-growing-rk-7-d.svg" },
      "保守開発" => { outline: "古いRailsアプリケーションを運用しているお客様の、セキュリティリスクや機能追加の困難さを回避するため、新しいバージョンのRubyやRuby on Railsにアップグレードしたいという要望にお応えします。\n他社様により開発されたRailsアプリケーションの開発を引き継ぎ、よりよくしていくことももちろん可能。", image: "undraw_QA_engineers_dg5p.svg" },
      "リプレース" => { outline: "レガシーシステムから脱却し、最新技術にアップデート。\nこれまでできなかった新しい価値の提供を可能にし、顧客満足を向上させます。", image: "undraw-product-teardown-elol.svg" },
      "リモートSES" => { outline: "確かな技術と経験を持つハイレベルなエンジニアが開発をサポート。\nリモートでも安心して任せられるエンジニアリング・サービスを提供します。", image: "undraw-collaboration-2-8-og-0.svg" },
      "コードレビュー" => { outline: "見落とされている不具合はないか、ActiveRecordをはじめとしたライブラリの使い方が適切か、保守性を損なうまずい実装が含まれていないかなどを確認します。", image: "undraw_pair_programming_njlp.svg" },
      "開発基盤改善" => { outline: "開発環境の改善、CI/CDの導入、コード品質の向上、開発プロセスの改善など、開発基盤の改善を行います。", image: "undraw-maintenance-cn-7-j.svg" },
      "システム設計" => { outline: "ビジネスチームからの要求を受けて、実現可能なシステムの仕様策定や設計を行います。", image: "undraw_operating_system_4lr6.svg" },
      "Webサービス開発" => { outline: "Webサービスの開発をまるごとお任せいただけます。また、iOS/Androidアプリと協調して動くサーバー開発の実績もあります。\n技術的なことはすべてタケユー・ウェブのリモートチームにお任せいただけるので、お客様は最も大切なサービスデザインに集中できます。", image: "undraw-chatting-2-yvo.svg" },
      "インフラ開発" => { outline: "要件に合わせてクラウドサーバー、オンプレサーバー問わず、調達と構築を実施し、運用可能な状態にします。", image: "undraw-cloud-hosting-aodd.svg" }
    }
    services.each do |name, service|
      service[:title] = name
    end
    (service_names.key?(key) ? services.values_at(*service_names[key]) : services.values.flatten).sort_by { |service| service[:title] }
  end
end
