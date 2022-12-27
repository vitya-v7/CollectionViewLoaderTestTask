//
//  FileManagerService.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 23.12.2022.
//

import UIKit

final class FileManagerService {

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
}

private extension FileManagerService {

    func fileURL(for key: String,
                 fileExtension: String) -> URL {
        let url = FileManager.default.urls(for: .cachesDirectory,
                                           in: .userDomainMask)[0]
        return url.appendingPathComponent(key).appendingPathExtension(fileExtension)
    }
}
