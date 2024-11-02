//
//  ArticleCellCollectionViewCell.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit

class ArticleCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    
    @IBOutlet weak var newsDescrption: UILabel!
    @IBOutlet weak var newsSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(article:Article){
        if(article.author == nil){
            print(" artical is nil")
        }else {
            
            if let url = URL(string: article.urlToImage) {
                image.kf.setImage(with: url)
            }
    //        image.image = donlod it
            print("article \(article.author ?? "" ) article.title\(article.title) article.desc\(String(describing: article.description))")
            
            
            newsTitle.text = article.title
            newsSubTitle.text = article.author ?? "no authour name found"
            newsDescrption.text = article.description
        }
        
    }

}
