//
//  AlertHelper.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 20.12.2022.
//

import Foundation
import UIKit

final class AlertHelper {
    
    static let shared = AlertHelper()
    
    private init() {}
    
    func showAlert(inController controller: UIViewController,
                   withTitle title: String,
                   message: String,
                   okAction: (() -> Void)? = nil,
                   needCancelButton: Bool = false,
                   cancelAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okAction?()
        }))
        
        if needCancelButton {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                cancelAction?()
            }))
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popover = alertController.popoverPresentationController
            popover?.sourceView = controller.view
            popover?.sourceRect = controller.view.bounds
        }
        
        DispatchQueue.main.async {
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showNoInternetAlertInController(_ controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        self.showAlert(inController: controller,
                       withTitle: "Error",
                       message: "No internet connection")
    }
}
