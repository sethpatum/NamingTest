

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
    
    var commentButton = UIButton()
    var resetButton = UIButton()
    var helpButton = UIButton()
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var endTimer = false
    
    var wrongList = [String]()
    
    var image = UIImage()
    var imageView = UIImageView()
    var gesture = UIPanGestureRecognizer()
    
    var resultErrors = [[Int]]()
    var resultTimes = [[Double]]()
    var resultComments = [String]()
    
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
        
        let commentpic = UIImage(named: "commentbutton") as UIImage?
        commentButton = UIButton(type: UIButtonType.Custom) as UIButton
        commentButton.frame = CGRectMake(475, 75, 90, 90)
        commentButton.setImage(commentpic, forState: .Normal)
        commentButton.addTarget(self, action: "comment:", forControlEvents:.TouchUpInside)
        self.view.addSubview(commentButton)
        
        let endpic = UIImage(named: "stopbutton") as UIImage?
        resetButton = UIButton(type: UIButtonType.Custom) as UIButton
        resetButton.frame = CGRectMake(590, 75, 90, 90)
        resetButton.setImage(endpic, forState: .Normal)
        resetButton.addTarget(self, action: "reset:", forControlEvents:.TouchUpInside)
        self.view.addSubview(resetButton)
        
        let helppic = UIImage(named: "earbutton") as UIImage?
        helpButton = UIButton(type: UIButtonType.Custom) as UIButton
        helpButton.frame = CGRectMake(894, 75, 90, 90)
        helpButton.setImage(helppic, forState: .Normal)
        helpButton.addTarget(self, action: "HelpButton:", forControlEvents:.TouchUpInside)
        self.view.addSubview(helpButton)
        
        gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        totalCount = namingImages.count
        print(selectedTest, terminator: "")
        if(selectedTest == "Naming Pictures") {
            self.title = "Naming Pictures"
        }
        
        if toPicture == "Test Picker" {
            count = startCount
        }
        else {
            count = 0
        }
        
        corr = 0
        
        outputImage()
        
        resultErrors.append([])
        resultTimes.append([])
        resultComments.append("")
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "update:", userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        commentButton.enabled = false
        resetButton.enabled = false
        
    }
   
    @IBAction func HelpButton(sender: AnyObject) {
        imageName = getImageName()
        myUtterance = AVSpeechUtterance(string: imageName)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
        
        endTimer = true
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        /*
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = false
        commentButton.enabled = false
        
        self.navigationItem.setHidesBackButton(false, animated:true)
        */
        count += 1
        
        done()
        
    }
    
    @IBAction func correct(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = true
        commentButton.enabled = true
        print(count, startCount)
        resultErrors[count-startCount].append(0)
        resultTimes[count-startCount].append(findTime())
        
        resultsLabel.text = ""
        
        if(start) {
            startTime2 = NSDate()
            self.navigationItem.setHidesBackButton(true, animated:true)
            start = false
        }
        
        corr += 1
        
        endTimer = true
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
    }
    
    //don't know
    @IBAction func incorrect(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = true
        commentButton.enabled = true
        
        resultErrors[count-startCount].append(3)
        resultTimes[count-startCount].append(findTime())
        
        resultsLabel.text = ""
        
        if(start) {
            startTime2 = NSDate()
            self.navigationItem.setHidesBackButton(true, animated:true)
            start = false
        }
        
        wrongList.append(imageName)
        
        endTimer = true
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
    }
    
    @IBAction func semanticError(sender: AnyObject) {
        
        resultErrors[count-startCount].append(1)
        resultTimes[count-startCount].append(findTime())
        
    }
    
    
    @IBAction func perceptualError(sender: AnyObject) {
        
        resultErrors[count-startCount].append(2)
        resultTimes[count-startCount].append(findTime())
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    @IBAction func comment(sender: AnyObject){
        
        commentButton.enabled = false
        
        let alert = UIAlertController(title: "Comment", message: "Enter details about \(namingImages[count])", preferredStyle: .Alert)
        
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
    
    func done() {
        
        print("getting here")
        
        correct.enabled = false
        incorrect.enabled = false
        semanticError.enabled = false
        perceptualError.enabled = false
        
        resetButton.enabled = false
        commentButton.enabled = false
        
        helpButton.enabled = false
        
        self.navigationItem.setHidesBackButton(false, animated:true)
        imageView.userInteractionEnabled = false
        imageView.removeFromSuperview()
        
        placeLabel.text = ""
        var resjson:[[String:String]] = []
        
        for(var k=0; k<count-startCount; k++){
            let result = Results()
            result.name = namingImages[k+startCount]
            var res:[String:String] = ["imagenum":String(k+1), "imagename":result.name!]
            for(var j=0; j<resultErrors[k].count; j++){
                if(resultErrors[k][j] == 0){
                    result.longDescription.addObject("Correct at \(round(100*resultTimes[k][j])/100) seconds")
                    res["Correct"] = String(round(100*resultTimes[k][j])/100)
                }
                if(resultErrors[k][j] == 1){
                    result.longDescription.addObject("Semantic error at \(round(100*resultTimes[k][j])/100) seconds")
                    res["SemanticError"] = String(round(100*resultTimes[k][j])/100)
                }
                if(resultErrors[k][j] == 2){
                    result.longDescription.addObject("Perceptual error at \(round(100*resultTimes[k][j])/100) seconds")
                    res["PerceptualError"] = String(round(100*resultTimes[k][j])/100)
                }
                if(resultErrors[k][j] == 3){
                    result.longDescription.addObject("Don't know at \(round(100*resultTimes[k][j])/100) seconds")
                    res["DontKnow"] = String(round(100*resultTimes[k][j])/100)
                }
                if(resultErrors[k][j] == 4){
                    result.longDescription.addObject("Timer error at \(round(100*resultTimes[k-startCount][j])/100) seconds")
                    res["TimerEnd"] = String(round(100*resultTimes[k-startCount][j])/100)
                }
            }
            if(resultComments[k] != ""){
                result.longDescription.addObject("Comment: \(resultComments[k])")
                res["Comment"] = resultComments[k]
            }
            resultsArray.add(result)
            resjson.append(res)
        }
        if cloudOn {
            cloudHelper.pictureRecord(resjson)
        }

        
        
        /*
        let result = Results()
        result.name = self.title
        result.startTime = startTime2
        result.endTime = NSDate()
        result.longDescription.addObject("\(corr) correct out of \(count)")
        if wrongList.count > 0  {
            result.longDescription.addObject("The incorrect pictures were the \(wrongList)")
        }
        resultsArray.add(result)
        */
        /*
        if resultsDisplayOn == true {
            var str:String = "\(corr) correct out of \(count)"
            if wrongList.count > 0 {
                str += "\nThe incorrect pictures were the \(wrongList)"
            }
            self.resultsLabel.text = str
        }
        */
        
        
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
                commentButton.enabled = true
                
                resultErrors[count].append(4)
                resultTimes[count].append(findTime())
                
                wrongList.append(imageName)
                
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
    
    func getImageName()->String{
        
        print(count)
        print(namingImages[count])
        return namingImages[count]
        
    }
    
    func findTime()->Double{
        
        let currTime = NSDate.timeIntervalSinceReferenceDate()
        var diff: NSTimeInterval = currTime - startTime
        let minutes = UInt8(diff / 60.0)
        diff -= (NSTimeInterval(minutes)*60.0)
        let seconds = Double(diff)
        return seconds
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let img = gesture.view!
        
        img.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: 471.0)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if img.center.x < 150 {
                
                count += 1
                
                print("Result errors: \(resultErrors[count-startCount-1]), result times: \(resultTimes[count-startCount-1])")
                
                print("count = \(count), totalCount = \(totalCount)")
                
                if(count==totalCount){
                    print("should be done!")
                    
                    done()
                }
                    
                else{
                    
                    if selectedTest == "Naming Pictures" {
                        if count != namingImages.count-1 {
                            placeLabel.text = "\(count+1)/\(namingImages.count)"
                        }
                    }
                    
                    print("next pic!")
                    img.center = CGPoint(x: 512.0, y: 471.0)
                    
                    imageView.removeFromSuperview()
                    outputImage()
                    
                    resultErrors.append([])
                    resultTimes.append([])
                    resultComments.append("")
                    
                    correct.enabled = true
                    incorrect.enabled = true
                    semanticError.enabled = true
                    perceptualError.enabled = true
                    
                    resetButton.enabled = false
                    commentButton.enabled = false
                    
                    endTimer = false
                    startTime = NSDate.timeIntervalSinceReferenceDate()
                    
                }
                
            }
                
            else{
                
                print("back to center!")
                img.center = CGPoint(x: 512.0, y: 471.0)
                
            }
            
        }
    
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

