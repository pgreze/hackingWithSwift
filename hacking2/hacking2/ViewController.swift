//
//  ViewController.swift
//  hacking2
//
//  Created by pgreze on 2021/07/07.
//

import UIKit

class ViewController: UIViewController {
    
    // https://stackoverflow.com/a/53860888/5489877
    lazy var titleLabel: UILabel = newCenteredLabel()
    lazy var scoreLabel: UILabel = newCenteredLabel()
    lazy var titleView: UIStackView = {
        let container = UIStackView(arrangedSubviews: [titleLabel, scoreLabel])
        container.axis = .vertical
        return container
    }()
    
    lazy var buttons: [UIButton] = (0...2).map { (tag) -> UIButton in
        var button = UIButton()
        button.tag = tag
        // https://stackoverflow.com/a/40869466
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    lazy var countryContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: buttons)
        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .equalSpacing
        // Select AutoLayout and not old systems (frame or layoutMask??)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    lazy var verticalConstraints = [ // Notice: safeAreaLayoutGuide from iOS11 https://stackoverflow.com/a/47236131/5489877
        countryContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0),
        countryContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
        countryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0),
        countryContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
    ]
    lazy var horizontalConstraints = [ // Notice: safeAreaLayoutGuide from iOS11 https://stackoverflow.com/a/47236131/5489877
        countryContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        countryContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        countryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        countryContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    ]
    
    var countries: [String] = [
        "estonia",
        "france",
        "germany",
        "ireland",
        "italy",
        "monaco",
        "nigeria",
        "poland",
        "russia",
        "spain",
        "uk",
        "us",
    ]
    private var correctAnswer: Int = 0
    private var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        buttons.forEach { (button) in
        //            button.layer.borderWidth = 1
        //            button.layer.borderColor = UIColor.lightGray.cgColor
        //        }
        
        //buttons.forEach { (button) in button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) }
        
        // Notice: titleView is always mask,
        // so never use "translatesAutoresizingMaskIntoConstraints = false"
        navigationItem.titleView = titleView
        view.backgroundColor = UIColor.systemGray6
        
        view.addSubview(countryContainer)
        //resolveLayouts()
        
        askQuestion()
    }
    
    override func viewWillLayoutSubviews() {
        //        if view.traitCollection.horizontalSizeClass == .compact {
        //            titleView.axis = .vertical
        //            titleView.spacing = 0.0 // UIStackView.spacingUseDefault
        //        } else {
        //            titleView.axis = .horizontal
        //            titleView.spacing = 20.0
        //        }
        // TODO: avoid assuming anything about landscape.
        if UIDevice.current.orientation.isLandscape {
            titleView.axis = .horizontal
            titleView.spacing = 20.0
            
            countryContainer.axis = .horizontal
            NSLayoutConstraint.deactivate(verticalConstraints)
            NSLayoutConstraint.activate(horizontalConstraints)
        } else {
            titleView.axis = .vertical
            titleView.spacing = 0.0 // UIStackView.spacingUseDefault
            
            countryContainer.axis = .vertical
            NSLayoutConstraint.deactivate(horizontalConstraints)
            NSLayoutConstraint.activate(verticalConstraints)
        }
    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransition(to: size, with: coordinator)
    //        resolveLayouts()
    //    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        titleLabel.text = countries[correctAnswer]
        scoreLabel.text = "Score: \(score)"
        zip(buttons, countries[0...2]).forEach { (button, country) in
            button.setImage(UIImage(named: country), for: .normal)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let title: String
        // Notice: tag was setup for each button
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        let ac = UIAlertController(
            title: title,
            message: "Your score is \(score)",
            preferredStyle: .alert
        )
        ac.addAction(
            UIAlertAction(
                title: "Continue",
                style: .default,
                handler: nil
            )
        )
        present(ac, animated: true, completion: askQuestion)
    }
}

private func newCenteredLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    return label
}
