//
//  ImageCache.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 11.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class ImageCache {
    
    private var storage : [String : UIImage];
    
    class func sharedCache() -> ImageCache {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
            static var instance : ImageCache? = nil;
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = ImageCache();
        });
        
        return Static.instance!;
    }
    
    init() {
        self.storage = [String : UIImage]();
    }
    
    subscript(identifier : String) -> UIImage? {
        get {
            return self.storage[identifier]?;
        }
        
        set(image) {
            self.storage[identifier] = image;
        }
    }
}
