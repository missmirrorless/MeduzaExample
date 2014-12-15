//
//  GalleryImageView.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 12.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class GalleryImageView : UIScrollView, UIScrollViewDelegate {
    
    var image : UIImage! {
        get {
            return self.imageView.image;
        }
    }
    
    private var imageView : UIImageView!;
    private var imageURL : String!;
    private var activityView : UIActivityIndicatorView!;
    private weak var ownerViewController : GalleryViewController!;
        
    convenience init(frame : CGRect, imageURL : String, ownerViewController : GalleryViewController) {
        self.init(frame: frame);
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        self.ownerViewController = ownerViewController;
        
        self.delegate = self;
        self.imageURL = imageURL;
        
        self.scrollEnabled = true;
        self.bounces = true;
        self.alwaysBounceHorizontal = true;
        self.alwaysBounceVertical = false;
        self.bouncesZoom = true;
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        self.contentSize = self.frame.size;

        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0;

        self.imageView = UIImageView(frame: self.bounds);
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.addSubview(self.imageView);

        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        activityView.hidesWhenStopped = true;
        self.addSubview(self.activityView);
    }

    func updateFrame(frame : CGRect) {
        let zoomScale : CGFloat = self.zoomScale;
        self.zoomScale = 1.0;
        self.frame = frame;
        self.contentSize = frame.size;
        self.imageView.frame = self.bounds;
        self.zoomScale = zoomScale;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    }

    func loadImage() {
        if (self.imageView.image != nil) {
            return;
        }
        
        if (ImageCache.sharedCache()[self.imageURL] != nil) {
            self.imageView.image = ImageCache.sharedCache()[self.imageURL];
            return;
        }
        
        self.userInteractionEnabled = false;
        self.activityView.startAnimating();
        
        ConnectionAssistant.requestImageWithURL(self.imageURL, completionHandler: { (image : UIImage?) -> Void in
            self.activityView.stopAnimating();
            self.userInteractionEnabled = true;
            
            if (image != nil) {
                self.imageView.image = image;
            }
        })
        
    }

    func centerImage() {
        let xOffset : CGFloat = max((self.bounds.size.width - self.contentSize.width) * 0.5, 0.0);
        let yOffset : CGFloat = max((self.bounds.size.height - self.contentSize.height) * 0.5, 0.0);
        
        self.imageView.center = CGPointMake(self.contentSize.width * 0.5 + xOffset, self.contentSize.height * 0.5 + yOffset);
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView;
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerImage();

        self.ownerViewController.fullscreen = !(scrollView.zoomScale == self.minimumZoomScale);
    }
    
    
    func zoomToPoint(point : CGPoint, scale : CGFloat, animated : Bool) {
        let contentSize : CGSize = CGSizeMake(self.contentSize.width / self.zoomScale, self.contentSize.height / self.zoomScale);
        let zoomPoint : CGPoint = CGPointMake((point.x / self.bounds.size.width) * contentSize.width,
            (point.y / self.bounds.size.height) * contentSize.height);
        let zoomSize : CGSize  = CGSizeMake(self.bounds.size.width / scale, self.bounds.size.height / scale);
        let zoomRect : CGRect = CGRectMake(point.x - zoomSize.width / 2.0, point.y - zoomSize.height / 2.0, zoomSize.width, zoomSize.height);
        
        self.zoomToRect(zoomRect, animated: animated);
    }

}
