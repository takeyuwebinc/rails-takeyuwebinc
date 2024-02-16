# CloudFront ViewerRequest イベントでセットした VIEWR_HOST ヘッダーを使って、HTTP_X_FORWARDED_HOST ヘッダーを書き換える
# Tailscale Funnel では SNI を利用する関係で Host ヘッダーは xxxxxxx.xxxxxxxx.ts.net でなくてはならないので、CloudFront から Host ヘッダーを転送できない
# CloudFront ViewerRequest で HTTP_X_FORWARDED_HOST を設定していても、経路中で上書きされ  xxxxxxx.xxxxxxxx.ts.net になってしまったので、ここで末尾に追加する
# rackでは末尾の値が優先される為
# https://github.com/rack/rack/blob/ae7d6a171963a70918b4e43525408c571a3f28fe/lib/rack/request.rb#L402
class ProxyViewerHost
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless env["HTTP_VIEWER_HOST"]

    env["HTTP_X_FORWARDED_HOST"] = [ env["HTTP_X_FORWARDED_HOST"].presence, env["HTTP_VIEWER_HOST"].presence ].compact.join(", ")

    @app.call(env)
  end
end
