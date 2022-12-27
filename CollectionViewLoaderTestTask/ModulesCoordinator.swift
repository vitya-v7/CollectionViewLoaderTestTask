//
//  ModulesCoordinator.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import Foundation
import MediaPlayer
import UIKit

final class ModulesCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTracksListScreen()
    }
    
    private func showTracksListScreen() {
        let imagesViewController = ImageViewModuleController()
        let presenter = ImageViewModulePresenter()
        presenter.view = imagesViewController
        imagesViewController.output = presenter
        self.navigationController?.pushViewController(imagesViewController,
                                                      animated: false)
    }
    
}
