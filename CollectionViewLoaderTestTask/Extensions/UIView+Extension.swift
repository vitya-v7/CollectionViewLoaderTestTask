//
//  UIView+Extension.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 17.12.2022.
//

import Foundation
import UIKit

extension UIView {
    func constraint(toView outsideView: UIView,
                    top: CGFloat = 0.0,
                    bottom: CGFloat = 0.0,
                    left: CGFloat = 0.0,
                    right: CGFloat = 0.0) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.constraint(toView: outsideView,
                                top: top,
                                bottom: bottom,
                                left: left,
                                right: right)
            }
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: outsideView.topAnchor,
                                  constant: top).isActive = true
        self.bottomAnchor.constraint(equalTo: outsideView.bottomAnchor,
                                     constant: bottom).isActive = true
        self.leftAnchor.constraint(equalTo: outsideView.leftAnchor,
                                   constant: left).isActive = true
        self.rightAnchor.constraint(equalTo: outsideView.rightAnchor,
                                    constant: right).isActive = true
    }
}

extension UICollectionViewCell {

    class var reuseId: String {
        return "\(self)"
    }
}
