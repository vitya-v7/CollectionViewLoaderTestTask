//
//  PendingOperations.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 20.12.2022.
//

import UIKit

public final class PendingOperations {
    
	lazy var downloadsInProgress: [IndexPath: Operation] = [:]
	lazy var downloadQueue: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Download queue"
		queue.maxConcurrentOperationCount = 6
		return queue
	}()

	func suspendAllOperations() {
		downloadQueue.isSuspended = true
	}

	func resumeAllOperations() {
		downloadQueue.isSuspended = false
	}
}
