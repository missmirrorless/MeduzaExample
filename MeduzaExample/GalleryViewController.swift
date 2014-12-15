//
//  GalleryViewController.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 11.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class GalleryViewController : UIViewController, UIScrollViewDelegate {
    
    var dataSource : [String]!;
    var storedPage : Int = 0;
    
    @IBOutlet var interfaceElements: [UIView]!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentView : UIScrollView!;
    @IBOutlet weak var leftShareButtonMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCloseButtonMarginConstraint: NSLayoutConstraint!
    
    var xCounterLabelConstraint : NSLayoutConstraint!;
    var yCounterLabelConstraint : NSLayoutConstraint!;
    
    var imageViews : [Int : GalleryImageView] = [Int : GalleryImageView]();
    
    var blockFullscreenAnimation : Bool = false;
    private var _fullscreenMode : Bool = false;
    var fullscreen : Bool {
        set(value) {
            _fullscreenMode = value;
            
            if self.blockFullscreenAnimation {
                return;
            }
            
            if value {
                UIView.animateWithDuration(0.25, animations: {
                    self.interfaceElements.map({ (view : UIView) -> UIView in
                        view.alpha = 0.0;
                        return view;
                    });
                    
                    self.contentView.backgroundColor = UIColor.blackColor();
                });
            }
            else {
                UIView.animateWithDuration(0.25, animations: {
                    self.interfaceElements.map({ (view : UIView) -> UIView in
                        view.alpha = 1.0;
                        return view;
                    });
                    
                    self.contentView.backgroundColor = UIColor.clearColor();
                });
            }
        }
        
        get {
            return _fullscreenMode;
        }
    }
    
    var page : Int {
        set(value) {
            self.contentView.contentOffset = CGPointMake(self.contentView.frame.size.width * CGFloat(value), 0.0);
            
            if let imageView : GalleryImageView = self.imageViews[value]? {
                if imageView.image == nil {
                    imageView.loadImage();
                }
            }
        }
        
        get {
            return Int(round(self.contentView.contentOffset.x / self.contentView.bounds.width));
        }
    }
    
    var needsUpdateContentSize : Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        var tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizerEvent:");
        self.contentView.addGestureRecognizer(tapGestureRecognizer);
        
        var doubleTapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTapGestureRecognizerEvent:");
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        self.contentView.addGestureRecognizer(doubleTapGestureRecognizer);
        
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer);
        
        self.updateContentSize();
        
        if let dataSource : [String] = self.dataSource? {
            self.page = self.storedPage;
        }
    }
    
    func handleTapGestureRecognizerEvent(gestureRecognizer : UITapGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if let imageView : GalleryImageView = self.imageViews[self.page]? {
                if imageView.zoomScale > imageView.minimumZoomScale {
                    imageView.setZoomScale(imageView.minimumZoomScale, animated: true);
                }
            }
            
            self.fullscreen = !self.fullscreen;
        }
    }
    
    func handleDoubleTapGestureRecognizerEvent(gestureRecognizer : UITapGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if let imageView : GalleryImageView = self.imageViews[self.page]? {
                if imageView.zoomScale == imageView.maximumZoomScale {
                    if self.fullscreen {
                        self.fullscreen = false;
                    }
                    
                    imageView.setZoomScale(imageView.minimumZoomScale, animated: true);
                }
                else {
                    if !self.fullscreen {
                        self.fullscreen = true;
                    }
                    
                    let touchPoint : CGPoint = gestureRecognizer.locationInView(imageView);
                    
                    imageView.zoomToPoint(touchPoint, scale: imageView.maximumZoomScale, animated: true);
                }
                
            }
        }
    }

    @IBAction func closeButtonAction(sender : UIButton) {
        InterfaceAssistant.addFadeInAnimationToViewController(self);
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade);
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();

        self.updateContentSize();
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.storedPage = self.page;
        self.needsUpdateContentSize = true;
    }

    override func updateViewConstraints() {
        if self.xCounterLabelConstraint != nil && self.yCounterLabelConstraint != nil {
            self.view.removeConstraint(self.xCounterLabelConstraint);
            self.view.removeConstraint(self.yCounterLabelConstraint);
        }
        
        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation;
        
        if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
            self.xCounterLabelConstraint = NSLayoutConstraint(
                item: self.countLabel,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0);
            
            self.yCounterLabelConstraint = NSLayoutConstraint(
                item: self.countLabel,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 35.0);
            
            self.leftShareButtonMarginConstraint.constant = 0.0;
            self.rightCloseButtonMarginConstraint.constant = 0.0;
            
            self.countLabel.font = UIFont(name: "PFRegalTextPro-RegularB", size: 20.0);
        }
        else if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
            self.xCounterLabelConstraint = NSLayoutConstraint(
                item: self.countLabel,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.closeButton,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0);
            
            self.yCounterLabelConstraint = NSLayoutConstraint(
                item: self.countLabel,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1.0,
                constant: -1.0);
            
            self.leftShareButtonMarginConstraint.constant = 7.0;
            self.rightCloseButtonMarginConstraint.constant = 6.0;
            
            self.countLabel.font = UIFont(name: "PFRegalTextPro-RegularB", size: 15.0);
        }
        
        self.view.addConstraint(self.xCounterLabelConstraint);
        self.view.addConstraint(self.yCounterLabelConstraint);
        
        self.needsUpdateContentSize = true;
        
        super.updateViewConstraints();
    }

    func updateCountLabel() {
        let imageIndex : Int = min(max(1, self.page + 1), min(self.page + 1, self.dataSource.count));
        self.countLabel.text = "\(imageIndex)/\(self.dataSource.count)";
    }
    
    func updateContentSize() {
        if !self.needsUpdateContentSize {
            return;
        }
        
        var xOffset : CGFloat = 0.0;
        
        for index in 0 ..< self.dataSource.count {
            var imageView : GalleryImageView!;
            
            if self.imageViews[index] == nil {
                imageView = GalleryImageView(frame: CGRectMake(xOffset, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height), imageURL: self.dataSource[index], ownerViewController: self);
                self.contentView.addSubview(imageView);
                self.imageViews[index] = imageView;
            }
            else {
                imageView = self.imageViews[index];
            }
            
            imageView.updateFrame(CGRectMake(xOffset, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height));
            
            self.updateCountLabel();
            xOffset += self.contentView.frame.size.width;
        }
        
        self.contentView.contentSize = CGSizeMake(xOffset, self.contentView.frame.size.height);
        self.page = self.storedPage;
        self.needsUpdateContentSize = false;
    }

    func setWithImageURLs(imageURLs : [String], page : Int) {
        self.dataSource = imageURLs;
        self.storedPage = page;
    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateCountLabel();
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let imageView : GalleryImageView = self.imageViews[self.page]? {
            imageView.loadImage();
            
            self.blockFullscreenAnimation = true;
            for item : GalleryImageView in self.imageViews.values {
                if item == imageView {
                    continue;
                }
                
                item.setZoomScale(1.0, animated: true);
            }
            
            self.blockFullscreenAnimation = false;
        }
    
    }

}
