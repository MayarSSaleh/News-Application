//
//  DetailsViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    var imageURL: String?
    var titleText: String?
    var descriptionText: String?
    var authorNameText : String?
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        print (" title \(titleText ?? " ")")
        print (" imageURL \(imageURL ?? " ")")
        print (" descriptionText \(descriptionText ?? " ")")
        print (" authorNameText \(authorNameText ?? " ")")
        
        // titleLabel.text = titleText
        //        descriptionLabel.text = descriptionText ?? ""
        //        authorName.text = authorNameText ?? ""
        //        imageView.kf.setImage(with: URL(string: imageURL ?? ""))
    }
    
    
    @IBAction func AddToFavourite(_ sender: Any) {
        print("Add to favorite")
        
        guard let title = titleText,
              let imageURL = imageURL,
              let description = descriptionText,
              let author = authorNameText else {
            // Show alert for missing data
            showAlert(message: "Please fill in all fields.")
            return
        }

            let addStatus = FavouriteNewsViewModel.addToFav(title: title, imageURL: imageURL, descrption: description, author: author)
            
            if addStatus {
                // Dismiss the view controller first
                dismiss(animated: true) {
                    // Show alert with options after dismissal
                    let alert = UIAlertController(title: "Success", message: "Successfully added to favorites. Do you want to remove it?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                        // Call the function to remove from favorites
                        self.removeFromFavorites(title: title)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    // Present the alert from the root view controller or previous view controller
                    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                        rootVC.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                showAlert(message: "Failed to add to favorites. Please try again.")
            }
        }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func removeFromFavorites(title: String) {
        // Implement the logic to remove the article from favorites
        let removeStatus = FavouriteNewsViewModel.removeFromFav(title: title)
        
        if removeStatus {
            print("Successfully removed from favorites.")
            // Optionally, show a message or update the UI
        } else {
            print("Failed to remove from favorites.")
            // Optionally, show an error message
        }
    }
}
