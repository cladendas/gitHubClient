//
//  WKWebViewViewController.swift
//  networking
//
//  Created by cladendas on 17.05.2021.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var wkWebView: WKWebView!
    
    ///Страница автора
    var htmlUrl = ""
    
    override func loadView() {
        
        //JavaScript для фона
        let backgroundGray = "document.body.style.background= \"#777\";"
        let userScript = WKUserScript(source: backgroundGray, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = userContentController
        wkWebView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        view = wkWebView
        wkWebView.reload()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tmpUrl = URL(string: htmlUrl)
        let request = URLRequest(url: tmpUrl!)
        wkWebView.load(request)
        wkWebView.allowsBackForwardNavigationGestures = true
    }
    
}
