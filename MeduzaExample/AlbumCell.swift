//
//  AlbumCell.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 11.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class AlbumCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        self.imageView.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.imageView.layer.borderWidth = 1.0;
    }
    
    func setWithDataSource(imageURL : String) {
        if (ImageCache.sharedCache()[imageURL] != nil) {
            self.imageView.image = ImageCache.sharedCache()[imageURL];
        }
        else {
            self.activityView.startAnimating();
            ConnectionAssistant.requestImageWithURL(imageURL, completionHandler: { (image) -> Void in
                self.imageView.image = image;
                
                ImageCache.sharedCache()[imageURL] = image;
                self.activityView.stopAnimating();
            })
        }
    }
}
