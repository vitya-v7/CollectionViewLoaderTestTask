//
//  CustomCollectionView.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 15.12.2022.
//

import AVFoundation
import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    var currentIndexPathPage = IndexPath(item: 0, section: 0)
    
    override init() {
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionViewLayout {
    var offset: CGPoint {
        collectionView?.contentOffset ?? .zero
    }
}

extension CustomCollectionViewLayout {

    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            let size = CGSize(
                width: collectionView.bounds.width - 20,
                height: collectionView.bounds.width - 20)
            itemSize = size
            collectionView.contentOffset = targetContentOffset(forProposedContentOffset: offset)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView,
              UIDevice.current.orientation == .portrait else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        
        let pageHeight = collectionView.bounds.width - 20
        let targetYContentOffset = proposedContentOffset.y
        let contentHeight = collectionView.contentSize.height
        var newPage: CGFloat = 0.0
        let collectionItemSize = self.itemSize.height
        if velocity.y == 0 {
            newPage = ceil((targetYContentOffset - 0.5 * pageHeight) /
                            collectionItemSize)
        } else {
            newPage = CGFloat(velocity.y > 0 ?
                              self.currentIndexPathPage.item + 1 :
                                self.currentIndexPathPage.item - 1)
            if newPage < 0 {
                newPage = 0
            }
            if newPage > contentHeight / pageHeight {
                newPage = ceil(contentHeight / pageHeight) - 1.0
            }
        }
        let centeringValue = max(CGFloat(newPage * pageHeight) - 0.5 * pageHeight, 0)

        let point = CGPoint(x: proposedContentOffset.x, y: centeringValue)
        self.currentIndexPathPage = IndexPath(item: Int(newPage), section: 0)
        return point
    }
    
}
