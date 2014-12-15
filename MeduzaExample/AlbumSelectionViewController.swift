//
//  AlbumSelectionViewController.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 10.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class AlbumSelectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource : [[String : AnyObject]]!;
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad();
                
        self.dataSource = [["title": "Radiohead",
            "imageURLs": ["http://altwall.net/img/groups/radiohead.jpg",
                "https://flavorwire.files.wordpress.com/2014/11/radiohead.jpg",
                "http://images5.fanpop.com/image/photos/27500000/Radiohead-radiohead-27519290-1280-1024.jpg",
                "http://www.hardformat.org/wp-content/uploads/2008/08/radiohead-amnesiac-5.jpg",
                "http://www.overheadcompartment.org/wp-content/uploads/2012/10/sd6.jpg",
                "http://discosalt.com/wp-content/uploads/2013/11/radiohead-2.jpg",
                "http://musicisart.ws/wp-content/uploads/2011/02/the-king-of-limbs-radiohead-1.jpg",]],
            ["title": "Meduza",
                "imageURLs": ["https://meduza.io/image/attachments/images/000/002/008/small/059egMRmvLpXBDEQHiNWNA.jpg",
                    "https://meduza.io/image/attachments/images/000/001/986/small/aIlfPU28yMvhUb7iSbOh4Q.jpg",
                    "https://meduza.io/image/attachments/images/000/002/032/small/HhfuwWDM3pcUhk__pN6vhA.jpg",
                    "https://meduza.io/image/attachments/images/000/002/013/large/L2UDaGwkqQeeHSoJHCE_qw.jpg",
                    "https://meduza.io/image/attachments/images/000/002/016/large/muP6i3hvl8Ptp6OfpITh9A.jpg",
                    "https://meduza.io/image/attachments/images/000/002/012/large/OjtuP6UVkV2z2Qt7cQPesw.jpg",
                    "https://meduza.io/image/attachments/images/000/002/027/large/ooY8c9b9PkzURA6cMVC-mw.jpg",
                    "https://meduza.io/image/attachments/images/000/002/021/large/qiYpV9NRNSDLUlRWbXIHIw.jpg"]],
            ["title": "Nizhniy Novgorod",
                "imageURLs": ["http://www.russiawanderer.com/wp-content/uploads/2014/01/The-Kremlin-of-Nizhny-Novgorod-@Aleksandr-Zykov.jpg",
                              "http://upload.wikimedia.org/wikipedia/commons/5/54/Nizhny_Novgorod_Alexander_Nevsky_Cathedral_at_Strelka.JPG",
                              "http://www.eu-russia-csf.org/newsletter/images/NizhnyNovgorod.jpg"]]];

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None);
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None);
    }
    
    func backButtonAction() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AlbumViewController" {
            let indexPath : NSIndexPath = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath;
            let cellData : [String : AnyObject] = self.dataSource[indexPath.row] as [String : AnyObject];
            
            var viewController : AlbumViewController = segue.destinationViewController as AlbumViewController;
            viewController.setWithDataSource(cellData["imageURLs"] as [String], albumTitle: cellData["title"] as String);
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : AlbumSelectionCell! = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumSelectionCell", forIndexPath: indexPath) as AlbumSelectionCell;
        
        if cell == nil {
            cell = AlbumSelectionCell();
        }

        let cellData : [String : AnyObject] = self.dataSource[indexPath.row] as [String : AnyObject];
        cell.setWithTitle(cellData["title"] as String, imageURL: cellData["imageURLs"]?[0] as String)

        return cell;
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("AlbumViewController", sender: self);
    }
    
}
