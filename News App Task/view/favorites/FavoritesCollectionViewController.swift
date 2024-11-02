//
//  FavoritesCollectionViewController.swift
//  News App Task
//
//  Created by mayar on 02/11/2024.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private var viewModel = FavoritesViewModel()
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
         
     }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavorites()
        collectionView.reloadData()
    }
    private func setUP(){
        let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
    collectionView.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
            
    // Set up background image view
         let backgroundImage = UIImage(named: "noFavoritesBackground")
         let backgroundImageView = UIImageView(image: backgroundImage)
         backgroundImageView.contentMode = .scaleAspectFit
         collectionView.backgroundView = backgroundImageView
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ( viewModel.numberOfArticles > 0){
            collectionView.backgroundView?.isHidden = true
        }else {
            collectionView.backgroundView?.isHidden = false
        }
        return viewModel.numberOfArticles
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellCollectionViewCell", for: indexPath) as! ArticleCellCollectionViewCell
        
        let article = viewModel.article(at: indexPath.item)
        cell.configure(article: article)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        let height = (collectionView.frame.height / 2.5) - 10
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.article(at: indexPath.item)
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            detailsVC.imageURL = article.urlToImage
            detailsVC.titleText = article.title
            detailsVC.descriptionText = article.description
            detailsVC.authorNameText = article.author
            detailsVC.modalPresentationStyle = .fullScreen
            present(detailsVC, animated: true, completion: nil)
        }
    }
}
