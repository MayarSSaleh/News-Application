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
        newsSubTitle.backgroundColor = UIColor.systemGray5
        newsSubTitle.layer.cornerRadius = 10
        newsSubTitle.clipsToBounds = true
    }
    
    func configure(article:Article){
        newsTitle.text = article.title
        newsSubTitle.text = "\u{00A0}\u{00A0}\(article.author ?? "")\u{00A0}"
        newsDescrption.text = article.description
        let url = URL(string: article.urlToImage ?? "")
        image.kf.setImage(
            with: url,
            placeholder: UIImage(named: "no-image"),
            options: [.transition(.fade(0.3))]
        )
    }

}
