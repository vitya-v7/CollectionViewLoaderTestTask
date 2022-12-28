//
//  ViewController.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 15.12.2022.
//

import UIKit

protocol IImageViewModuleOutput {
    func viewDidLoadDone()
    func viewWillAppearDone()
    func viewDidAppearDone()
    func itemSelected(withIndex index: Int)
    func clearFiles()
    func renewImageData()
}

protocol IImageViewModuleInput: AnyObject {
    func setCollectionViewDataSource(_ photosDataSource: PhotosDataSource)
    func showErrorAlert(withTitle title: String,
                        andDescription description: String)
    func reloadCollectionView()
}

class ImageViewModuleController: UIViewController, IImageViewModuleInput {

    var collectionView: UICollectionView?
    var output: IImageViewModuleOutput?
    
    private var isInteractibleCollectionView = true
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewLayout = CustomCollectionViewLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.view.addSubview(self.collectionView ?? UICollectionView())
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.collectionView?.alwaysBounceVertical = true
        self.refreshControl.tintColor = .red
        self.collectionView?.addSubview(self.refreshControl)
        self.collectionView?.refreshControl = self.refreshControl
        self.collectionView?.decelerationRate = .fast
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = true
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.delegate = self
        self.collectionView?.register(ImageViewCell.self,
                                      forCellWithReuseIdentifier: ImageViewCell.reuseId)
        var topInset = 0.0
        if let top = self.navigationController?.navigationBar.frame.size.height {
            topInset = top
        }
        self.collectionView?.constraint(toView: self.view,
                                        top: topInset,
                                        bottom: 0,
                                        left: 0,
                                        right: 0)
        self.output?.viewDidLoadDone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output?.viewWillAppearDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.collectionView?.refreshControl?.beginRefreshing()
        self.output?.clearFiles()
        self.output?.renewImageData()
        self.collectionView?.reloadData()
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    func showErrorAlert(withTitle title: String,
                        andDescription description: String) {
        AlertHelper.shared.showAlert(inController: self,
                                     withTitle: title,
                                     message: description)
    }
    
    func setCollectionViewDataSource(_ photosDataSource: PhotosDataSource) {
        self.collectionView?.dataSource = photosDataSource
        self.reloadCollectionView()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}

extension ImageViewModuleController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let cell = collectionView.cellForItem(at: indexPath) as? DestinationCellProtocol,
        let collectionView = self.collectionView,
        collectionView.isUserInteractionEnabled == true else {
            return
        }
        collectionView.isUserInteractionEnabled = false
        
        cell.delete(withDelay: 1.0,
                    offset: collectionView.bounds.width,
                    andCompletion: {
            self.collectionView?.performBatchUpdates({
                
                self.output?.itemSelected(withIndex: indexPath.item)
                self.collectionView?.deleteItems(at: [indexPath])
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }, completion: { _ in
                collectionView.isUserInteractionEnabled = true
            })
        }, errorCompletion: {
            collectionView.isUserInteractionEnabled = true
        })
    }
}
