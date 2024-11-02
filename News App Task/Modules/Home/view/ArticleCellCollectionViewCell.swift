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
        
        image.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 20
        newsSubTitle.numberOfLines = 0
        newsSubTitle.lineBreakMode = .byWordWrapping
        newsSubTitle.backgroundColor = UIColor.systemGray5
        newsSubTitle.layer.cornerRadius = 10
        newsSubTitle.clipsToBounds = true

    }
    
    func configure(article:Article){
            let placeholderImageURL = "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"
            image.kf.setImage(with: URL(string: article.urlToImage ?? placeholderImageURL))
            
            newsTitle.text = article.title
        // for spaceing to avoid cut the word it self
        newsSubTitle.text = "\u{00A0}\u{00A0}\u{00A0}\(article.author ?? "")\u{00A0}\u{00A0}\u{00A0} "
            newsDescrption.text = article.description
        
    }

}
