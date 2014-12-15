//
//  AlbumSelectionCell.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 10.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class AlbumSelectionCell : UICollectionViewCell {
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        self.coverView.layer.borderColor = UIColor(red: 0.462, green: 0.486, blue: 0.517, alpha: 1.0).CGColor;
        self.coverView.layer.borderWidth = 0.5;

    }
    
    func setWithTitle(title : String, imageURL : String) {
        self.titleLabel.text = title;
        
        if (ImageCache.sharedCache()[imageURL] != nil) {
            self.coverView.image = ImageCache.sharedCache()[imageURL];
        }
        else {
            self.activityView.startAnimating();
            ConnectionAssistant.requestImageWithURL(imageURL, completionHandler: { (image : UIImage?) -> Void in
                self.coverView.image = image;
                
                ImageCache.sharedCache()[imageURL] = image;
                
                self.activityView.stopAnimating();
            })
        }
    }
}
