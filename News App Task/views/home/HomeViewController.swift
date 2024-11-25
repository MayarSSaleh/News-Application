//
//  HomeViewController.swift
//  News App Task
//
//  Created by mayar on 25/11/2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mycollection: UICollectionView!
    @IBOutlet weak var categoriesStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!

    private var viewModel = FetchByCategory(networkService: NetworkManager.shared)
    private var selectedTopic: String?
    private var cancellables = Set<AnyCancellable>()
    private var buttons: [UIButton] = []
    private var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
          addCategories()
          setUp()
          bindViewModel()
         viewModel.fetchArticlesByCategory(category: "general")
       }

    private func setUp(){
        let nibCell = UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil)
        mycollection.register(nibCell, forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
        mycollection.layer.cornerRadius = 10
    }
    
   private func addCategories() {
        var categories: [String] = viewModel.categories

           categoriesStack.spacing = 17
           categoriesStack.distribution = .equalSpacing
           
           for (index, category) in categories.enumerated() {
               let button = UIButton(type: .system)
               button.setTitle(category, for: .normal)
               button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
               button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
               button.layer.borderWidth = 1
               button.layer.borderColor = UIColor.lightGray.cgColor
               button.layer.cornerRadius = 15
               button.setTitleColor(.black, for: .normal)
               button.backgroundColor = (index == 0) ? UIColor.systemBlue : UIColor.white
               button.setTitleColor((index == 0) ? .white : .black, for: .normal)
               button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
                   
               if index == 0 { // Set the first button as selected
                   selectedButton = button
               }
               categoriesStack.addArrangedSubview(button)
           }
       }

     @objc private func categoryButtonTapped(_ sender: UIButton) {
            selectedButton?.backgroundColor = .white // return to itis normal color
            selectedButton?.setTitleColor(.black, for: .normal)
            
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
            selectedButton = sender
            
            if let category = sender.title(for: .normal) {
                viewModel.fetchArticlesByCategory(category: category)
            }
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
                let height = (collectionView.frame.height / 2.2) - 10
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
                viewModel.loadMoreArticles(resultAbout: selectedTopic)
            }
        }
    }

