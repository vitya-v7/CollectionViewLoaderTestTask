//
//  PhotosDataSource.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

class PhotosDataSource: NSObject {

    let host = "https://newssourcegy.com/"
    var imagesNames = ["wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png",
                               "wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png",
                               "wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png",
                               "wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png",
                               "wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png",
                               "wp-content/themes/main/timthumb.php?src=https%3A%2F%2Fnewssourcegy.com%2Fwp-content%2Fuploads%2F2020%2F07%2FScreen-Shot-2020-07-01-at-6.53.01-PM.png"]
    
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
        
        cell.configure(withArguments: (imagesNames[indexPath.item],
                                       url,
                                       "png"),
                       indexPath: indexPath)
        return cell
    }

}
