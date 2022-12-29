//
//  LoadImageHelper.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

typealias LoadedImage = (url: URL,
                         image: UIImage?)
typealias LoadImageArgument = (key: String,
                               url: URL,
                               fileExtension: String)

protocol LoadImageHelperProtocol {
    /**
     Очистить кэш
     */
    func clearImageCacheStorage()
    /**
     - Parameter keys: название файлов для удаления
     */
    func clearImageCacheStorageForKeys(_ keys: [String])
    /**
    Очистить папку кэша
     */
    
    func clearFileManager()
    /**
     - Parameter keys: название файлов для удаления
     - Parameter keys: расширения файлов для удаления
     */
    func clearFileManagerForKeys(_ keys: [String],
                                 extensions: [String])
    /**
     Загрузка картики

     - Parameter argument: key - название файла в кэше, url - адрес загружаемой картинки и fileextension - расширение файла
     - Parameter indexPath: indexPath загружаемой картинки
     - Parameter completion: блок, вызывающийся при успешной загрузки картинки
     - Parameter fileLoadingCompletion: блок, вызывающийся, если нужно убрать индикатор загрузки
     */
    func perform(_ argument: LoadImageArgument,
                 indexPath: IndexPath,
                 completion: @escaping (LoadedImage) -> Void,
                 fileLoadingCompletion: @escaping () -> Void)
}

final class LoadImageHelper: LoadImageHelperProtocol {
    private let imageCacheStorage: ImageCacheStorageProtocol?
    private let fileManagerService: FileManagerServiceProtocol?
    private let clientService: OperationImageAPIServiceProtocol?

    init(clientService: OperationImageAPIServiceProtocol,
         imageCacheStorage: ImageCacheStorageProtocol,
         fileManagerService: FileManagerServiceProtocol) {
        self.clientService = clientService
        self.imageCacheStorage = imageCacheStorage
        self.fileManagerService = fileManagerService
    }
    
    func clearImageCacheStorage() {
        self.imageCacheStorage?.clearCache()
    }
    
    func clearImageCacheStorageForKeys(_ keys: [String]) {
        for key in keys {
            self.imageCacheStorage?.deleteItemForKey(key)
        }
    }
    
    func clearFileManagerForKeys(_ keys: [String],
                                 extensions: [String]) {
        for (key, ext) in zip(keys, extensions) {
            fileManagerService?.removeData(for: key,
                                              fileExtension: ext)
        }
        
    }
    
    func clearFileManager() {
        fileManagerService?.removeAllFiles()
    }
}

extension LoadImageHelper {
    
    func perform(_ argument: LoadImageArgument,
                 indexPath: IndexPath,
                 completion: @escaping (LoadedImage) -> Void,
                 fileLoadingCompletion: @escaping () -> Void) {
        if let image = imageCacheStorage?.image(by: argument.key) {
            return completion((url: argument.url.absoluteURL,
                               image: image))
        }
        
        if let imageData = fileManagerService?.data(for: argument.key,
                                                      fileExtension: argument.fileExtension),
           let image = UIImage(data: imageData) {
            imageCacheStorage?.save(image: image,
                                    for: argument.key)
            return completion((url: argument.url.absoluteURL,
                               image: image))
        }
        let fileExtension = argument.fileExtension
        let key = argument.key
        fileLoadingCompletion()
        self.clientService?.download(imagePath: argument.url.absoluteString,
                                     indexPath: indexPath,
                                     successCallback: { [weak self] image, _ in
            guard let imageData = image?.pngData() else { return }
            DispatchQueue.global(qos: .background).async {
                do {
                    try self?.fileManagerService?.save(data: imageData,
                                                       for: key,
                                                       fileExtension: fileExtension) { imageURL in
                        self?.imageCacheStorage?.save(image: image,
                                                      for: argument.key)
                        completion((url: imageURL,
                                    image: image))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }

}
