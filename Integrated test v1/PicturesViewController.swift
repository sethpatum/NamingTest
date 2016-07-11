//
//  NamingPicturesViewController.swift
//  Integrated test v1
//
//  Created by Seth Amarasinghe on 7/14/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//
import UIKit
import AVFoundation

var totalCount: Int = 0

var toPicture: String = ""


class PicturesViewController: ViewController {
    
    var imageName = ""
    var count = 0
    var corr = 0
    var start = true
    @IBOutlet weak var placeLabel: UILabel!
    
    var order = [Bool]()
    var startTime = NSTimeInterval()
    var startTime2 = NSDate()
    

    var correct = UIButton()
    var incorrect = UIButton()
    var semanticError = UIButton()
    var perceptualError = UIButton()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var endTimer = false
    
    var wrongList = [String]()
    
    var image = UIImage()
    var imageView = UIImageView()
    var gesture = UIPanGestureRecognizer()
    
    var resultErrors = [[Int]]()
    var resultTimes = [[Double]]()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    // RESULT ERRORS KEY
    //
    // CORRECT : 0
    // INCORRECT - SEMANTIC : 1
    // INCORRECT - PERCEPTUAL : 2
    // INCORRECT - "DON'T KNOW" : 3
    // INCORRECT - TIMER DONE : 4
    
    
    
    // This function will print the current picture onto the screen
    func outputImage() {
        
        imageName = getImageName()
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if 0.56*image.size.width < image.size.height {
            y = 575.0
            x = (575.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 575.0
            y = (575.0*(image.size.height)/(image.size.width))
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), (471.0-(y/2)), x, y))
        
        imageView.image = image
        
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = false
        
        self.view.addSubview(imageView)
        
        backButton.enabled = true
        resetButton.enabled = true
        
        if selectedTest == "Naming Pictures" {
            placeLabel.text = "\(count+1)/\(namingImages.count)"
        }
 
