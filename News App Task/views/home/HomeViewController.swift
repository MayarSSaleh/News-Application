//
//  HomeViewController.swift
//  News App Task
//
//  Created by mayar on 25/11/2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var mycollection: UICollectionView!
    
    private var viewModel = FetchByCategory(networkService: NetworkManager.shared)
    private var collectionView: UICollectionView!
    private var selectedTopic: String?
    private var cancellables = Set<AnyCancellable>()
    
     //   var categories: [String] = viewModel.categories
    var categories: [String] = ["General", "Technology", "Sports", "Health", "Business"]

        private var scrollView: UIScrollView!
        private var buttons: [UIButton] = []
        private var selectedButton: UIButton?

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCategoriesScrollView()
            setUp()
            bindViewModel()
        }
        
        private func setupCategoriesScrollView() {
            // Create a UIScrollView and add it to categoriesView
            scrollView = UIScrollView(frame: categoriesView.bounds)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.backgroundColor = .yellow

            categoriesView.addSubview(scrollView)
            
            // Add buttons to the scroll view for each category
            var xOffset: CGFloat = 10 // Initial spacing
            let buttonHeight: CGFloat = categoriesView.frame.height - 10
            let buttonPadding: CGFloat = 10
            
            for (index, category) in categories.enumerated() {
                // Create a button
                let button = UIButton(type: .system)
                button.setTitle(category, for: .normal)
                button.frame = CGRect(x: xOffset, y: 5, width: 100, height: 100)

                // Style the button
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = (index == 0) ? UIColor.systemBlue : UIColor.white
                button.setTitleColor((index == 0) ? .white : .black, for: .normal)
                
                // Add action for the button
                button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
                
                // Set the first button as selected
                if index == 0 {
                    selectedButton = button
                }
                
                // Add the button to the scroll view
                scrollView.addSubview(button)
                buttons.append(button)
                
                // Update xOffset for the next button
                xOffset += button.frame.width + buttonPadding
            }
            
            // Set the scroll view content size
            scrollView.contentSize = CGSize(width: xOffset, height: categoriesView.frame.height)
        }

        @objc private func categoryButtonTapped(_ sender: UIButton) {
            // Update the appearance of the selected and previous button
            selectedButton?.backgroundColor = .white
            selectedButton?.setTitleColor(.black, for: .normal)
            
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
            selectedButton = sender
            
            // Handle the category selection logic
            if let category = sender.title(for: .normal) {
                print("Selected category: \(category)")
                // Update the collection view or perform other actions based on the selected category
            }
        }
    
  
    
    private func setUp(){
        let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
        mycollection.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
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

extension HomeViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
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
                    detailsVC.modalPresentationStyle = .fullScreen
                    present(detailsVC, animated: true, completion: nil)
                 }
                
            }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y //This value indicates how far the content has been scrolled vertically.
            let contentHeight = scrollView.contentSize.height //Represents the total height of the content inside the scroll view, including parts not currently visible.
            
            let frameHeight = scrollView.frame.size.height //Represents the visible height of the scroll view
            
            if offsetY > contentHeight - frameHeight * 2{ // Trigger when close to bottom
                viewModel.loadMoreArticles(resultAbout: selectedTopic)
            }
        }
    }

