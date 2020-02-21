//
//  AppWebViewController+WebViewDelegate.swift
//  Tripp
//
//  Created by Puneet Rangnekar on 17/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension AppWebViewController : UIWebViewDelegate {
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        AppLoader.showLoader()
        // show loader
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        AppLoader.hideLoader()
        // stop loader
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        AppLoader.hideLoader()
        // show alert, stop loader
    }

    
}
