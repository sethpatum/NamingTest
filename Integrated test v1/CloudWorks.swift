//
//  CloudWorks.swift
//  CNToolkit
//
//  Created by saman on 7/10/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}


class CloudWorks {
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    var delegate : CloudKitDelegate?


    // Initilize the data structures needed
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    
    // Check if a record for this device exists. 
    // if there is an error, try to add a record
    // or if the results is zero records, try to add a record
    // if there are more than 1 record, a problem, report.
    func deviceRecord() {
        let predicate = NSPredicate(format: "UUID == %@", uniqueName)
        let query = CKQuery(recordType: "Devices",
                            predicate:  predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    print(error)
                    self.addDeviceRecord()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    if results!.count == 0 {
                        self.addDeviceRecord()
                    }
                    
                    if results!.count > 1 {
                        self.notifyUser("Too many Device Records", message: "Too many device records found")
                    }
                    return
                }
            }
        }
    }
    
    
    // Add a record for this device
    func addDeviceRecord() {
        let myrec = CKRecord(recordType: "Devices")
        myrec.setValue(uniqueName, forKey: "UUID")
        myrec.setValue(ipadName, forKey:"DeviceName")
        
        self.publicDB.saveRecord(myrec, completionHandler: { (record, error) -> Void in
            if let err = error {
                self.notifyUser("Save Error", message:
                    err.localizedDescription)
            }
        })
    }
    
    
    
    func patientRecord() {
        let predicate = NSPredicate(format: "(DeviceUUID == %@) AND (PatientUUID == %@)", uniqueName, patientUUID!)
        let query = CKQuery(recordType: "Patient",
                            predicate:  predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    print(error)
                    self.addPatientRecord()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    if results!.count == 0 {
                        self.addPatientRecord()
                    }
                    return
                }
            }
        }

    }
    
    func addPatientRecord() {
        let myrec = CKRecord(recordType: "Patient")
        myrec.setValue(uniqueName, forKey: "DeviceUUID")
        myrec.setValue(patientUUID, forKey:"PatientUUID")
        myrec.setValue(patientName, forKey:"Name")
        myrec.setValue(patientAge, forKey:"Age")
        myrec.setValue(patientBdate, forKey:"BirthDate")

        self.publicDB.saveRecord(myrec, completionHandler: { (record, error) -> Void in
            if let err = error {
                self.notifyUser("Save Error", message:
                    err.localizedDescription)
            }
        })

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