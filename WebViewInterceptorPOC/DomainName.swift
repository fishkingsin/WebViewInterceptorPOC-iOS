//
//  DomainName.swift
//  WebViewInterceptorPOC
//
//  Created by James Kong on 25/12/2024.
//


import Foundation

enum DomainName: String {
    case bitly = "bit.ly"
    case t = "t.co"
    case googl = "goo.gl"
    case tinyurl = "tinyurl.com"
    case ow = "ow.ly"
    case isgd = "is.gd"
    case buffly = "buff.ly"
    case adfly = "adf.ly"
    case mcafee = "mcaf.ee"
    case pnmgcomhk = "p.nmg.com.hk"
    case ebxsh = "ebx.sh"

    var webviewInterceptor: WebviewInterceptor {
        switch self {
        case .ebxsh:
            return EbxshWebviewInterceptor()
        default:
            return DefaultWebviewInterceptor()
        }
    }
}
