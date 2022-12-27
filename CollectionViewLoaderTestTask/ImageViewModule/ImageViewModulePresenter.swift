//
//  ImageViewModulePresenter.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 20.12.2022.
//

import Foundation
import UIKit

class ImageViewModulePresenter: IImageViewModuleOutput {
    
    var dataSource = PhotosDataSource()
    weak var view: IImageViewModuleInput?
    
    
    func viewDidLoadDone() {
        self.view?.setCollectionViewDataSource(self.dataSource)
    }
    
    func viewDidAppearDone() {
        
    }
    
    func itemSelected(withIndex index: Int) {
        self.dataSource.imagesNames.remove(at: index)
    }
    
}
