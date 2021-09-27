//
//  ReflexViewControllerCell.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import UIKit

class ReflexViewControllerCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted == true {
                backgroundColor = .blue
            } else {
                backgroundColor = .lightGray
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .blue : .lightGray
        }
    }
    
    static func register(in collectionView: UICollectionView) {
        let identifier = String(describing: ReflexViewControllerCell.self)
        collectionView.register(ReflexViewControllerCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
