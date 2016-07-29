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

var mailSubject : String = "Updated Boston Naming Test -- Data Collection Results"
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


func makeAgeData() -> [String] {
    var str:[String] = []
    for i in 1...120 {
        str.append(String(i))
    }
    return str
}


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
    
    @IBOutlet weak var AgePicker: UIPickerView!
    var ageData:[String] = makeAgeData()
    
    @IBOutlet weak var MemoryPicker: UIPickerView!
    let memoryData = ["Yes", "No"]
    
    @IBOutlet weak var HealthPicker: UIPickerView!
    let healthData = ["None", "Hypertension", "Diabetes", "Renal Problems", "Other"]
    
    @IBOutlet weak var OriginPicker: UIPickerView!
    let originData = ["United States", "Mexico", "Purto Rico", "South America", "Western Europe", "Eastern Europe", "Southeast Asia", "Cape Verde", "Canada", "Sri Lanka", "Other"]
    
    
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
        
        AgePicker.delegate = self
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
        announceOn = NSUserDefaults.standardUserDefaults().boolForKey("announceOn")
        cloudOn = !NSUserDefaults.standardUserDefaults().boolForKey("cloudOff")
        testmodeOn = NSUserDefaults.standardUserDefaults().boolForKey("testmodeOn")
        
        uniqueName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        ipadName = UIDevice.currentDevice().name
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") != nil) {
            emailAddress = NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") as! String
        }

        
        let currentDate = NSDate()
        birthdateField.maximumDate = currentDate
        
        if(selectedTest == "DONE") {
            print("IN DONE")
            if(cloudOn) {
                cloudHelper.patientRecord()
                //cloudHelper.audioRecord()
            }
            
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

        
        // Seguing here from Test selection
        
        patientUUID = NSUUID().UUIDString
        UUID.text = patientUUID
        
        patientName = ""
        patientID = ""
        patientAge = ageData[AgePicker.selectedRowInComponent(0)]
        patientGender = genderData[GenderPicker.selectedRowInComponent(0)]
        patientEthnic = ethnicData[EthnicPicker.selectedRowInComponent(0)]
        patientEducation = educationData[EducationPicker.selectedRowInComponent(0)]
        patientLanguage = languageData[LanguagePicker.selectedRowInComponent(0)]
        patientHandedness = handedData[HandedPicker.selectedRowInComponent(0)]
        patientMemory = memoryData[MemoryPicker.selectedRowInComponent(0)]
        patientHealth = healthData[HealthPicker.selectedRowInComponent(0)]
        patientOrigin = originData[OriginPicker.selectedRowInComponent(0)]
        let formatter = NSDateFormatter()
        formatter.dateFormat = "y-MM-dd"
        patientBdate = formatter.stringFromDate(birthdateField.date)

        
        if(cloudOn) {
            cloudHelper.deviceRecord()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
        if pickerView == AgePicker {
            return ageData.count
        } else if pickerView == GenderPicker {
            return genderData.count
        } else if pickerView == EthnicPicker {
            return ethnicData.count
        } else if pickerView == EducationPicker {
            return educationData.count
        } else if pickerView == LanguagePicker {
            return languageData.count
        } else if pickerView == HandedPicker {
            return handedData.count
        } else if pickerView == MemoryPicker {
            return memoryData.count
        } else if pickerView == HealthPicker {
            return healthData.count
        } else if pickerView == OriginPicker {
            return originData.count
        }
        return 1
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == AgePicker {
            patientAge = ageData[row]
            return ageData[row]
        } else if pickerView == GenderPicker {
            patientGender = genderData[row]
            return genderData[row]
        } else if pickerView == EthnicPicker {
            patientEthnic = ethnicData[row]
            return ethnicData[row]
        } else if pickerView == EducationPicker {
            patientEducation = educationData[row]
            return educationData[row]
        } else if pickerView == LanguagePicker {
            patientLanguage = languageData[row]
            return languageData[row]
        } else if pickerView == HandedPicker {
            patientHandedness = handedData[row]
            return handedData[row]
        } else if pickerView == MemoryPicker {
            patientMemory = memoryData[row]
            return memoryData[row]
        } else if pickerView == HealthPicker {
            patientHealth = healthData[row]
            return healthData[row]
        } else if pickerView == OriginPicker {
            patientOrigin = originData[row]
            return originData[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == AgePicker {
            patientAge = ageData[row]
        } else if pickerView == GenderPicker {
            patientGender = genderData[row]
        } else if pickerView == EthnicPicker {
            patientEthnic = ethnicData[row]
        } else if pickerView == EducationPicker {
            patientEducation = educationData[row]
        } else if pickerView == LanguagePicker {
            patientLanguage = languageData[row]
        } else if pickerView == HandedPicker {
            patientHandedness = handedData[row]
        } else if pickerView == MemoryPicker {
            patientMemory = memoryData[row]
        } else if pickerView == HealthPicker {
            patientHealth = healthData[row]
        } else if pickerView == OriginPicker {
            patientOrigin = originData[row]
        }
    }
    
    let alert = OrigenPicker (title: "Comment", message: "Enter details about \(namingImages[count])", preferredStyle: .Alert)
    
    //2. Add the text field. You can configure it however you need.
    
    alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
    textField.text = ""
    
    })
    
    //3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
    let textField = alert.textFields![0] as UITextField
    self.resultComments[self.count-startCount] = textField.text!
    }))
    
    // 4. Present the alert.
    self.presentViewController(alert, animated: true, completion: nil)

}

