//
//  FileManagerService.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

protocol FileManagerServiceProtocol {
    /**
     Сохранить данные картинки во временную папку
     
     - Parameter data: данные картинки, которые нужно сохранить
     - Parameter key: название/ключ картинки, которую нужно сохранить
     - Parameter fileExtension: расширение картинки, которую нужно сохранить
     - Parameter completion: блок по успешному сохранению
     - Returns: искомая картинка
     */
    func save(data: Data,
              for key: String,
              fileExtension: String,
              completion: (URL) -> Void) throws
    /**
     Достать данные картинки по ключу и расширению из временной папки
     
     - Parameter key: ключ картинки, которую достаем
     - Parameter fileExtension: расширение картинки, которую достаем
     - Returns: данные искомой картинки
     */
    func data(for key: String,
              fileExtension: String) -> Data?
    /**
     Удалить данные картинки по ключу из временной папки
     
     - Parameter key: ключ картинки, которую хотим удалить
     - Parameter fileExtension: расширение картинки, которую удаляем
     */
    func removeData(for key: String,
                    fileExtension: String)
    /**
     Составить URL из ключа и расширения
     
     - Parameter key: ключ картинки
     - Parameter fileExtension: расширение картинки
     - Returns: готовый URL
     */
    func existingFileURL(for key: String,
                         fileExtension: String) -> URL?
    /**
     Удалить все файлы из временной папки
     */
    func removeAllFiles()
    
}

final class FileManagerService: FileManagerServiceProtocol {

    private let folderName = "TemporaryFiles"
        
    func save(data: Data,
              for key: String,
              fileExtension: String,
              completion: (URL) -> Void) throws {
        let fileUrl = fileURL(for: key,
                              fileExtension: fileExtension)
        try? data.write(to: fileUrl)
        completion(fileUrl)
    }

    func data(for key: String,
              fileExtension: String) -> Data? {
        let fileUrl = fileURL(for: key,
                              fileExtension: fileExtension)
        return try? Data(contentsOf: fileUrl)
    }
    
    func removeData(for key: String,
                    fileExtension: String) {
        let fileUrl = fileURL(for: key,
                              fileExtension: fileExtension)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            try? FileManager.default.removeItem(at: fileUrl)
        }
    }
    
    func existingFileURL(for key: String,
                         fileExtension: String) -> URL? {
        let url = fileURL(for: key,
                          fileExtension: fileExtension)
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        } else {
            return nil
        }
    }
    
    func removeAllFiles() {
        guard let fileURLs = try? FileManager.default.contentsOfDirectory(
            at: self.folderURL(),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles) else {
                return
            }
        for fileURL in fileURLs {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}

private extension FileManagerService {

    func fileURL(for key: String,
                 fileExtension: String) -> URL {
        let url = self.folderURL()
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
        }
        return url.appendingPathComponent(key).appendingPathExtension(fileExtension)
    }
    
    func folderURL() -> URL {
        var url = FileManager.default.urls(for: .cachesDirectory,
                                           in: .userDomainMask)[0]
        url.appendPathComponent(self.folderName)
        return url
    }
}
