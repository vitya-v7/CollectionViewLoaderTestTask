//
//  APIService.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 22.12.2022.
//

import UIKit

final class APIService {
    
    let host: String = "https://lenta.ru/rss/articles"
	static var shared: APIService = {
		let instance = APIService()
        return instance
    }()
    
    private init() {
        
    }
    
    func getRequest(path: String,
                    successCallback: @escaping (Data?) -> Void,
                    errorCallback: @escaping (Error) -> Void) {
        let urlSession = URLSession.shared
        
        if let url = URL(string: host) {
            let urlRequest = URLRequest.init(url: url)
			let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
				guard let strongSelf = self else {
					return
				}
				if let error = error {
					errorCallback(error)
				} else {
					if let data = data, let response = response as? HTTPURLResponse {
						
						if strongSelf.isSuccessResponse(response: response) {
							successCallback(data)
						}
					}
				}
			}
			dataTask.resume()
		}
	}
	
	private func isSuccessResponse(response: HTTPURLResponse) -> Bool {
		if response.statusCode >= 200 && response.statusCode <= 299 {
			return true
		}
		return false
	}
}
