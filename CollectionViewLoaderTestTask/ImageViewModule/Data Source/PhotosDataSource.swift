//
//  PhotosDataSource.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

class PhotosDataSource: NSObject {

    let host = "https://4kwallpapers.com/"
    var imagesNames = ["images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg",
                               "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg",
                               "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg",
                               "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg",
                               "images/wallpapers/fairy-house-bokeh-3840x2160-9641.jpg"]
    
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
              let url = URL(string: host + imagesNames[indexPath.item]) else {
                  return UICollectionViewCell()
              }
        
        cell.configure(withArguments: ("item+\(indexPath.item)",
                                       url,
                                       "png"),
                       indexPath: indexPath)
        return cell
    }

}
