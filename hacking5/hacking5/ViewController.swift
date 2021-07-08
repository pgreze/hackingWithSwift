//
//  ViewController.swift
//  hacking5
//
//  Created by pgreze on 2021/07/08.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        guard let path = Bundle.main.url(forResource: "start", withExtension: "txt") else { return }
        guard let startWords = try? String(contentsOf: path) else { return }
        allWords = startWords.components(separatedBy: "\n")
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc private func promptForAnswer() {
        let ac = UIAlertController(title: "Answer", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.accessibilityLabel = "Insert your answer"
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }))
        present(ac, animated: true)
    }
    
    private func submit(_ answer: String) {
        let answer = answer.lowercased()
        guard !answer.isEmpty else { return }
        guard isOriginal(word: answer) else {
            return showAlert(title: "Word already used", message: "Be more original!")
        }
        guard isPossible(word: answer) else {
            return showAlert(title: "Word not possible", message: "You can't spell that word from \(title!.lowercased())!")
        }
        guard isReal(word: answer) else {
            return showAlert(title: "Word not recognized", message: "You can't just make them up, you know!")
        }
        
        usedWords.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf8.count) // utf16 too much?
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}
