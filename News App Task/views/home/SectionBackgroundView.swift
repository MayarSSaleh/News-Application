//
//  SectionBackgroundView.swift
//  News App Task
//
//  Created by mayar on 24/11/2024.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .systemGray5
    }
}
