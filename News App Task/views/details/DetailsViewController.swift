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
    
    private var isFavorite: Bool = false
 
    private var addRemovFavViewModel: AddRemoveFavouriteNewsViewModelProtocol = FavouriteNewsViewModel(localDataSource: LocalDataSource())
    private var allFavViewModel: AllFavoritesViewModelProtocol = AllFavoritesViewModel(localDataSource: LocalDataSource())

    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkIfFavorite()

    }
    
    @IBAction func AddToFavourite(_ sender: Any) {
        if isFavorite {
      removeFromFav()
    } else {
        addToFav()
        }
    }
    
    private func setupUI() {
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
        if let imageURL = imageURL, !imageURL.trimmingCharacters(in: .whitespaces).isEmpty {
            let url = URL(string: imageURL)
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "no-image"),
                options: [.transition(.fade(0.3))]
            )
        } else {
            imageView.image = UIImage(named: "no-image")
        }
    }
    private func checkIfFavorite() {
        guard let title = titleText else { return }
           isFavorite = allFavViewModel.isArticleFavorite(title: title)
           updateFavoriteButtonTitle()
       }
       
    private func updateFavoriteButtonTitle() {
           let buttonTitle = isFavorite ? "Remove from Favorites" : "Add to Favorites"
           favButton.setTitle(buttonTitle, for: .normal)
       }
       
    
     func removeFromFav(){
        guard let title = titleText else {
            showAlert(message: "Sorry error in data loading .Please try again")
            return
        }
        let confirmationAlert = UIAlertController(
            title: "Delete Confirmation",
            message: "Are you sure you want to remove this article from your favorites?",
            preferredStyle: .alert
        )

        confirmationAlert.addAction(UIAlertAction(
            title: "Yes",
            style: .destructive,
            handler: { _ in
                let removeStatus = self.addRemovFavViewModel.removeFromFav(title: title)
                if removeStatus {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: "Failed to remove from favorites. Please try again.")
                }
            }
        ))
        confirmationAlert.addAction(UIAlertAction(title: "No",style: .cancel,handler: nil ))
        present(confirmationAlert, animated: true, completion: nil)

    }
    
    private func addToFav(){
        guard let title = titleText,
              let description = descriptionText,
              let author = authorNameText else {
            showAlert(message: "Sorry error in data loading .Please try again")
            return
        }
        let addStatus = self.addRemovFavViewModel.addToFav(title: title, imageURL: imageURL ?? "", description: description, author: author)
        if addStatus {
            isFavorite = true
            dismiss(animated: true) {
                let alert = UIAlertController(title: self.titleText ?? "Added", message: "added to favorites successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                    FavouriteNewsViewModel().removeFromFav(title: title)
                }))
                 alert.addAction(UIAlertAction(title: "Ok",style: .default,handler: nil))
                
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
            
}
