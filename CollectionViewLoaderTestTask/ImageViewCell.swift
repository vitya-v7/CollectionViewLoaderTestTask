//
//  ImageViewCell.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 17.12.2022.
//

import Foundation
import UIKit

protocol DestinationCellProtocol {
    func delete(withDelay delay: Double,
                offset: CGFloat,
                andCompletion completion: @escaping () -> Void)
}

class ImageViewCell: UICollectionViewCell {
    enum MoveDirection {
        case right, top
    }
    var imageView: UIImageView?
    var loadingIndicator: UIActivityIndicatorView?
    static let reuseIdentifier = "ImageViewCellID"
    let useCase = LoadImageHelper(clientService: OperationImageAPIService.shared,
                                       imageCacheStorage: ImageCacheStorage(),
                                       fileManagerService: FileManagerService())
    private var imageWasNotLoadedYet = true
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView(frame: frame)
        if let imageView = imageView {
            self.addSubview(imageView)
            imageView.constraint(toView: self)
        }
        self.imageView?.contentMode = .scaleAspectFit
        self.loadingIndicator = UIActivityIndicatorView(style: .large)
        if let loadingIndicator = loadingIndicator {
            self.addSubview(loadingIndicator)
            loadingIndicator.constraint(toView: self)
        }
        self.loadingIndicator?.hidesWhenStopped = true
        self.loadingIndicator?.style = .large
        self.loadingIndicator?.color = .black
        self.loadingIndicator?.startAnimating()
        self.loadingIndicator?.isHidden = false
    }
    
    func configure(withArguments arguments: LoadImageArgument,
                   indexPath: IndexPath) {
        self.imageView?.isHidden = false
        self.imageWasNotLoadedYet = true
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.configure(withArguments: arguments,
                               indexPath: indexPath)
            }
            return
        }
        useCase.perform(arguments, indexPath: indexPath) { imageInfo in
            DispatchQueue.main.async {
                self.imageView?.image = imageInfo.image
                self.loadingIndicator?.isHidden = true
                self.loadingIndicator?.stopAnimating()
                self.imageWasNotLoadedYet = false
            }
        }
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        return super.apply(layoutAttributes)
    }
}

extension ImageViewCell: DestinationCellProtocol {
    
    
    func delete(withDelay delay: Double,
                offset: CGFloat,
                andCompletion completion: @escaping () -> Void) {
        guard self.imageWasNotLoadedYet == false else {
            return
        }
        UIView.animate(withDuration: delay,
                       delay: 0,
                       options: .curveLinear) {
            self.center = CGPoint(x: offset + self.bounds.width * 0.5,
                                  y: self.frame.midY)
        } completion: { isSuccess in
            self.imageView?.isHidden = true
            completion()
        }
    }
    
}
