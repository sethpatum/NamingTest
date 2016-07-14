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
var patientGender : String?
var patientEthnic : String?
var patientEducation : String?
var patientLanguage : String?
var patientHandedness : String?
var patientMemory : String?
var patientHealth : String?
var patientOrigin : String?


class PatientUIViewController: ViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate {
    
    @IBOutlet weak var GenderPicker: UIPickerView!
    let genderData = ["Male", "Female", "Other", "Prefer Not To Say"]
    
    @IBOutlet weak var EthnicPicker: UIPickerView!
    let ethnicData = ["Caucasian", "African American", "Latino", "Other"]
    
    @IBOutlet weak var EducationPicker: UIPickerView!
    let educationData = ["< 9 yrs", "9-11 yrs", "High School Graduate", "Associates Degree", "Bachelors Degree", "Post Graduate Degree"]
    
    @IBOutlet weak var LanguagePicker: UIPickerView!
    let languageData = ["English", "Spanish", "Other",]
    
    @IBOutlet weak var HandedPicker: UIPickerView!
    let handedData = ["Left Handed", "Right Handed", "Ambidextrous"]
    
    
    @IBOutlet weak var MemoryPicker: UIPickerView!
    let memoryData = ["Yes", "No"]
    
    @IBOutlet weak var HealthPicker: UIPickerView!
    let healthData = ["Hypertension", "Diabetes", "Renal Problems", "Other"]
    
    @IBOutlet weak var OriginPicker: UIPickerView!
    let originData = ["United States", "Mexico", "Purto Rico", "South America", "Western Europe", "Eastern Europe", "Southeast Asia", "Cape Verde", "Canada", "Sri Lanka"]
    
    
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
        
        GenderPicker.delegate = self
        EthnicPicker.delegate = self
        EducationPicker.delegate = self
        LanguagePicker.delegate = self
        HandedPicker.delegate = self
        MemoryPicker.delegate = self
        HealthPicker.delegate = self
        OriginPicker.delegate = self
        
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
                
                if(cloudOn) {
                    cloudHelper.deviceRecord()
                }
            }
            selectedTest = ""
            resultsArray.doneWithPatient()
        }
        
        patientName = ""
        patientID = ""
        patientAge = ""
        patientBdate = ""
        patientGender = ""
        
       
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
    
    
    // Setting up for all the pickers
    
    func numberOfComponentsInPickerView(pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == GenderPicker {
            return genderData.count
        }
        if pickerView == EthnicPicker {
            return ethnicData.count
        }
        if pickerView == EducationPicker {
            return educationData.count
        }
        if pickerView == LanguagePicker {
            return languageData.count
        }
        if pickerView == HandedPicker {
            return handedData.count
        }
        if pickerView == MemoryPicker {
            return memoryData.count
        }
        if pickerView == HealthPicker {
            return healthData.count
        }
        if pickerView == OriginPicker {
            return originData.count
        }
        return 1
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == GenderPicker {
            patientGender = genderData[row]
            return genderData[row]
        }
        if pickerView == EthnicPicker {
            patientEthnic = ethnicData[row]
            return ethnicData[row]
        }
        if pickerView == EducationPicker {
            patientEducation = educationData[row]
            return educationData[row]
        }
        if pickerView == LanguagePicker {
            patientLanguage = languageData[row]
            return languageData[row]
        }
        if pickerView == HandedPicker {
            patientHandedness = handedData[row]
            return handedData[row]
        }
        if pickerView == MemoryPicker {
            patientMemory = memoryData[row]
            return memoryData[row]
        }
        if pickerView == HealthPicker {
            patientHealth = healthData[row]
            return healthData[row]
        }
        if pickerView == OriginPicker {
            patientOrigin = originData[row]
            return originData[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == GenderPicker {
            patientGender = genderData[row]
        }
        if pickerView == EthnicPicker {
            patientEthnic = ethnicData[row]
        }
        if pickerView == EducationPicker {
            patientEducation = educationData[row]
        }
        if pickerView == LanguagePicker {
            patientLanguage = languageData[row]
        }
        if pickerView == HandedPicker {
            patientHandedness = handedData[row]
        }
        if pickerView == MemoryPicker {
            patientMemory = memoryData[row]
        }
        if pickerView == HealthPicker {
            patientHealth = healthData[row]
        }
        if pickerView == OriginPicker {
            patientOrigin = originData[row]
        }
    
    
    }

}

