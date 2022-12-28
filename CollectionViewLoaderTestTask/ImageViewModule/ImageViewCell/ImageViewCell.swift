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
                andCompletion completion: @escaping () -> Void,
                errorCompletion: @escaping () -> Void)
}

class ImageViewCell: UICollectionViewCell {
    enum MoveDirection {
        case right, top
    }
    var imageView: UIImageView?
    var loadingIndicator: UIActivityIndicatorView?
    static let reuseIdentifier = "ImageViewCellID"
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
    }
    
    func configure(withArguments arguments: LoadImageArgument,
                   useCase: LoadImageHelper,
                   indexPath: IndexPath) {
        self.imageView?.isHidden = false
        self.imageWasNotLoadedYet = true
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.configure(withArguments: arguments,
                               useCase: useCase,
                               indexPath: indexPath)
            }
            return
        }
        useCase.perform(arguments, indexPath: indexPath, completion: { imageInfo in
                DispatchQueue.main.async {
                    self.imageView?.image = imageInfo.image
                    self.imageView?.isHidden = false
                    self.loadingIndicator?.isHidden = true
                    self.loadingIndicator?.stopAnimating()
                    self.imageWasNotLoadedYet = false
                    
                }
        }, fileLoadingCompletion: {
            DispatchQueue.main.async {
                self.imageView?.isHidden = true
                self.loadingIndicator?.isHidden = false
                self.loadingIndicator?.startAnimating()
            }
        })
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        return super.apply(layoutAttributes)
    }
}

extension ImageViewCell: DestinationCellProtocol {
    
    func delete(withDelay delay: Double,
                offset: CGFloat,
                andCompletion completion: @escaping () -> Void,
                errorCompletion: @escaping () -> Void) {
        guard self.imageWasNotLoadedYet == false else {
            errorCompletion()
            return
        }
        UIView.animate(withDuration: delay,
                       delay: 0,
                       options: .curveLinear) {
            self.center = CGPoint(x: offset + self.bounds.width * 0.5,
                                  y: self.frame.midY)
        } completion: { _ in
            self.imageView?.isHidden = true
            completion()
        }
    }
    
}
