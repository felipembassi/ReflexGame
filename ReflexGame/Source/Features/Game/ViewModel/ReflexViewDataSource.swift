//
//  ReflexCollectionViewDataSource.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 25/09/21.
//

import Foundation
import UIKit

class ReflexViewDataSource: NSObject {
    static let insetValue: CGFloat = 4
    static let minimumSpacing: CGFloat = 2
    static let minimumInterItemSpacing: CGFloat = 1
    static let spacing: CGFloat = minimumSpacing + minimumSpacing
    static let numberOfRows: Int = 4
    static let numberOfSections: Int = 4
    
    var selectedIndex: IndexPath?
    weak var viewModel: ReflexViewModelProtocol?
    
    required init(viewModel: ReflexViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    private func cellSize(for collectionView: UICollectionView) -> CGSize {
        let calculatedWidth = collectionView.frame.width / CGFloat(Self.numberOfRows) - Self.spacing
        let calculatedHeight = collectionView.frame.height / CGFloat(Self.numberOfSections) - (Self.spacing + Self.minimumInterItemSpacing)
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}

extension ReflexViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Self.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Self.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ReflexViewControllerCell.self), for: indexPath)
        if indexPath == selectedIndex {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .lightGray
        }
        return cell
    }
}

extension ReflexViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.viewModel?.readUserInput(for: indexPath)
    }
}

extension ReflexViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(for: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Self.minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Self.minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case .zero:
            return UIEdgeInsets(top: Self.insetValue,
                                left: Self.insetValue,
                                bottom: Self.minimumSpacing,
                                right: Self.insetValue)
            
        case Self.numberOfSections:
            return UIEdgeInsets(top: Self.minimumSpacing,
                                left: Self.insetValue,
                                bottom: Self.insetValue,
                                right: Self.insetValue)
        default:
            return UIEdgeInsets(top: Self.minimumSpacing,
                                left: Self.insetValue,
                                bottom: Self.minimumSpacing,
                                right: Self.insetValue)
        }
    }
}
