//
//  ScienceViewControl.swift
//  News App Task
//
//  Created by mayar on 25/11/2024.
//

import UIKit
import Combine
import Lottie

class ScienceViewControl: NetworkBaseViewController {

    @IBOutlet weak var mycollection: UICollectionView!
    private  let activityIndicator = UIActivityIndicatorView(style: .large)
    let animationView = LottieAnimationView(name: "offline")

        private var viewModel = FetchByCategory(networkService: NetworkManager.shared)
        private var cancellables = Set<AnyCancellable>()
    
        override func viewDidLoad() {
            super.viewDidLoad()
              setUp()
              bindViewModel()
           }
        override func viewWillAppear(_ animated: Bool) {
            viewModel.fetchArticlesByCategory(category: "science")
        }

        private func setUp(){
            let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
            mycollection.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
            mycollection.layer.cornerRadius = 10
            
                   activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                   view.addSubview(activityIndicator)

                   NSLayoutConstraint.activate([
                       activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                   ])
            
            let numberOfCellsInARow: CGFloat = 2
            let spacesBetweenCells: CGFloat = (numberOfCellsInARow - 1) * 16
            let cellWidth = floor((mycollection.bounds.width - spacesBetweenCells) / numberOfCellsInARow)
            let cellSize = CGSize(width: cellWidth, height: (mycollection.frame.height / 2.2) - 10)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = cellSize
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8.0
            mycollection.setCollectionViewLayout(layout, animated: false)
        }
   
     override func handleNoNetwork() {
         if viewModel.articles.isEmpty {
             playLottieAnimation(animationView: animationView)
         }else {
         }
         self.activityIndicator.stopAnimating()
         self.showAlert()
     }
    
   override func handleNetworkAvailable() {
       animationView.stop()
       animationView.removeFromSuperview()
    viewModel.fetchArticlesByCategory(category: "science")
    }
   
    
    private func bindViewModel() {
            viewModel.$articles
                .sink { [weak self] _ in
                    self?.mycollection.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
                .store(in: &cancellables)
            
            viewModel.$isLoading
                .sink { [weak self] isLoading in
                    if isLoading {
                      self?.activityIndicator.startAnimating()
                    } else {
                       self?.activityIndicator.stopAnimating()
                    }
                }
                .store(in: &cancellables)
        }
    }

    extension ScienceViewControl: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.articles.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if indexPath.row == viewModel.articles.count - 1 {
         viewModel.loadMoreArticles(resultAbout: "science")
         }
         }
        /** the above method is more easily
         func scrollViewDidScroll(_ scrollView: UIScrollView) {
             let offsetY = scrollView.contentOffset.y
             let contentHeight = scrollView.contentSize.height
             let frameHeight = scrollView.frame.size.height
             if offsetY > contentHeight - frameHeight * 2{
                 viewModel.loadMoreArticles(resultAbout: "science")
             }
         }
         */
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellCollectionViewCell", for: indexPath) as! ArticleCellCollectionViewCell
                    let article = viewModel.articles[indexPath.item]
                   cell.configure(article: article)
                    return cell
                }

          func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    let article = viewModel.articles[indexPath.item]
                    if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as? ArticleDetailsViewController {
                        detailsVC.imageURL = article.urlToImage
                        detailsVC.titleText = article.title
                        detailsVC.descriptionText = article.description
                        detailsVC.authorNameText = article.author
                        navigationController?.pushViewController(detailsVC, animated: true)
                    }
                }
        }

