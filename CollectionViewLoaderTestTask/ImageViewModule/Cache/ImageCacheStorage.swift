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

protocol ImageCacheStorageProtocol {
    /**
     Сохранить картинку в кэш

     - Parameter image: картинка для сохранения
     - Parameter key: название картинки, под которым нужно сохранить
     */
    func save(image: UIImage?,
              for key: String)
    /**
     Достать картинку из кэша по ключу
     
     - Parameter image: картинка для сохранения
     - Parameter key: название/ключ картинки, которую нужно достать
     - Returns: искомая картинка
     */
    func image(by key: String) -> UIImage?
    /**
     Очистить кэш
     */
    func clearCache()
    /**
     Удалить картику с данным ключом
     
     - Parameter key: название/ключ картинки
     */
    func deleteItemForKey(_ key: String)
}

extension ImageCacheStorage: ImageCacheStorageProtocol {

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
