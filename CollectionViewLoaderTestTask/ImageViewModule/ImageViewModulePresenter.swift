//
//  ImageViewModulePresenter.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 20.12.2022.
//

import Foundation
import Reachability
import UIKit

class ImageViewModulePresenter: IImageViewModuleOutput {
    
    var dataSource = PhotosDataSource()
    weak var view: IImageViewModuleInput?
    private var reachability: Reachability?
    
    func viewDidLoadDone() {
        if let fetchedData = UserDefaults.standard.data(forKey: "Names"),
           let fetchedPropertyList = try? PropertyListDecoder()
            .decode([ImageNameStruct].self, from: fetchedData) {
            self.dataSource.imagesNames = fetchedPropertyList
        } else {
            self.dataSource.imagesNames = self.dataSource.constantImagesNames
        }
        self.view?.setCollectionViewDataSource(self.dataSource)
    }
    
    func viewWillAppearDone() {
        let viewController = self.view as? UIViewController
        guard let reachability = try? Reachability() else {
            AlertHelper.shared.showNoInternetAlertInController(viewController)
            return
        }
        
        self.reachability = reachability
        
        do {
            try reachability.startNotifier()
        } catch {
            AlertHelper.shared.showNoInternetAlertInController(viewController)
            return
        }
        
        self.reachability?.whenReachable = { [weak self] reachability in
            guard reachability.connection != .unavailable else {
                AlertHelper.shared.showNoInternetAlertInController(viewController)
                return
            }
            self?.view?.reloadCollectionView()
        }
        
        self.reachability?.whenUnreachable = { reachability in
            guard reachability.connection == .unavailable else {
                return
            }
            AlertHelper.shared.showNoInternetAlertInController(viewController)
        }
    }
    
    func viewDidAppearDone() {
        
    }
    
    func itemSelected(withIndex index: Int) {
        self.dataSource.clearFileForIndex(index)
    }
    
    func clearFiles() {
        self.dataSource.clearFiles()
    }
        
    func renewImageData() {
        self.dataSource.imagesNames = self.dataSource.constantImagesNames
    }
}
