//
//  ViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Combine

class ArticlesViewController: UIViewController {
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var datePicker: UIDatePicker!
       @IBOutlet weak var searchBar: UISearchBar!
    
    
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func favButton(_ sender: UIButton) {
        print(" make navigation here witouht naviagtion bar")
    }
    
    private var viewModel: ArticlesViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
            super.viewDidLoad()
            let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear 

        datePicker.maximumDate = Date()
        datePicker.date = Date()
        
        // Set the minimum date to October 1, 2024
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          if let minDate = dateFormatter.date(from: "2024-10-01") {
              datePicker.minimumDate = minDate
          }
        
        viewModel = ArticlesViewModel()
        bindViewModel()
        viewModel.fetchArticles(for: .general)
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
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: selectedDate)
            
            print(" dateString\(dateString)")
            print(" dateString\(dateString)")
            print(" dateString\(dateString)")

            viewModel.fetchArticles(for: .userDefinedDate,from:dateString)
        }

    
//        @IBAction func searchArticles(_ sender: UISearchBar) {
//            if let searchText = sender.text, !searchText.isEmpty {
//                viewModel.fetchArticles(for: .search, searchQuery: searchText)
//            }
//        }

        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
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
                detailsVC.descriptionText = article.content
                detailsVC.authorNameText = article.author
                detailsVC.modalPresentationStyle = .fullScreen                
                present(detailsVC, animated: true, completion: nil)
             }
            
        }

}

