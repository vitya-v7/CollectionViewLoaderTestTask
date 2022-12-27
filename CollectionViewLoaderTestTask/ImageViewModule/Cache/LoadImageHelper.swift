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

final class LoadImageHelper {
    private let imageCacheStorage: ImageCacheStorage?
    private let fileManagerService: FileManagerService?
    private let clientService: OperationImageAPIService?

    init(clientService: OperationImageAPIService,
         imageCacheStorage: ImageCacheStorage,
         fileManagerService: FileManagerService) {
        self.clientService = clientService
        self.imageCacheStorage = imageCacheStorage
        self.fileManagerService = fileManagerService
    }
}

extension LoadImageHelper {
    
    func perform(_ argument: LoadImageArgument,
                 indexPath: IndexPath,
                 completion: @escaping (LoadedImage) -> Void) {
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
        let key = argument.fileExtension
        self.clientService?.download(imagePath: argument.url.absoluteString,
                                     indexPath: indexPath,
                                     successCallback: { [weak self] image, imagePath in
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
