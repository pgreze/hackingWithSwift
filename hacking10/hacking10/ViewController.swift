//
//  ViewController.swift
//  hacking10
//
//  Created by pgreze on 2021/07/12.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        load()
    }
    
    func oldLoad() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    func oldSave() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData: Data = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // CollectionView "Estimated size: None" in order to have the good size for cells:
    // https://stackoverflow.com/a/38028106
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a PersonCell")
        }

        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            
            self?.collectionView.reloadItems(at: [indexPath])
            self?.save()
        })

        present(ac, animated: true)
    }
}

extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension ViewController : UINavigationControllerDelegate {
}
