//
//  CustomCollectionView.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 15.12.2022.
//

import AVFoundation
import UIKit

enum InteractionState {
    case enabled
    case disabled
}

enum LayoutState {
    case ready
    case configuring
}

protocol LayoutChangeHandler {
    var needsUpdateOffset: Bool { get }
    var targetIndex: Int { get }
    var layoutState: LayoutState { get set }
}

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    enum InteractionState {
        case enabled
        case disabled
    }
    
    var currentIndexPathPage = IndexPath(item: 0, section: 0)
    var config = Configuration()
    var interactionState: InteractionState = .disabled
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
         
    
    var itemsCount: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    var offset: CGPoint {
        collectionView?.contentOffset ?? .zero
    }

    var offsetWithoutInsets: CGPoint {
        CGPoint(x: offset.x, y: offset.y + farInset)
    }

    var insets: UIEdgeInsets {
        UIEdgeInsets(top: farInset, left: .zero, bottom: farInset, right: .zero)
    }

    var farInset: CGFloat {
        guard let collection = collectionView else { return .zero }
        return (collection.bounds.height - itemSize.height - config.distanceBetween) / 2
    }

    var relativeOffset: CGFloat {
        guard let collection = collectionView else { return .zero }
        return (collection.contentOffset.y + collection.contentInset.top) / collectionViewContentSize.height
    }

    var nearestIndex: Int {
        let offset = relativeOffset
        let floatingIndex = offset * CGFloat(itemsCount) + 0.5
        return max(0, min(Int(floor(floatingIndex)), itemsCount - 1))
    }
}

extension CustomCollectionViewLayout {

    struct Configuration {
        let maxAspectRatio: CGFloat = 5
        let minAspectRatio: CGFloat = 0.2
        let defaultAspectRatio: CGFloat = 1.0

        let distanceBetween: CGFloat = 20
        let distanceBetweenFocused: CGFloat = 20

        var expandingRate: CGFloat = 1
    }
}

extension CGSize {
    var aspectRatio: CGFloat {
        return width / height
    }
}


extension CustomCollectionViewLayout {

    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            let size = CGSize(
                width: collectionView.bounds.width,
                height: collectionView.bounds.width)
            itemSize = size
            collectionView.contentOffset = targetContentOffset(forProposedContentOffset: offset)
        }
    }

    final override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
    }

    final override func finalizeCollectionViewUpdates() {
        
//        CATransaction.commit()
        
    }
    

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pageHeight = itemSize.height
        let targetYContentOffset = proposedContentOffset.y
        guard let collectionView = self.collectionView else {
            return . zero
        }
        let contentHeight = collectionView.contentSize.height
        var newPage: CGFloat = 0.0
        let collectionItemSize = self.itemSize.height
        if velocity.y == 0 {
            newPage = ceil((targetYContentOffset + 0.5 * self.itemSize.height) /
                            collectionItemSize) - 1.0
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
