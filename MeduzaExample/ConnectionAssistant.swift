//
//  ConnectionAssistant.swift
//  MeduzaExample
//
//  Created by Max Rovnov on 10.12.14.
//  Copyright (c) 2014 Max Rovnov. All rights reserved.
//

import UIKit

class ConnectionAssistant {
    
    class func requestImageWithURL(imageURL : String?, completionHandler : (image : UIImage?) -> Void) {
        if imageURL == nil {
            completionHandler(image: nil);
            return;
        }
        
        var imageRequest : NSURLRequest = NSURLRequest(URL: NSURL(string: imageURL!)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0);
        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue()) {
            (reponse : NSURLResponse!, data : NSData!, error : NSError!) -> Void in
            if error != nil || data == nil {
                completionHandler(image: nil);
                return;
            }
            
            if let image : UIImage = UIImage(data: data) {
                completionHandler(image: image);
            }
        };
    }
    
}