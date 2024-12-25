//
//  WebView.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//

import SwiftUI
import Foundation
@preconcurrency import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            guard navigationAction.navigationType == .other else {
                return .allow
            }
            
            
            guard let url = navigationAction.request.url,
                  let host = url.host,
                  let domain = DomainName(rawValue: host) else {
                return .allow
            }
            let interceptor = domain.webviewInterceptor
            do {
                let result = try await interceptor.intercept(url: url)
                switch result {
                case .success(let webViewInterceptorResult):
                    switch webViewInterceptorResult {
                    case .passthrough(url: let url):
                        webView.load(URLRequest(url: url))
                        return .cancel
                    case .manipulated(let content):
                        webView.loadHTMLString(content, baseURL: nil)
                        debugPrint("manipulated intercepted: \(result) \(url)")
                        return .cancel
                    }
                    
                case .failure:
                    debugPrint("Invalid domain intercepted: \(result) \(url)")
                }
            } catch {
                debugPrint(error)
            }
            return .allow
        }
    }
}
