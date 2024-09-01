//
//  WebView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    var url: URL
    @Binding var showWebView: Bool
    @Binding var codeReponse: String
 
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let urlString = navigationAction.request.url?.absoluteString,
               urlString.starts(with: GutifyConstants.redirectUri) {
                if let code = URLComponents(string: urlString)?.queryItems?.first(where: { $0.name == "code" })?.value {
                    self.parent.codeReponse = code
                }
                self.parent.showWebView = false
            }
            decisionHandler(.allow)
        }
        
    }
}
