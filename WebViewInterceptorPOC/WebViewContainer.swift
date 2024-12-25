//
//  ContentView.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//
import SwiftUI

struct WebViewContainer: View {
    @State private var urlString: String = "https://ebx.sh/e3TNyP"
    @State private var interceptedURL: URL?

    var body: some View {
        VStack {
            // Input URL TextField
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Load Button
            Button("Load URL") {
                if let url = URL(string: urlString) {
                    interceptedURL = url
                }
            }
            .padding()

            // WebView
            if let url = interceptedURL {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Enter a valid URL to load.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}


#Preview {
    WebViewContainer()
}
