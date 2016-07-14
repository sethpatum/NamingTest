//
//  PatientUIViewController.swift
//  Integrated test v1
//
//  Created by saman on 8/6/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

var firstTimeThrough = true

var mailSubject : String = "CNToolkit Results"
var patientName : String?
var patientAge : String?
var patientID : String?
var patientBdate : String?
var patientUUID : String?


class PatientUIViewController: ViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var recordingSession: AVAudioSession!
    
    var whistleRecorder: AVAudioRecorder!
    var whistlePlayer: AVAudioPlayer!
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    
                }
            }
        } catch {
            
        }
        
    }
    */
    
    var body:String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var IDlabel: UILabel!
    @IBOutlet weak var IDfield: UITextField!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdateField: UIDatePicker!
    
    @IBOutlet weak var UUID: UILabel!
    
    @IBAction func StartTesting(sender: AnyObject) {
        if firstTimeThrough == true {
            firstTimeThrough = false
            performSegueWithIdentifier("toDisclaimer", sender: self)
        } else {
            performSegueWithIdentifier("toTestSelection", sender: self)
        }
    }
    
    
    
    @IBAction func updateName(sender: AnyObject) {
        patientName = nameField.text
    }
    
    
    @IBAction func updateAge(sender: AnyObject) {
        patientAge = ageTextField.text
    }
    
    @IBAction func updateID(sender: AnyObject) {
        patientID = IDfield.text
    }
    
    @IBAction func updateBdate(sender: AnyObject) {
        let d:UIDatePicker = sender as! UIDatePicker
        let formatter = NSDateFormatter()
        formatter.dateFormat = "y-MM-dd"
        patientBdate = formatter.stringFromDate(d.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientUUID = NSUUID().UUIDString
        UUID.text = patientUUID
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    
                }
            }
        } catch {
            
        }
        
        // load the defaults from presistant memory
        emailOn = !NSUserDefaults.standardUserDefaults().boolForKey("emailOff")
        resultsDisplayOn = !NSUserDefaults.standardUserDefaults().boolForKey("resultsDisplayOff")
        announceOn = !NSUserDefaults.standardUserDefaults().boolForKey("announceOff")
        cloudOn = !NSUserDefaults.standardUserDefaults().boolForKey("cloudOff")
        
        uniqueName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        ipadName = UIDevice.currentDevice().name
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") != nil) {
            emailAddress = NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") as! String
        }

        
        let currentDate = NSDate()
        birthdateField.maximumDate = currentDate
        
        
        // Seguing here from Test selection
        if(selectedTest == "DONE") {
            if(emailOn) {
                body = resultsArray.emailBody()
                let picker = MFMailComposeViewController()
                picker.mailComposeDelegate = self
                picker.setSubject(mailSubject)
                picker.setMessageBody(body!, isHTML: true)
                picker.setToRecipients([emailAddress])
                presentViewController(picker, animated: true, completion: nil)
            }
            selectedTest = ""
            resultsArray.doneWithPatient()
        }
        
        patientName = ""
        patientID = ""
        patientAge = ""
        patientBdate = ""
        
        if(cloudOn) {
            cloudHelper.deviceRecord()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(cloudOn) {
            cloudHelper.patientRecord()
            cloudHelper.audioRecord()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        let documentsDirectory = paths[0]
        print("Document:", documentsDirectory)
        return documentsDirectory
    }
    
    class func getWhistleURL() -> NSURL {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("whistle.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        print("URL:", audioURL)
        return audioURL
    }
    //drop
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        body = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }


}
