//
//  ArticleCellCollectionViewCell.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import UIKit
import Kingfisher


class ArticleCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    
    @IBOutlet weak var newsDescrption: UILabel!
    @IBOutlet weak var newsSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
               image.layer.cornerRadius = 25
        contentView.backgroundColor = UIColor.white

        newsSubTitle.backgroundColor = UIColor.systemGray5
        newsSubTitle.layer.cornerRadius = 50
    }
    
    func configure(article:Article){
        if(article.author == nil){
            print(" artical is nil")
        }else {        
            let placeholderImageURL = "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"
                       image.kf.setImage(with: URL(string: article.urlToImage ?? placeholderImageURL))
                      
            newsTitle.text = article.title
            newsSubTitle.text = article.author ?? "no authour name found"
            newsDescrption.text = article.description
        }
        
    }

}
