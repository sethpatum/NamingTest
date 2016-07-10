//
//  SetupViewController.swift
//  Integrated test v1
//
//  Created by saman on 8/16/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//

import UIKit

var cloudOn   : Bool = true
var emailOn  : Bool = false
var announceOn : Bool = true
var emailAddress : String = ""
var ipadName : String = ""
var uniqueName : String = ""
var resultsDisplayOn : Bool = true

class SetupViewController: ViewController {

   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailOnOff: UISwitch!
    @IBOutlet weak var announceOnOff: UISwitch!
    @IBOutlet weak var cloudOnOff: UISwitch!
    @IBOutlet weak var ipName: UITextField!
    @IBOutlet weak var resultsDisplayOnOff: UISwitch!
    @IBOutlet weak var uName: UILabel!
    
    @IBAction func emailOnOff(sender: AnyObject) {
        emailOn = emailOnOff.on
        email.enabled = emailOn
        NSUserDefaults.standardUserDefaults().setBool(!emailOn, forKey: "emailOff")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func emailChanged(sender: AnyObject) {
        emailAddress = email.text!
        NSUserDefaults.standardUserDefaults().setObject(emailAddress, forKey:"emailAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func cloudOnOff(sender: UISwitch) {
        cloudOn = cloudOnOff.on
        NSUserDefaults.standardUserDefaults().setBool(!cloudOn, forKey: "cloudOff")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func iPadNameChanged(sender: AnyObject) {
        ipadName = ipName.text!
        NSUserDefaults.standardUserDefaults().setObject(ipadName, forKey:"iPadName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func ResultsDisplayOnOff(sender: AnyObject) {
        resultsDisplayOn = resultsDisplayOnOff.on
        NSUserDefaults.standardUserDefaults().setBool(!resultsDisplayOn, forKey: "resultsDisplayOff")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func announceOnOff(sender: AnyObject) {
        announceOn = announceOnOff.on
        NSUserDefaults.standardUserDefaults().setBool(!announceOn, forKey: "announceOff")
        NSUserDefaults.standardUserDefaults().synchronize()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudOn = !NSUserDefaults.standardUserDefaults().boolForKey("cloudOff")
        emailOn = !NSUserDefaults.standardUserDefaults().boolForKey("emailOff")
        announceOn = !NSUserDefaults.standardUserDefaults().boolForKey("announceOff")

        resultsDisplayOn = !NSUserDefaults.standardUserDefaults().boolForKey("resultsDisplayOff")

        if(NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") != nil) {
            emailAddress = NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") as! String
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("iPadName") != nil) {
            ipadName = NSUserDefaults.standardUserDefaults().objectForKey("iPadName") as! String
        } else {
            // if there is no name, use the device name
            ipadName = UIDevice.currentDevice().name
            NSUserDefaults.standardUserDefaults().setObject(ipadName, forKey:"iPadName")
            NSUserDefaults.standardUserDefaults().synchronize()

        }
       
        uniqueName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        uName.text = uniqueName
        email.enabled = emailOn
        emailOnOff.on = emailOn
        cloudOnOff.on = cloudOn
        announceOnOff.on = announceOn
        email.text = emailAddress
        ipName.text = ipadName
        resultsDisplayOnOff.on = resultsDisplayOn
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
