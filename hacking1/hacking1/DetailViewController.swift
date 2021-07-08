//
//  DetailViewController.swift
//  hacking1
//
//  Created by pgreze on 2021/07/07.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        // Add the share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        guard let imagePath = selectedImage else { return }
        imageView.image = UIImage(named: imagePath)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        // With jpeg: 100KB
        guard let image: Data = imageView.image?.jpegData(compressionQuality: 0.8) else {
        // With png: 600KB
        //guard let image: UIImage = imageView.image else {
            print("No image to share")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, "photo.jpeg"], applicationActivities: [])
        // For iPad, allows to show the share dialog next to the button triggering the action.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        // https://stackoverflow.com/questions/59433926/error-sharesheet-connection-invalidated-error-ios13-but-not-on-ios-11-4
        // Not working but I'll keep it...
        vc.popoverPresentationController?.sourceView = navigationItem.titleView
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
