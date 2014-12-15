//
//  AlbumViewController.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 10.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class AlbumViewController : UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var albumTitle : String!
    var dataSource : [String]!;
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var backButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        backButton.frame = CGRectMake(0.0, 0.0, 22.0, 17.0);
        backButton.setImage(UIImage(named: "back_button_image.png"), forState: UIControlState.Normal);
        backButton.addTarget(self, action: "backButtonAction", forControlEvents: UIControlEvents.TouchUpInside);
        
        var backButtonItem : UIBarButtonItem = UIBarButtonItem(customView: backButton);
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.navigationController?.interactivePopGestureRecognizer.delegate = self;
        
        self.navigationItem.title = self.albumTitle;
        
        self.setupFlowLayout();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade);
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None);
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.collectionView.collectionViewLayout.invalidateLayout();
    }

    func setupFlowLayout() {
        let interfaceOrientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation;
        
        var collectionViewLayout : UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout;
        
        var sideValue : CGFloat = 0.0;
        if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
            sideValue = 5.0;
        }
        else if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
            sideValue = 10.0;
        }
        
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(sideValue, sideValue, sideValue, sideValue);
        collectionViewLayout.minimumInteritemSpacing = sideValue;
        collectionViewLayout.minimumLineSpacing = sideValue;
    }
    
    func backButtonAction() {
        self.navigationController?.popViewControllerAnimated(true);
    }

    func setWithDataSource(imageURLs : [String], albumTitle : String) {
        self.albumTitle = albumTitle;
        self.dataSource = imageURLs;
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : AlbumCell! = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as AlbumCell;
        
        if cell == nil {
            cell = AlbumCell();
        }
        
        cell.setWithDataSource(self.dataSource[indexPath.row]);
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell : AlbumCell = collectionView.cellForItemAtIndexPath(indexPath) as AlbumCell;
        var viewController : GalleryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GalleryViewController") as GalleryViewController;
        viewController.setWithImageURLs(self.dataSource, page: indexPath.row);
        
        InterfaceAssistant.addFadeInAnimationToViewController(self);
        self.presentViewController(viewController, animated: false, completion: nil);
    }
}
