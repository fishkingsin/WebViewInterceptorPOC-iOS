//
//  EbxshWebviewInterceptor.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//

import Foundation
import Alamofire
final class NetworkInterceptor: RequestInterceptor {
    func adapt(request: URLRequest) throws -> URLRequest {
        var request = request
        
        return request
    }
}

actor NetworkManager {
    func request (
        method: HTTPMethod,
        url: String,
        headers: [String: String],
        params: Parameters?,
        interceptor: RequestInterceptor? = nil,
        dataPreprocessor: DataPreprocessor? = nil
    ) async throws -> String {
        // Set Encoding
        var encoding: ParameterEncoding = JSONEncoding.default
        switch method {
        case .post:
            encoding = JSONEncoding.default
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        
        // You must resume the continuation exactly once
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: HTTPHeaders(headers),
                interceptor: interceptor
            )
            .responseString(dataPreprocessor: dataPreprocessor ?? .passthrough, encoding: .utf8) { response in
                
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    debugPrint("Error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

final class EbxshDataProcessor: DataPreprocessor {
    func preprocess(_ data: Data) throws -> Data {
        guard let string = String(data: data, encoding: .utf8) else {
            return data
        }
        
        let manipulatedString: String = string
            .replacing(
                "setTimeout(function() {",
                with: "/*\nsetTimeout(function() {"
            ).replacing(
            "}, 1000);",
            with: "}, 1000); \n*/\nwindow. history.go(-1);"
        )
        
        return Data(manipulatedString.utf8)
    }
}

class EbxshWebviewInterceptor: WebviewInterceptor {
    func intercept(url: URL) async throws -> Result<WebviewInterceptorResult, Error> {
        let network = NetworkManager()
        do {
            let response: String = try await network.request(
                method: .get,
                url: url.absoluteString,
                headers: [:],
                params: [:],
                interceptor: NetworkInterceptor(),
                dataPreprocessor: EbxshDataProcessor()
            )
            
            debugPrint("response: \(response)")
            
            
            return .success(WebviewInterceptorResult.manipulated(content: response))
        } catch {
            return .failure(WebviewInterceptorError.invalidDomain)
        }
    }
}
