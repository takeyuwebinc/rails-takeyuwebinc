WorkStyle = Data.define(:title, :description, :image)


class WorkStyle
  def self.all
    [
      WorkStyle.new(
        title: "ワークライフバランス",
        image: "undraw-digital-nomad-9-kgl.svg",
        description: "完全リモートを前提とした制度設計。通常業務のすべてをオンライン上で行うことにこだわりを持っています。しっかり休める１日６時間労働制。しかもフレックス。",
      ),
      WorkStyle.new(
        title: "エンジニアドリブン",
        image: "undraw-on-the-way-ldaq-copy.svg",
        description: "完会社の意思決定は、エンジニアでもある代表が作成した経営計画に基づいて行いますが、具体的な施策はエンジニアであるメンバーに意見を求めた上で決断しています。",
      ),
      WorkStyle.new(
        title: "個人 > 会社",
        image: "undraw-work-time-lhoj-copy.svg",
        description: "RubyKaigi に業務として参加できるなど、エンジニアの成長を積極的に支援します。個人の成長が会社やお客様の成長につながると信じています。",
      )
    ]
  end
end
