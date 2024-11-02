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
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
//        print (" title 000\(titleText ?? " ")")
//        print (" imageURL 00000\(imageURL ?? " ")")
//        print (" descriptionText 00000\(descriptionText ?? " ")")
//        print (" authorNameText 00000000\(authorNameText ?? " ")")
//        
        favButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        favButton.layer.cornerRadius = 20
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        authorName.lineBreakMode = .byWordWrapping
        authorName.backgroundColor = UIColor.systemGray5
        authorName.layer.cornerRadius = 10
        authorName.clipsToBounds = true
        
        
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText ?? ""
        // to make space before the word
        authorName.text = "\u{00A0}\u{00A0}\u{00A0}\(authorNameText ?? "")\u{00A0}\u{00A0}\u{00A0} "


        imageView.contentMode = .scaleAspectFit
        if let imageURL = imageURL, !imageURL.trimmingCharacters(in: .whitespaces).isEmpty {
            let url = URL(string: imageURL)
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "no-image"),
                options: [.transition(.fade(0.3))]
            )
        } else {
            // Set the placeholder image when imageURL is empty or nil
            imageView.image = UIImage(named: "no-image")
        }

    }
    
    
    @IBAction func AddToFavourite(_ sender: Any) {
        print("Add to favorite")
        
                guard let title = titleText,
                      let description = descriptionText,
                      let author = authorNameText else {
                    // Show alert for missing data
                    showAlert(message: "Please fill in all fields.")
                    return
                }
        
        let addStatus = FavouriteNewsViewModel.addToFav(title: title, imageURL: imageURL ?? "", descrption: description, author: author)
        
                    if addStatus {
                        // Dismiss the view controller first
                        dismiss(animated: true) {
                            // Show alert with options after dismissal
                            let alert = UIAlertController(title: self.titleText ?? "Added", message: "added to favorites successfully", preferredStyle: .alert)
        
                            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                                self.removeFromFavorites(title: title)
                            }))
                
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
                
                print("Successfully removed from favorites. no code yet")

//                let removeStatus = FavouriteNewsViewModel.removeFromFav(title: title)
//        
//                if removeStatus {
//                    print("Successfully removed from favorites. no code yet")
//                } else {
//                    print("Failed to remove from favorites. no code yet ")
//                }
            }
}
