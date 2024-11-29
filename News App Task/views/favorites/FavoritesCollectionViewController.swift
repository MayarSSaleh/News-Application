//
//  FavoritesCollectionViewController.swift
//  News App Task
//
//  Created by mayar on 02/11/2024.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private var viewModel: AllFavoritesViewModelProtocol = AllFavoritesViewModel(localDataSource: LocalDataSource.shared)
   
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
            
         let backgroundImage = UIImage(named: "noFavoritesBackground")
         let backgroundImageView = UIImageView(image: backgroundImage)
         backgroundImageView.contentMode = .scaleAspectFit
         collectionView.backgroundView = backgroundImageView
        
        let numberOfCellsInARow: CGFloat = 2
        let spacesBetweenCells: CGFloat = (numberOfCellsInARow - 1) * 16
        let cellWidth = floor((collectionView.bounds.width - spacesBetweenCells) / numberOfCellsInARow)
        let cellSize = CGSize(width: cellWidth, height: (collectionView.frame.height / 2.2) - 10)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8.0
           collectionView.setCollectionViewLayout(layout, animated: false)
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.article(at: indexPath.item)
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as? ArticleDetailsViewController {
            detailsVC.imageURL = article.urlToImage
            detailsVC.titleText = article.title
            detailsVC.descriptionText = article.description
            detailsVC.authorNameText = article.author
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
