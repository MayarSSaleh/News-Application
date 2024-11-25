//
//  ViewController.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Combine
import UIKit
import Combine

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var newsTitle: UILabel!
    private var selectedTopic = "general"
    private var viewModel = FetchByCategory(networkService: NetworkManager.shared)
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchArticlesByCategory(category: selectedTopic)
    }
    
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        collectionView.register(UINib(nibName: "ArticleCellCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "ArticleCellCollectionViewCell")
        
        collectionView.register(CategoryCellCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCellCollectionViewCell")
        
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        // no need for that ,as i make all collection view with dame bavkground
        collectionView.collectionViewLayout.register(SectionBackgroundView.self, forDecorationViewOfKind: "backgroundDecoration")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemGray6
        collectionView.layer.cornerRadius = 15
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 0 {
                return self.createCategorySection()
            } else {
                return self.createArticleSection()
            }
        }
        return layout
    }
 
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Adds spacing around each item. For example:

        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: -7)
        // Define the group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Define the section with horizontal scrolling
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    /*
     fractionalWidth or fractionalHeight
     These are proportions of the container’s width or height.
     Example: .fractionalWidth(0.5) means the item will take 50% of the container's width.
     estimated
     Provides an estimated size that can dynamically adjust based on the content.
     Example: For text-based items, the height might grow to fit the content.
     absolute
     Fixed size that does not change, regardless of the screen size or container dimensions.
     */
    private func createArticleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.7))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))//Defines the size of the group, which contains one or more items.

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: -30, trailing: 0) //Adds padding around the entire section.
        
        // Add a decoration item for the background
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "backgroundDecoration")
        section.decorationItems = [backgroundDecoration] 

        
        return section
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension ArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.categories.count
        } else {
            return viewModel.articles.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellCollectionViewCell", for: indexPath) as! CategoryCellCollectionViewCell
            let category = viewModel.categories[indexPath.item]
            cell.configure(with: category)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCellCollectionViewCell", for: indexPath) as! ArticleCellCollectionViewCell
            let article = viewModel.articles[indexPath.item]
            cell.configure(article: article)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.section == 0 {
            let selectedCategory = viewModel.categories[indexPath.item]
                print("Selected Category: \(selectedCategory)")
                // Perform any action with the selected category
                selectedTopic = selectedCategory
                viewModel.fetchArticlesByCategory(category: selectedCategory)
            } else if indexPath.section == 1 {
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
 

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as! SectionHeaderView
           header.configure(title: "Categories:")
            return header
        }
        return UICollectionReusableView()
    }
}
