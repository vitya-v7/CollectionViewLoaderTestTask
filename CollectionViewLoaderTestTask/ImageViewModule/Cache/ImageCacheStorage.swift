//
//  ImageCacheStorage.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

final class ImageCacheStorage {
    private let cache = NSCache<NSString,
        UIImage>()
}

extension ImageCacheStorage {

    func save(image: UIImage?,
              for key: String) {
        guard let image = image else {
            return
        }

        cache.setObject(image,
                        forKey: NSString(string: key))
    }

    func image(by key: String) -> UIImage? {
        let image = cache.object(forKey: NSString(string: key))
        return image
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    func deleteItemForKey(_ key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
}
