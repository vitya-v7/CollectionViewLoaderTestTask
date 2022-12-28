//
//  PhotosDataSource.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

class PhotosDataSource: NSObject {

    let useCase = LoadImageHelper(clientService: OperationImageAPIService(),
                                  imageCacheStorage: ImageCacheStorage(),
                                  fileManagerService: FileManagerService())
    // Hardcoded values
    let host = "https://4kwallpapers.com/"
    var imagesNames: [ImageNameStruct] = [ImageNameStruct(key: "item1",
                                                          name: "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg"),
                                          ImageNameStruct(key: "item2",
                                                          name: "images/wallpapers/col-de-la-madeleine-5330x2998-9697.jpg"),
                                          ImageNameStruct(key: "item3",
                                                          name: "images/wallpapers/alice-pagani-5120x5883-9754.jpg"),
                                          ImageNameStruct(key: "item4",
                                                          name: "images/wallpapers/bentley-flying-spur-5000x3333-9648.jpeg"),
                                          ImageNameStruct(key: "item5",
                                                          name: "images/wallpapers/red-rose-rose-4822x3135-9734.jpg"),
                                          ImageNameStruct(key: "item6",
                                                          name: "images/wallpapers/snowcapped-5446x3602-9749.jpg")] {
        didSet {
            if let imagesPropertyList = try? PropertyListEncoder().encode(self.imagesNames) {
                UserDefaults.standard.set(imagesPropertyList,
                                          forKey: "Names")
            }
        }
    }
    
    let constantImagesNames = [ImageNameStruct(key: "item1",
                                               name: "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg"),
                               ImageNameStruct(key: "item2",
                                               name: "images/wallpapers/col-de-la-madeleine-5330x2998-9697.jpg"),
                               ImageNameStruct(key: "item3",
                                               name: "images/wallpapers/alice-pagani-5120x5883-9754.jpg"),
                               ImageNameStruct(key: "item4",
                                               name: "images/wallpapers/bentley-flying-spur-5000x3333-9648.jpeg"),
                               ImageNameStruct(key: "item5",
                                               name: "images/wallpapers/red-rose-rose-4822x3135-9734.jpg"),
                               ImageNameStruct(key: "item6",
                                               name: "images/wallpapers/snowcapped-5446x3602-9749.jpg")]
    
    func getExtensions() -> [String] {
        return imagesNames.map { imageName in
            guard let string = URL(string: imageName.name)?.pathExtension else {
                return ""
            }
            return string
        }
    }
    
    func getNames() -> [String] {
        return imagesNames.map { imageName in
            return imageName.key
        }
    }
    
    func clearFiles() {
        useCase.clearFileManager()
        useCase.clearImageCacheStorage()
        self.imagesNames = []
    }
    
    func clearFileForIndex(_ index: Int) {
        let keys = self.getNames()
        self.useCase.clearFileManagerForKeys([keys[index]],
                                        extensions: [self.getExtensions()[index]])
        self.useCase.clearImageCacheStorageForKeys([keys[index]])
        self.imagesNames.remove(at: index)
    }
    
}

extension PhotosDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesNames.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = ImageViewCell.reuseId
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseId,
            for: indexPath) as? ImageViewCell,
              let url = URL(string: self.host + self.imagesNames[indexPath.item].name) else {
                  return UICollectionViewCell()
              }
        
        cell.configure(withArguments: (self.imagesNames[indexPath.item].key,
                                       url,
                                       url.pathExtension),
                       useCase: self.useCase,
                       indexPath: indexPath)
        return cell
    }

}
