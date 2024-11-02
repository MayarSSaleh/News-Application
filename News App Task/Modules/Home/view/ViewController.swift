//
//  ViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Combine

class ArticlesViewController: UIViewController {
        @IBOutlet weak var collectionView: UICollectionView! // Assuming you have a UICollectionView outlet
        @IBOutlet weak var datePicker: UIDatePicker! // Assuming you have a date picker for user-defined dates
        @IBOutlet weak var searchBar: UISearchBar! // Assuming you have a search bar for searching articles
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // Outlet for the activity indicator

        private var viewModel: ArticlesViewModel!
        private var cancellables = Set<AnyCancellable>()

        override func viewDidLoad() {
            super.viewDidLoad()
            // Bind the view model to the collection view
            bindViewModel()
            viewModel.fetchArticles(for: .general)
        }

        private func bindViewModel() {
            viewModel.$articles
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating() // Stop the activity indicator
                }
                .store(in: &cancellables)

            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isLoading in
                    if isLoading {
                        self?.activityIndicator.startAnimating() // Start the activity indicator
                    } else {
                        self?.activityIndicator.stopAnimating() // Stop it when not loading
                    }
                }
                .store(in: &cancellables)

            viewModel.$errorMessage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] errorMessage in
                    if let message = errorMessage {
                        // Show error alert
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

            viewModel.fetchArticles(for: .userDefinedDate, date: dateString)
        }

        @IBAction func searchArticles(_ sender: UISearchBar) {
            if let searchText = sender.text, !searchText.isEmpty {
                viewModel.fetchArticles(for: .search, searchQuery: searchText)
            }
        }

        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - UICollectionViewDataSource
    extension ArticlesViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.articles.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellCollectionViewCell", for: indexPath) as! ArticleCellCollectionViewCell
            let article = viewModel.articles[indexPath.item]
            cell.configure(with: article)
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate
    extension ArticlesViewController: UICollectionViewDelegate {
        // Implement any delegate methods if needed
    }
