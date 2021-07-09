//
//  ViewController.swift
//  hacking6
//
//  Created by pgreze on 2021/07/09.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var labels = [
        ("THESE", UIColor.red),
        ("ARE", UIColor.cyan),
        ("SOME", UIColor.yellow),
        ("AWESOME", UIColor.green),
        ("LABELS", UIColor.orange),
    ].enumerated().map { (index, value) -> (String, UILabel) in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = value.1
        label.text = value.0
        label.sizeToFit()
        return ("label\(index+1)", label)
    }.reduce(into: [:]) { $0[$1.0] = $1.1 }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labels.forEach { view.addSubview($0.value) }
        
        for label in labels.keys {
            // H: = horizontal, | = the edge of the view (=VC)
            // == each of our labels should stretch edge-to-edge in our view
            // Exp: H:|[label1]|
            addConstraints(withVisualFormat: "H:|[\(label)]|")
        }
        
        let metrics = ["labelHeight": 88]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(88@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: labels))
    }
    
    private func addConstraints(withVisualFormat: String) {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withVisualFormat, options: [], metrics: nil, views: labels))
    }
}

