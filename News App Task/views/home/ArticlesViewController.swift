//
//  ViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Combine

class ArticlesViewController: UIViewController {
    
    private var selectedDate : String?
    private var selectedTopic: String?
    private var viewModel = FetchArticlesViewModel(networkService: NetworkManager.shared)
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        setUp()
        bindViewModel()
      //  setupSearchTextDebounce()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchArticlesByParameters()
    }
    
    private func setUp(){
            let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
    }


    private func bindViewModel() {
            viewModel.$articles
                .sink { [weak self] _ in
                    self?.collectionView.reloadData()
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

            viewModel.$errorMessage
                .sink { [weak self] errorMessage in
                    if let message = errorMessage {
                        self?.showAlert(message: message)
                    }
                }
                .store(in: &cancellables)
        }
    
    
//    private func setupSearchTextDebounce() {
//          searchTextSubject
//              .debounce(for: .seconds(2), scheduler: RunLoop.main)
//              .sink { [weak self] searchText in
//                  if !searchText.isEmpty {
//                          self?.selectedTopic = searchText
//                          self?.viewModel.resetPagination()
//                          self?.viewModel.fetchArticlesByParameters(resultAbout: searchText, from: self?.selectedDate)
//                      } else {
//                          self?.viewModel.resetPagination()
//                          self?.viewModel.fetchArticlesByParameters()
//                      }
//                  }
//              .store(in: &cancellables)
//      }
    
//        @IBAction func fetchByDate(_ sender: Any) {
//            let userChooseDate = datePicker.date
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let dateString = dateFormatter.string(from: userChooseDate)
//            
//            selectedDate = dateString
//            
//            viewModel.resetPagination()
//            viewModel.fetchArticlesByParameters(resultAbout: selectedTopic, from: dateString)
//        }

        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }


//extension ArticlesViewController : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//       searchTextSubject.send(searchText)
//    }
//}



extension ArticlesViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
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
            let height = (collectionView.frame.height / 2) - 10
            return CGSize(width: width, height: height)
        }

                
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.item]
        
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as? ArticleDetailsViewController {
            detailsVC.imageURL = article.urlToImage
            detailsVC.titleText = article.title
            detailsVC.descriptionText = article.description
            detailsVC.authorNameText = article.author
            
            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
 /*
  The scrollViewDidScroll(_:) function is part of the UIScrollViewDelegate protocol, and it is automatically called whenever the user scrolls a UIScrollView or its subclasses (like UICollectionView or UITableView).
  */

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y //This value indicates how far the content has been scrolled vertically.
        let contentHeight = scrollView.contentSize.height //Represents the total height of the content inside the scroll view, including parts not currently visible.
        
        let frameHeight = scrollView.frame.size.height //Represents the visible height of the scroll view
        
        if offsetY > contentHeight - frameHeight * 2{ // Trigger when close to bottom
            viewModel.loadMoreArticles(resultAbout: selectedTopic, from: selectedDate)
        }
    }
}


