//
//  CloudWorks.swift
//  CNToolkit
//
//  Created by saman on 7/10/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation
import OpenWhisk
import UIKit

class CloudWorks {

    // Change to your whisk app key and secret.
    let WhiskAppKey: String = "b9502a06-125a-45b0-8348-879a06f1b54d"
    let WhiskAppSecret: String = "B94Wg7jvVd1s0qqBR38YmaDfn1iHur4SE7ruc5urYL7b05Q7w9FS20DSfoxSOrIo"
    
    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"
    
    // The action to invoke.
    
    // Choice: specify commponents
    let MyNamespace: String = "whisk.system"
    let MyPackage: String? = "util"
    let MyWhiskAction: String = "date"
    
    var MyActionParameters: [String:AnyObject]? = nil
    let HasResult: Bool = true // true if the action returns a result
    
    var session: NSURLSession!

    // Initilize the data structures needed
    init() {
       
        // create whisk credentials token
        let creds = WhiskCredentials(accessKey: WhiskAppKey,accessToken: WhiskAppSecret)
        
    }
    
    
    // Check if a record for this device exists. 
    // if there is an error, try to add a record
    // or if the results is zero records, try to add a record
    // if there are more than 1 record, a problem, report.
    func deviceRecord() {

    }
    
    
    // Add a record for this device
    func addDeviceRecord() {

    }
    
    
    
    func patientRecord() {
 
        
    }
    
    func addPatientRecord() {

        
    }
    
    
    
    func notifyUser(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        let window = UIApplication.sharedApplication().keyWindow
        var vc = window?.rootViewController
        while (vc?.presentedViewController != nil)
        {
            vc = vc?.presentedViewController
        }
        vc!.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}


let cloudHelper = CloudWorks()