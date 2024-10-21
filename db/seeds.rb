# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if Rails.env.development?
  Administrator.create_or_find_by(email: 'admin@example.com') do |admin|
    admin.assign_attributes(
      password: 'password',
      password_confirmation: 'password'
    )

    Announcement.create(
      title: 'サイトをリニューアルしました',
      content: 'サイトをリニューアルしました。'
    )

    Page.create(
      path: '/index.html',
      title: 'トップページ',
      markdown: <<~MARKDOWN,
        <div class="flex-col space-y-12">
          <div class="pt-5 pb-10 px-5 sm:px-10 text-left">
            <h1 class="text-2xl leading-10 font-extrabold text-gray-900 dark:text-gray-100">スペシャリストによる<br><span class="text-3xl text-red-800 dark:text-red-100">Ruby on Rails</span><br>技術支援サービス</h1>
            <p class="text-sm leading-5 text-gray-500 dark:text-gray-300 mt-3">高い専門性を武器に Ruby on Rails 開発の課題解決を強力にサポートします。</p>
          </div>

          <div class="rounded-lg bg-corporate-900 dark:bg-corporate-800 py-5 px-5 sm:px-10 text-white min-w-fit">
            <h2 class="leading-5 text-center sm:text-left">私たちは Ruby コミュニティを応援しています <i class="fa-regular fa-gem text-ruby"></i></h2>
            <div class="flex space-y-3 sm:space-y-0 flex-col sm:flex-row sm:space-x-3 justify-start pt-5 w-full">
              <div class="text-center sm:text-left">
                <%= link_to 'https://www.ruby.or.jp/ja/' do %>
                  <%= image_tag "RAsponsor-s.png", alt: "Ruby Association", class: "h-28 w-auto inline-block border-2 border-white" %>
                <% end %>
              </div>
              <div class="text-center sm:text-left">
                <%= link_to 'https://rubykaigi.org/2024/' do %>
                  <%= image_tag "rubykaigi2024.png", alt: "RubyKaigi 2024@NAHA,OKINAWA", class: "h-28 w-auto inline-block border-2 border-white" %>
                <% end %>
              </div>
              <div class="text-center sm:text-left">
                <%= link_to 'https://2023.rubyworld-conf.org' do %>
                  <%= image_tag "rwc2023-300x250.jpg", alt: "RubyWorldConference 2023@MATSUE", class: "h-28 w-auto inline-block border-2 border-white" %>
                <% end %>
              </div>
            </div>
          </div>

          <div class="px-5 sm:px-10 pt-10">
            <h2 class="text-xl sm:text-2xl leading-10 font-semibold text-gray-900 dark:text-gray-100">サービス</h2>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-8 mt-4">
              <div>
                <h3 class="font-semibold leading-10 text-gray-900 dark:text-gray-100">受託開発</h3>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">自走可能なフルサイクルエンジニアがビジネスモデルをかたちにします。モデル分析・システム設計から実装運用まですべてお任せいただけます。</p>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">新規サービス開発はもちろん、他社様で開発された Ruby on Rails アプリケーションの引継ぎと改善もお任せください。</p>
              </div>
              <div>
                <h3 class="font-semibold leading-10 text-gray-900 dark:text-gray-100">技術支援</h3>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">お客様のチームの一員となり、 Ruby on Rails やその周辺技術についての相談を受けたり、最新情報の情報共有、技術的に難しい領域の開発など、Ruby on Rails の専門家としてお客様の様々な問題解決を支援します。</p>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">Ruby on Rails にあまり詳しくなく、基盤を構築してほしい、実装難度の高いものの参考実装をしてほしいなど、ノウハウを吸収したいチームに。</p>
              </div>
              <div>
                <h3 class="font-semibold leading-10 text-gray-900 dark:text-gray-100">技術顧問</h3>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">月々一定の顧問料で Ruby on Rails やその周辺技術についての相談を受けたり、最新情報の情報共有、技術的に難しい領域の開発など、Ruby on Rails の専門家としてアドバイスをします。</p>
                <p class="text-sm leading-6 mt-2 text-gray-900 dark:text-gray-100">常時でなくても、質問や壁打ちできる相手が欲しい！そんなお客様にお勧めです。</p>
              </div>
            </div>
          </div>

          <div class="bg-corporate-800 text-white ml-[calc(50%-50vw)] mr-[calc(50%-50vw)] pl-[calc(50vw-50%)] pr-[calc(50vw-50%)]">
            <div class="px-5 sm:px-10 pt-10 pb-10">
              <h2 class="text-xl sm:text-2xl leading-10 font-semibold text-gray-100">Ruby on Rails をお勧めする理由 <i class="fa-solid fa-comment-heart"></i></h2>
              <div class="grid grid-cols-1 sm:grid-cols-3 gap-8 mt-4">
                <div>
                  <h3 class="font-semibold leading-10 text-gray-100">迅速な開発</h3>
                  <p class="text-sm leading-6 mt-2 text-gray-100">少人数で効率よくWebサービスを構築できます。</p>
                  <p class="text-sm leading-6 mt-2 text-gray-100">フルスタックのフレームワークであり、フロントエンド・バックエンドからテストまで標準のやり方があるため、効率的に開発することができます。</p>
                </div>
                <div>
                  <h3 class="font-semibold leading-10 text-gray-100">拡張性とメンテナンスのしやすさ</h3>
                  <p class="text-sm leading-6 mt-2 text-gray-100">開発効率が高くサービスの立ち上げに有利なだけでなく、十分なスキルのある技術者が適切に扱っていれば、ビジネスのスケールにも十分に追従することができます。</p>
                  <p class="text-sm leading-6 mt-2 text-gray-100">設定より規約、RAILSWAY と呼ばれる Ruby on Rails 標準の考え方・開発方法があり、これに則って構築を進めることで比較的容易に内部構造を理解できるようになり、長期的にわたってアップグレードを継続することができます。</p>
                </div>
                <div>
                  <h3 class="font-semibold leading-10 text-gray-100">成熟したコミュニティ</h3>
                  <p class="text-sm leading-6 mt-2 text-gray-100">Ruby on Rails は2005年にバージョン1.0.0が登場して以来、20年近く選ばれ続けている信頼性のあるフレームワークである一方、挑戦的な新機能の提案も続け、現在においても進化を続けている大変息の長いWebアプリケーションフレームワークです。</p>
                  <p class="text-sm leading-6 mt-2 text-gray-100">Ruby on Railsは活発なコミュニティに支えられており、多くの開発者や企業が使用しています。これにより、問題発生時の解決策が容易に見つかり、継続的なサポートやアップデートが保証されます。また、世界中の多くのプロジェクトで使用されているため、信頼性と実績があります。</p>
                </div>
              </div>
            </div>
          </div>

          <div class="px-5 sm:px-10 pt-10">
            <h2 class="text-xl sm:text-2xl leading-10 font-semibold text-gray-900 dark:text-gray-100">お知らせ</h2>
            <div class="-mx-4 mt-4 flow-root sm:mx-0">
              <table class="min-w-full">
                <colgroup>
                  <col class="w-full sm:w-3/4">
                  <col class="sm:w-1/4">
                </colgroup>
                <thead class="sm:border-b border-gray-300 text-gray-900 dark:text-gray-100">
                  <tr>
                    <th scope="col" class="hidden sm:table-cell py-3.5 pl-0 pr-3 text-left text-sm font-semibold text-gray-900">見出し</th>
                    <th scope="col" class="hidden sm:table-cell px-3 py-3.5 text-left text-sm font-semibold text-gray-900">掲載日</th>
                  </tr>
                </thead>
                <tbody>
                  <% Announcement.order(created_at: :desc).limit(5).each do |announcement| %>
                  <tr class="sm:border-b border-gray-200 dark:text-gray-100">
                    <td class="max-w-0 py-5 pl-4 pr-3 text-sm sm:pl-0">
                      <div class="font-medium text-gray-900 dark:text-gray-100"><%= link_to announcement.title, announcement %></div>
                      <div class="mt-1 truncate text-gray-500 dark:text-gray-200"><%= announcement.content.to_plain_text %></div>
                      <div class="sm:hidden py-5 text-left text-xs text-gray-500 dark:text-gray-200"><%=l announcement.created_at.to_date %></div>
                    </td>
                    <td class="hidden px-3 py-5 text-left text-sm text-gray-500 dark:text-gray-200 sm:table-cell"><%=l announcement.created_at.to_date %></td>
                  </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>

          <div class="px-5 sm:px-10 pt-10">
            <h2 class="text-xl sm:text-2xl leading-10 font-semibold text-gray-900 dark:text-gray-100">ブログ</h2>
            <div class="mt-4">
              <%= link_to 'Zenn', 'https://zenn.dev/p/takeyuwebinc', class: 'text-gray-900 dark:text-gray-100' %>
            </div>
          </div>

          <div class="px-5 sm:px-10 pt-10">
            <h2 class="text-xl sm:text-2xl leading-10 font-semibold text-gray-900 dark:text-gray-100">お問い合わせ</h2>
            <div class="mt-4">
              <%= turbo_frame_tag "new_contact", src: new_contact_path %>
            </div>
          </div>
        </div>
      MARKDOWN
    )

    Page.create(
      path: '/company/index.html',
      title: '会社情報',
      markdown: <<~MARKDOWN,
        # 見出し1
        見出し

        ## あいさつ
        あいさつが入ります。

        ### 見出し３
        テキスト

        #### 見出し４
        テキスト

        ##### 見出し５
        テキスト

        **太字**があります。

        ## 会社概要
        会社概要が入ります。
      MARKDOWN
    )

    Client.insert_all([
      {
        slug: 'takeyouweb',
        name: '株式会社テイクユーウェブ',
        kana: 'テイクユーウェブ',
        website: 'https://takeyouweb.com',
        private: false
      },
      {
        slug: 'abc',
        name: 'ABC株式会社',
        kana: 'エービーシー',
        website: nil,
        private: true
      }
    ], unique_by: :slug)
    Work.create!(
      slug: 'takeyouweb-website',
      title: 'テイクユーウェブのウェブサイト',
      client_id: Client.find_by(slug: 'takeyouweb').id,
      points: [
        'ここがポイント1',
        'ここがポイント2',
        'ここがポイント3'
      ].join("\n"),
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.jpg'), 'image/jpeg', true, original_filename: 'test.jpg'),
      description: '<p>ウェブサイトをリニューアル</p>',
      content: "<p>説明が入ります。テイクユーウェブのウェブサイトをリニューアルしました。</p>",
    )
    Work.create!(
      slug: 'video-streaming',
      title: 'ライブ配信プラットホーム',
      client_id: Client.find_by(slug: 'abc').id,
      points: [
        'WebRTCを利用したライブ配信',
        'HLSを利用したライブ配信の低遅延大規模配信',
        'HLSを利用したVOD配信'
      ].join("\n"),
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.jpg'), 'image/jpeg', true, original_filename: 'test.jpg'),
      description: '<p>ライブ配信プラットホーム</p>',
      content: "<p>説明が入ります。ライブ配信プラットホームの開発運用。</p>",
    )
    WorkStyle.new(
      slug: 'work-life-balance',
      title: 'ワークライフバランス',
      image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('app/assets/images/undraw-digital-nomad-9-kgl.svg')), content_type: 'image/svg+xml', original_filename: 'undraw-digital-nomad-9-kgl.svg'),
      description: '<p>完全リモートを前提とした制度設計。<br>通常業務のすべてをオンライン上で行うことにこだわりを持っています。<br>しっかり休める１日６時間労働制。</p>',
      content: "<p>詳しい説明があれば</p>",
    )
    WorkStyle.create!(
      slug: 'enginner-driven',
      title: 'エンジニアドリブン',
      image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/undraw-on-the-way-ldaq-copy.svg'), 'image/svg+xml', true, original_filename: 'undraw-on-the-way-ldaq-copy.svg'),
      description: '<p>完会社の意思決定は、エンジニアでもある代表が作成した経営計画に基づいて行いますが、具体的な施策はエンジニアであるメンバーに意見を求めた上で決断しています。</p>',
      content: "<p>詳しい説明があれば</p>",
    )
    WorkStyle.create!(
      slug: 'individual-over-company',
      title: '会社より個人',
      image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/undraw-work-time-lhoj-copy.svg'), 'image/svg+xml', true, original_filename: 'undraw-work-time-lhoj-copy.svg'),
      description: '<p>RubyKaigi に業務として参加できるなど、<br>エンジニアの成長を積極的に支援します。</p>',
      content: "<p>詳しい説明があれば</p>",
    )
  end
end
