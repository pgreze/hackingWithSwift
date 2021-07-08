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
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.sizeToFit()
        return view
    }()

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // Allows to have the refresh button on the right.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.allowsBackForwardNavigationGestures = true
        // Listen for webView.estimatedProgress updates
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        openUrl("pgreze.dev")
    }
    
    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "pgreze.dev", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "mercari.com", style: .default, handler: openPage))
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
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.url?.host
    }
}
