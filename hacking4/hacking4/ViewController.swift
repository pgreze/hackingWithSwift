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
    lazy var backButton: UIBarButtonItem = .init(title: "Back", style: .plain, target: self, action: #selector(goBack))
    lazy var forwardButton: UIBarButtonItem = .init(title: "Forward", style: .plain, target: self, action: #selector(goForward))
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.sizeToFit()
        return view
    }()
    let urls: [String] = [
        "pgreze.dev",
        "mercari.com"
    ]

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        // Allows to have the refresh button on the right.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [backButton, forwardButton, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.allowsBackForwardNavigationGestures = true
        // Listen for webView.estimatedProgress updates
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        openUrl(urls[0])
    }
    
    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        urls.forEach { (url) in
            ac.addAction(UIAlertAction(title: url, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    private func openPage(_ action: UIAlertAction) {
        guard let title = action.title else { return }
        openUrl(title)
    }
    
    private func openUrl(_ url: String) {
        webView.load(URLRequest(url: URL(string: "https://\(url)")!))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Called after using addObserver
        if keyPath == "estimatedProgress" {
            progressView.isHidden = false
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc private func goBack() {
        webView.goBack()
    }
    
    @objc private func goForward() {
        webView.goForward()
    }
}

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.url?.host
        progressView.isHidden = true
        
        backButton.isEnabled = !webView.backForwardList.backList.isEmpty
        forwardButton.isEnabled = !webView.backForwardList.forwardList.isEmpty
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let host = navigationAction.request.url?.host else { return }
        if !urls.filter({ (url) -> Bool in host.hasSuffix(url) }).isEmpty {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)

            let ac = UIAlertController(title: "Forbidden", message: "Cannot access the external domain \(host)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}
