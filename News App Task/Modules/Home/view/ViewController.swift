//
//  ViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Combine

class ArticlesViewController: UIViewController {
    
    var selectedDate : String?
    var selectedTopic: String?
    
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var datePicker: UIDatePicker!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func favButton(_ sender: UIButton) {
        if let favVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
            favVC.modalPresentationStyle = .fullScreen
            present(favVC, animated: true, completion: nil)
         }
    }
    
    private var viewModel: ArticlesViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
            super.viewDidLoad()
        
        searchBar.delegate = self
        
        viewModel = ArticlesViewModel()
        setUp()
        bindViewModel()
        viewModel.fetchArticles()
        
        }
    
    
    private func setUp(){
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        datePicker.maximumDate = Date()
        datePicker.date = Date()
        
        // Set the minimum date to October 2, 2024 as it my limit according the api
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          if let minDate = dateFormatter.date(from: "2024-10-02") {
              datePicker.minimumDate = minDate
          }
        
            let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
        }

        private func bindViewModel() {
            viewModel.$articles
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
                .store(in: &cancellables)

            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isLoading in
                    if isLoading {
                        self?.activityIndicator.startAnimating()
                    } else {
                        self?.activityIndicator.stopAnimating()
                    }
                }
                .store(in: &cancellables)

            viewModel.$errorMessage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] errorMessage in
                    if let message = errorMessage {
                        self?.showAlert(message: message)
                    }
                }
                .store(in: &cancellables)
        }

        @IBAction func fetchByDate(_ sender: Any) {
            let userChooseDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: userChooseDate)

            selectedDate = dateString
            
//            viewModel.fetchArticles( from: dateString)

            viewModel.fetchArticles(resultAbout: selectedTopic, from: dateString)
        }

        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }


extension ArticlesViewController : UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//         // Dismiss the keyboard
//         searchBar.resignFirstResponder()
//         
//         guard let searchText = searchBar.text, !searchText.isEmpty else { return }
//         viewModel.fetchArticles(resultAbout: searchText)
//     }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchText.isEmpty {
             viewModel.fetchArticles()
         }else{
             selectedTopic = searchText
//             viewModel.fetchArticles(resultAbout: searchText)
             viewModel.fetchArticles(resultAbout: searchText, from: selectedDate)
         }
     }
    
}

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

