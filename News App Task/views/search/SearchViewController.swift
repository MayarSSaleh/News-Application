//
//  SearchViewController.swift
//  News App Task
//
//  Created by mayar on 24/11/2024.
//

import UIKit
import Combine
import Lottie


class SearchViewController: NetworkBaseViewController {
     
        private var selectedDate : String?
        private var selectedTopic: String?
        private var searchTimer: Timer?
        private var viewModel = FetchArticlesViewModel(networkService: NetworkManager.shared)
        private var cancellables = Set<AnyCancellable>()
        private var searchTextSubject = PassthroughSubject<String, Never>()
   
    
        private var lottieAnimationView: LottieAnimationView?
       let offlinelottie = LottieAnimationView(name: "offline")

        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var datePicker: UIDatePicker!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
        
        override func viewDidLoad() {
                super.viewDidLoad()
            searchBar.delegate = self
            setUp()
            bindViewModel()
            setupSearchTextDebounce()
        }
        
    override func handleNoNetwork() {
        if viewModel.articles.isEmpty {
            lottieAnimationView?.stop()
            playLottieAnimation(animationView: offlinelottie)
            searchBar.isUserInteractionEnabled = false
        }
        self.activityIndicator.stopAnimating()
        self.showAlert()
    }
   
  override func handleNetworkAvailable() {
      offlinelottie.stop()
      offlinelottie.removeFromSuperview()
      searchBar.isUserInteractionEnabled = true
   }
  
        private func setUp(){
            self.activityIndicator.stopAnimating()

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
            
            //lottie
                lottieAnimationView = LottieAnimationView(name: "searchAnimation")
            lottieAnimationView?.frame = collectionView.frame
                lottieAnimationView?.contentMode = .scaleAspectFit
                lottieAnimationView?.loopMode = .loop
                lottieAnimationView?.isHidden = true
                view.addSubview(lottieAnimationView!)
            
                   NSLayoutConstraint.activate([
                       activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                   ])
        }


        private func bindViewModel() {
                viewModel.$articles
                    .sink { [weak self] articles in
                        guard let self = self else { return }

                        print(" $articles are changed ")
                        if articles.isEmpty {
                                    self.collectionView.isHidden = true
                                    self.lottieAnimationView?.isHidden = false
                                    self.lottieAnimationView?.play()
                                } else {
                                    self.collectionView.isHidden = false
                                    self.lottieAnimationView?.isHidden = true
                                    self.lottieAnimationView?.stop()
                                }

                                self.collectionView.reloadData()
                                self.activityIndicator.stopAnimating()
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

//                viewModel.$errorMessage // as error from network , alart will be called and no network method
//                    .sink { [weak self] errorMessage in
//                        if let message = errorMessage {
//                            self?.showAlert()
//                        }
//                    }
//                    .store(in: &cancellables)
            }
        
        
        private func setupSearchTextDebounce() {
              searchTextSubject
                  .debounce(for: .seconds(2), scheduler: RunLoop.main)
                  .sink { [weak self] searchText in
                      if !searchText.isEmpty {
                          print("searchText\(searchText)")
                              self?.selectedTopic = searchText
                              self?.viewModel.resetPagination()
                              self?.viewModel.fetchArticlesByParameters(resultAbout: searchText, from: self?.selectedDate)
                          } else {
                              self?.viewModel.resetPagination()
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
                
                viewModel.resetPagination()
                viewModel.fetchArticlesByParameters(resultAbout: selectedTopic, from: dateString)
            }
        }


    extension SearchViewController : UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchTextSubject.send(searchText)
        }
    }



    extension SearchViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
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
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
  
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y //This value indicates how far the content has been scrolled vertically.
            let contentHeight = scrollView.contentSize.height //Represents the total height of the content inside the scroll view, including parts not currently visible.
            let frameHeight = scrollView.frame.size.height //Represents the visible height of the scroll view
            if offsetY > contentHeight - frameHeight * 2{ // Trigger when close to bottom
                viewModel.loadMoreArticles(resultAbout: selectedTopic, from: selectedDate)
            }
        }
    }
