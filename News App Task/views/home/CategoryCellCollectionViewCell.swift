//
//  CategoryCellCollectionViewCell.swift
//  News App Task
//
//  Created by mayar on 24/11/2024.
//

import UIKit

class CategoryCellCollectionViewCell: UICollectionViewCell {

    private var containerView: UIView!
    private var categoryLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBlue
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        categoryLabel.textColor = .white
        
        containerView.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            categoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }

    func configure(with category: String) {
        categoryLabel.text = category
    }
}

