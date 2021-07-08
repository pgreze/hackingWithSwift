//
//  ViewController.swift
//  hacking4
//
//  Created by pgreze on 2021/07/08.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://pgreze.dev")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension ViewController : WKNavigationDelegate {
    
}
