//
//  DefaultWebviewInterceptor.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//
import Foundation

class DefaultWebviewInterceptor: WebviewInterceptor {
    func intercept(url: URL) async throws -> Result<WebviewInterceptorResult, Error> {
        let (data, response) = try await (URLSession.shared.data(from: url) as? (Data, HTTPURLResponse))!
        let code = response.statusCode
        guard let redirectURL = response.url else {
            return .failure(WebviewInterceptorError.invalidDomain)
        }
        debugPrint ("Response code: \(code) data: \(data) response: \(response)")
        debugPrint("redirectURL \(redirectURL)")
        debugPrint ("Redirecting to \(url)")
        return .success(.passthrough(url: redirectURL))
    }
}
