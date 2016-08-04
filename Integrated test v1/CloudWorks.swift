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
    //let WhiskAppKey: String = "b9502a06-125a-45b0-8348-879a06f1b54d"
    //let WhiskAppSecret: String = "B94Wg7jvVd1s0qqBR38YmaDfn1iHur4SE7ruc5urYL7b05Q7w9FS20DSfoxSOrIo"
    //var MyNamespace: String = "saman_test"
    //let MyPackage: String? = "Bluemix_Cloudant NoSQL DB-hd_Credentials-1"

    
    let WhiskAppKey: String = "287d8438-4c7f-474c-af9b-cc8c15e2ff57"
    let WhiskAppSecret: String = "hERgPjlfKoN7rbiSs0judMnWNY14WEuxQsWCpSUKyHRXTr6W65TPemoYl2mYHRUr"
    let MyNamespace: String = "CNToolkit_Updated Boston Naming Task"
    var MyPackage: String?
    let date = String(NSDate())


    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"
    
    var whisk: Whisk
    
    var session: NSURLSession!
    
    

    // Initilize the data structures needed
    init() {
        // create whisk credentials token
        let creds = WhiskCredentials(accessKey: WhiskAppKey, accessToken: WhiskAppSecret)
        whisk = Whisk(credentials: creds)
        
        if testmodeOn == true {
            MyPackage = "Bluemix_BNT-collect-test_testing-iPads-and-simulators"
        } else {
            MyPackage = "Bluemix_BNT-collect_collect-iPads"
        }
    }
    
    
    // Check if a record for this device exists. 
    // if there is an error, try to add a record
    // or if the results is zero records, try to add a record
    // if there are more than 1 record, a problem, report.
    func writeRecord(action:String, parameters:AnyObject) {
        do {
            try whisk.invokeAction(
                name: action, package:MyPackage, namespace: MyNamespace, parameters: parameters,
                hasResult: false,
                callback: {(reply, error) -> Void in
                    if let error = error {
                        // ?? handle error - notify user
                        print(reply, error)
                        self.notifyUser("Cloud error", message:"failed to insert document in database (1)")
                    } else {
                        // document inserted (sort of - this is a non-blocking invoke, we assume it succeeded
                        print("sent request to store document in database")
                    }
            })
        } catch {
            self.notifyUser("Cloud error", message:"failed to insert document in database (2)")
            print("exception happened trying to add document in database")
        }
        
    }

    
    
    
    func deviceRecord() {
        let parameters = [ "dbname":"devices", "doc": [
            "_id": uniqueName,
            "deviceid": uniqueName,
            "devicename": ipadName,
            "date":date ] ]
        writeRecord("write", parameters:parameters)
    }
    
    
    
    func patientRecord() {
       let parameters = [ "dbname":"patients", "doc": [
            "_id": patientUUID!,
            "device":uniqueName,
            "date":date,
            "patientAge": patientAge!,
            "patientID":patientID!,
            "patientBdate":patientBdate!,
            "patientGender":patientGender!,
            "patientEthnic":patientEthnic!,
            "patientEducation":patientEducation!,
            "patientLanguage":patientLanguage!,
            "patientHandedness":patientHandedness!,
            "patientHealth":patientHealth,
            "patientOrigin":patientOrigin!] ]
        writeRecord("write", parameters:parameters)
    }
    
    
    
    func pictureRecord(results:[[String:String]]) {
        let uuid = NSUUID().UUIDString
        let parameters = [ "dbname":"picturedata", "doc": [
            "_id": uuid,
            "device":uniqueName,
            "patient":patientUUID!,
            "date":date,
            "results":results  ] ]
        writeRecord("write", parameters:parameters)

        
    }
    
    func pronunciationRecord(results:[String:[String:String]]) {
        let uuid = NSUUID().UUIDString
        let parameters = [ "dbname":"pronunciationdata", "doc": [
            "_id": uuid,
            "device":uniqueName,
            "patient":patientUUID!,
            "date":date,
            "results":results  ] ]
        writeRecord("write", parameters:parameters)
        
        
    }
    
    func audioRecord() {
        
        let uuid = NSUUID().UUIDString
        let parameters1 = [ "dbname":"audio", "doc": [
            "_id": uuid,
            "device":uniqueName,
            "patientName": patientUUID!,
            "date":date ] ]
        writeRecord("write", parameters:parameters1)
        
       
        let audioPath = NSBundle.mainBundle().pathForResource("SoundEffect1", ofType: "mp3")
        let audioData = NSData(contentsOfFile: audioPath!)
        let stringData = audioData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let parameters2 = [ "dbname":"audio",
            "_id": uuid,
            "docid": uuid,
            "attachmentname":"testpic",
             "contenttype":"audio/mpeg3",
            "_attachments": [ "sound.mp3": ["data":stringData]]]
 
       writeRecord("create-attachment", parameters:parameters2)
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