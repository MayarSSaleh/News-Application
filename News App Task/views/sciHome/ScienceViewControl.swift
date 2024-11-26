//
//  ScienceViewControl.swift
//  News App Task
//
//  Created by mayar on 25/11/2024.
//

import UIKit
import Combine

class ScienceViewControl: UIViewController {

        @IBOutlet weak var mycollection: UICollectionView!

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
        }
        
        
        private func bindViewModel() {
            viewModel.$articles
                .sink { [weak self] _ in
                    self?.mycollection.reloadData()
                 //   self?.activityIndicator.stopAnimating()
                }
                .store(in: &cancellables)
            
    //        viewModel.$isLoading
    //            .sink { [weak self] isLoading in
    //                if isLoading {
    //                  self?.activityIndicator.startAnimating()
    //                } else {
    //                   self?.activityIndicator.stopAnimating()
    //                }
    //            }
    //            .store(in: &cancellables)
    //
            viewModel.$errorMessage
                .sink { [weak self] errorMessage in
                    if let message = errorMessage {
                        self?.showAlert(message: message)
                    }
                }
                .store(in: &cancellables)
        }
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }

    extension ScienceViewControl: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                    return viewModel.articles.count
                }

         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellCollectionViewCell", for: indexPath) as! ArticleCellCollectionViewCell
                    let article = viewModel.articles[indexPath.item]
                   cell.configure(article: article)
                    return cell
                }
                
         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                    let width = (collectionView.frame.width / 2) - 10
                    let height = (collectionView.frame.height / 2.5) - 10
                    return CGSize(width: width, height: height)
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
        
            func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let frameHeight = scrollView.frame.size.height
                if offsetY > contentHeight - frameHeight * 2{
                    viewModel.loadMoreArticles(resultAbout: "science")
                }
            }
        }

