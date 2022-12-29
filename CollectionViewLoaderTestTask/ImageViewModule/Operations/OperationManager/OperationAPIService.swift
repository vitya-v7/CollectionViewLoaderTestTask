//
//  OperationImageAPIService.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 22.12.2022.
//

import Foundation
import UIKit

protocol OperationImageAPIServiceProtocol {
    /**
     Загрузка картики по indexPath
     
     - Parameter imagePath: адрес картинки для загрузки
     - Parameter indexPath: indexPath картинки
     - Parameter successCallback: блок, вызываемый по успешной загрузке
     */
    func download(imagePath: String,
                  indexPath: IndexPath,
                  successCallback: @escaping (_ image: UIImage?,
                                              _ imagePath: String) -> Void)
}

final class OperationImageAPIService: OperationImageAPIServiceProtocol {
    
    private static let operationQueueID = "com.viktor.deryabin.Hammer-Systems-Test-Task.operationQueue"
    private let operationQueue = DispatchQueue(label: OperationImageAPIService.operationQueueID,
                                               attributes: .concurrent)
    private var pendingOperations = PendingOperations()
    var imageURL: URL?
    
    func download(imagePath: String,
                  indexPath: IndexPath,
                  successCallback: @escaping (_ image: UIImage?,
                                              _ imagePath: String) -> Void) {
        var operation: Operation?
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            operation = pendingOperations.downloadsInProgress[indexPath]
            if let operation = operation as? ImageDownloadOperation,
               !operation.isCancelled && operation.isFinished {
                successCallback(operation.image, imagePath)
                return
            }
        } else {
            let downloadOperation = ImageDownloadOperation(imagePath)
            operation = downloadOperation
            self.pendingOperations.downloadQueue.addOperation(downloadOperation)
            operationQueue.async(flags: .barrier) { [weak self] in
                self?.pendingOperations.downloadsInProgress[indexPath] = downloadOperation
            }
        }
        guard let operation = operation else {
            return
        }
        operation.completionBlock = {
            if operation.isCancelled {
                return
            }
            
            if let operation = operation as? ImageDownloadOperation {
                successCallback(operation.image, imagePath)
                return
            }
        }
    }
    
    func startDownload(imagePath: String,
                       indexPath: IndexPath,
                       successCallback: @escaping (_ image: UIImage?, _ imagePath: String) -> Void) {
        
        download(imagePath: imagePath, indexPath: indexPath, successCallback: successCallback)
        
    }
}
