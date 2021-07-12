//
//  ViewController.swift
//  hacking7
//
//  Created by pgreze on 2021/07/09.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var petitionId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Avoid to use UI stuff in a background thread.
        petitionId = (navigationController?.tabBarItem.tag ?? 0) + 1
        // == DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }
    
    @objc func fetchJson() {
        let urlString = "https://www.hackingwithswift.com/samples/petitions-\(petitionId).json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            // == performSelector(onMainThread: #selector(...), with: nil, waitUntilDone: false)
            // == tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = petitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

