//
//  ViewController.swift
//  CollectionViewLoaderTestTask
//
//  Created by Admin on 15.12.2022.
//

import UIKit

protocol IImageViewModuleOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func itemSelected(withIndex index: Int)
}

protocol IImageViewModuleInput: AnyObject {
    func setCollectionViewDataSource(_ photosDataSource: PhotosDataSource)
}

class ImageViewModuleController: UIViewController, IImageViewModuleInput {

    
    var collectionView: UICollectionView?
    
    var output: IImageViewModuleOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let dataSource = { [weak self] (index: Int) -> CGSize in
            guard let strongSelf = self,
                  let collectionView = strongSelf.collectionView else {
                return .zero
            }
            return CGSize(width: collectionView.bounds.width,
                          height: collectionView.bounds.width)
        }
        let collectionViewLayout = CustomCollectionViewLayout()
       
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView?.decelerationRate = .fast
       
        self.collectionView?.showsVerticalScrollIndicator = true
        self.collectionView?.showsHorizontalScrollIndicator = true
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.delegate = self
        self.collectionView?.register(ImageViewCell.self,
                                      forCellWithReuseIdentifier: ImageViewCell.reuseId)
        self.view.addSubview(self.collectionView ?? UICollectionView())
        self.collectionView?.constraint(toView: self.view,
                                        top: 0,
                                        bottom: 0,
                                        left: -10,
                                        right: 10)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.output?.viewDidLoadDone()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let collectionView = collectionView {
            let size = CGSize(
                width: collectionView.bounds.width,
                height: collectionView.bounds.width)
            (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = size
        }
        self.output?.viewDidAppearDone()
    }
    
    var isInteractibleCollectionView = true
    func setCollectionViewDataSource(_ photosDataSource: PhotosDataSource) {
        self.collectionView?.dataSource = photosDataSource
        self.collectionView?.reloadData()
    }
    
//    func getCollectionViewLayout() -> CustomCollectionViewLayout {
//        let customCollectionLayout = CustomCollectionViewLayout()
//        customCollectionLayout.minimumInteritemSpacing = 12.0
//        customCollectionLayout.minimumLineSpacing = 12.0
//        customCollectionLayout.itemSize = CGSize(
//            width: self.view.bounds.width - 20.0,
//            height: self.view.bounds.width - 20.0)
//        customCollectionLayout.scrollDirection = .vertical
//        customCollectionLayout.sectionInset = UIEdgeInsets(
//            top: 0,
//            left: 10,
//            bottom: 0,
//            right: 10)
//        return customCollectionLayout
//    }
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
                self.collectionView?.deleteItems(at:[indexPath])
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }, completion: { _ in
                collectionView.isUserInteractionEnabled = true
            })
        })
    }
}
