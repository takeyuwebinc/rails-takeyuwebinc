function handler(event) {
    var request = event.request;

    // X-Forwarded-Host を設定しても経路上で追記でなく上書きされることがあることがわかった（Tailscale Funnelではそう）
    // そのため、新しいヘッダーを追加したうえで、Rails (Rack) でそれを使って X-Forwarded-Host を組み立てることにした
    // request.headers["x-forwarded-host"] = request.headers.host;
    request.headers["viewer-host"] = request.headers.host;

    return request;
}
