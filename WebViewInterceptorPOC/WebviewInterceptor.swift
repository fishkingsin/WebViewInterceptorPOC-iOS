//
//  WebviewInterceptor.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//

import Foundation
protocol WebviewInterceptor {
    func intercept(url: URL) async throws -> Result<WebviewInterceptorResult, Error>
}

enum WebviewInterceptorError: Error {
    case invalidDomain
}
enum WebviewInterceptorResult {
    case redirect(url: URL)
    case manipulated(content: String)
}

enum DirectonResponseCode: Int {
    case permanent = 301
    case temporary = 302
}