        // synthesize the name of the image to audio out
        if announceOn {
            myUtterance = AVSpeechUtterance(string: imageName)
            myUtterance.rate = 0.3
            synth.speakUtterance(myUtterance)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let checkpic = UIImage(named: "check") as UIImage?
        correct = UIButton(type: UIButtonType.Custom) as UIButton
        correct.frame = CGRectMake(15, 75, 90, 90)
        correct.setImage(checkpic, forState: .Normal)
        correct.addTarget(self, action: "correct:", forControlEvents:.TouchUpInside)
        self.view.addSubview(correct)
        
        let xpic = UIImage(named: "x") as UIImage?
        incorrect = UIButton(type: UIButtonType.Custom) as UIButton
        incorrect.frame = CGRectMake(130, 75, 90, 90)
        incorrect.setImage(xpic, forState: .Normal)
        incorrect.addTarget(self, action: "incorrect:", forControlEvents:.TouchUpInside)
        self.view.addSubview(incorrect)
        
        let eyepic = UIImage(named: "eyebutton") as UIImage?
        perceptualError = UIButton(type: UIButtonType.Custom) as UIButton
        perceptualError.frame = CGRectMake(245, 75, 90, 90)
        perceptualError.setImage(eyepic, forState: .Normal)
        perceptualError.addTarget(self, action: "perceptualError:", forControlEvents:.TouchUpInside)
        self.view.addSubview(perceptualError)
        
        let umbrellapic = UIImage(named: "umbrellabutton") as UIImage?
        semanticError = UIButton(type: UIButtonType.Custom) as UIButton
        semanticError.frame = CGRectMake(360, 75, 90, 90)
        semanticError.setImage(umbrellapic, forState: .Normal)
        semanticError.addTarget(self, action: "semanticError:", forControlEvents:.TouchUpInside)
        self.view.addSubview(semanticError)
        
        gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        print("0 interaction enabled is \(imageView.userInteractionEnabled)")
        
        
        print(selectedTest, terminator: "")
        if(selectedTest == "Naming Pictures") {
            self.title = "Naming Pictures"
            totalCount = namingImages.count
        }
        
        if toPicture == "Test Picker" {
            count = startCount
        } else {
            count = 0
        }
        
        corr = 0
        
        outputImage()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "update:", userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
   
    @IBAction func HelpButton(sender: AnyObject) {
        imageName = getImageName()
        myUtterance = AVSpeechUtterance(string: imageName)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
        /*
        if(selectedTest == "Naming Pictures") {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Naming Pictures Help") as UIViewController
            navigationController?.pushViewController(vc, animated:true)
        } */
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        
        correct.enabled = true
        incorrect.enabled = true
        semanticError.enabled = true
        perceptualError.enabled = true
        
        resetButton.enabled = false
        backButton.enabled = false
        helpButton.enabled = false
        
        self.navigationItem.setHidesBackButton(false, animated:true)
        
        done()
        
        order = [Bool]()
        wrongList = [String]()
        count = 0
        corr = 0
        
        
        imageView.removeFromSuperview()
        
        outputImage()
        
    }
    
    @IBAction func correct(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = true
        backButton.enabled = true
        helpButton.enabled = true
        
        resultsLabel.text = ""
        
        if(start) {
            startTime2 = NSDate()
            self.navigationItem.setHidesBackButton(true, animated:true)
            backButton.enabled = true
            resetButton.enabled = true
            start = false
        }
        
        count += 1
        corr += 1
        
        endTimer = true
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        if(count==totalCount){
            done()
        }
        
        else{
            
            order.append(true)
            
            if selectedTest == "Naming Pictures" {
                if count != namingImages.count {
                    placeLabel.text = "\(count+1)/\(namingImages.count)"
                }
            }
            
        }
        
    }
    
    //don't know
    @IBAction func incorrect(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = true
        backButton.enabled = true
        helpButton.enabled = true
        
        resultsLabel.text = ""
        
        if(start) {
            startTime2 = NSDate()
            self.navigationItem.setHidesBackButton(true, animated:true)
            backButton.enabled = true
            resetButton.enabled = true
            start = false
        }
        
        count += 1
        wrongList.append(imageName)
        
        endTimer = true
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        if(count==totalCount){
            done()
        }
        
        else{
            
            order.append(false)
            
            if selectedTest == "Naming Pictures" {
                if count != namingImages.count-1 {
                    placeLabel.text = "\(count+1)/\(namingImages.count)"
                }
            }
            
        }
        
    }
    
    @IBAction func semanticError(sender: AnyObject) {
    }
    
    
    @IBAction func perceptualError(sender: AnyObject) {
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        correct.enabled = true
        incorrect.enabled = true
        semanticError.enabled = true
        perceptualError.enabled = true
        
        resetButton.enabled = false
        backButton.enabled = true
        helpButton.enabled = false
        
        count -= 1
        if count == 0 {
            resetButton.enabled = false
            backButton.enabled = false
            self.navigationItem.setHidesBackButton(false, animated:true)
        }
        if order.count > 0 {
            if order[order.count-1] == true {
                corr -= 1
            }
            else {
                wrongList.removeAtIndex(wrongList.count-1)
            }
            
            order.removeAtIndex(order.count-1)
        }
        
        
        imageView.removeFromSuperview()
        
        outputImage()
        
    }
    
    func done() {
        
        print("getting here")
        
        backButton.enabled = false
        self.navigationItem.setHidesBackButton(false, animated:true)
        
        placeLabel.text = ""
        
        let result = Results()
        result.name = self.title
        result.startTime = startTime2
        result.endTime = NSDate()
        result.longDescription.addObject("\(corr) correct out of \(count)")
        if wrongList.count > 0  {
            result.longDescription.addObject("The incorrect pictures were the \(wrongList)")
        }
        resultsArray.add(result)
        
        if resultsDisplayOn == true {
            var str:String = "\(corr) correct out of \(count)"
            if wrongList.count > 0 {
                str += "\nThe incorrect pictures were the \(wrongList)"
            }
            self.resultsLabel.text = str
        }
        
    }
    
    func update(timer: NSTimer) {
        
        if(endTimer == false){
            let currTime = NSDate.timeIntervalSinceReferenceDate()
            var diff: NSTimeInterval = currTime - startTime
            
            let minutes = UInt8(diff / 60.0)
            
            diff -= (NSTimeInterval(minutes)*60.0)
            
            let seconds = UInt8(diff)
            
            diff = NSTimeInterval(seconds)
            
            let strMinutes = minutes > 9 ? String(minutes):"0"+String(minutes)
            let strSeconds = seconds > 9 ? String(seconds):"0"+String(seconds)
            
            timerLabel.text = "\(strMinutes) : \(strSeconds)"
            
            if(seconds>=20){
                print("endTimer = true")
                endTimer = true
                imageView.addGestureRecognizer(gesture)
                imageView.userInteractionEnabled = true
                print("should allow gesture")
                
                correct.enabled = false
                incorrect.enabled = false
                semanticError.enabled = false
                perceptualError.enabled = false
                
                resetButton.enabled = true
                backButton.enabled = true
                helpButton.enabled = true
                
                count += 1
                wrongList.append(imageName)
                
                if(count==totalCount){
                    done()
                }
                    
                else{
                    
                    order.append(false)
                    
                    if selectedTest == "Naming Pictures" {
                        if count != namingImages.count-1 {
                            placeLabel.text = "\(count+1)/\(namingImages.count)"
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    /*
    let namingImages2:[String] = ["A. Schwarzenegger", "B. Clinton", "B. Murray", "B. Obama", "E. Presley", "G. Bush", "G. Clooney", "H. Clinton", "J. Leno", "J. Travolta", "M. Monroe", "M. Obama", "MLK", "O. Winfrey", "R. Williams", "R. Williams"]
    */


    func getImageName()->String{
        
        print(count)
        print(namingImages[count])
        return namingImages[count]
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let img = gesture.view!
        
        img.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: 471.0)
        
        //y: self.view.bounds.height / 2 + translation.y
        
        /*
        let xFromCenter = img.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        img.transform = stretch
        */
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if img.center.x < 150 {
                
                print("next pic!")
                img.center = CGPoint(x: 512.0, y: 471.0)
                
                
                imageView.removeFromSuperview()
                outputImage()
                
                correct.enabled = true
                incorrect.enabled = true
                semanticError.enabled = true
                perceptualError.enabled = true
                
                resetButton.enabled = false
                backButton.enabled = false
                helpButton.enabled = false
                
                endTimer = false
                startTime = NSDate.timeIntervalSinceReferenceDate()
                
            }
                
            else{
                
                print("back to center!")
                img.center = CGPoint(x: 512.0, y: 471.0)
                
            }
            
        }
        
        /*
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey:acceptedOrRejected)
                
                PFUser.currentUser()?.save()
                
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
*/
        
        
        
    }
    
    
}

extension CollectionType {
    
    /// Return a copy of `self` with its elements shuffled
    
    func shuffle() -> [Generator.Element] {
        
        var list = Array(self)
        
        list.shuffleInPlace()
        
        return list
        
    }
    
}

extension MutableCollectionType where Index == Int {
    
    /// Shuffle the elements of `self` in-place.
    
    mutating func shuffleInPlace() {
        
        // empty and single-element collections don't shuffle
        
        if count < 2 { return }
        
        
        
        for i in 0..<count - 1 {
            
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            
            guard i != j else { continue }
            
            swap(&self[i], &self[j])
            
        }
        
    }
    
}

