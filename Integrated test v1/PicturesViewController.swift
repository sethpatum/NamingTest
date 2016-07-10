//
//  NamingPicturesViewController.swift
//  Integrated test v1
//
//  Created by Seth Amarasinghe on 7/14/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//
import UIKit

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
    
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var semanticErrorButton: UIButton!
    @IBOutlet weak var perceptualErrorButton: UIButton!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var endTimer = false
    
    var wrongList = [String]()
    
    var image = UIImage()
    var imageView = UIImageView()
    var gesture = UIPanGestureRecognizer()
    
    var resultErrors = [[Int]]()
    var resultTimes = [[Double]]()
    
    // RESULT ERRORS KEY
    //
    // CORRECT : 0
    // INCORRECT - SEMANTIC : 1
    // INCORRECT - PERCEPTUAL : 2
    // INCORRECT - "DON'T KNOW" : 3
    // INCORRECT - TIMER DONE : 4
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        print("0 interaction enabled is \(imageView.userInteractionEnabled)")
        
        getImages()
        
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
        imageName = getImageName()
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if image.size.width < image.size.height {
            y = 575.0
            x = (575.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 575.0
            y = (575.0*(image.size.height)/(image.size.width))
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 180.0, x, y))
        
        imageView.image = image
        
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = false
        
        print("1 interaction enabled is \(imageView.userInteractionEnabled)")
        
        self.view.addSubview(imageView)
        
        print("2 interaction enabled is \(imageView.userInteractionEnabled)")
        
        backButton.enabled = false
        resetButton.enabled = false
        
        if selectedTest == "Naming Pictures" {
            placeLabel.text = "\(count+1)/\(namingImages.count)"
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "update:", userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
   
    @IBAction func HelpButton(sender: AnyObject) {
        if(selectedTest == "Naming Pictures") {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Naming Pictures Help") as UIViewController
            navigationController?.pushViewController(vc, animated:true)
        }
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        
        resetButton.enabled = false
        backButton.enabled = false
        self.navigationItem.setHidesBackButton(false, animated:true)
        
        done()
        
        order = [Bool]()
        wrongList = [String]()
        count = 0
        corr = 0
        
        imageName = getImageName()
        
        imageView.removeFromSuperview()
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if image.size.width < image.size.height {
            y = 575.0
            x = (575.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 575.0
            y = (575.0*(image.size.height)/(image.size.width))
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 180.0, x, y))
        
        imageView.image = image
        
        self.view.addSubview(imageView)
        
        correctButton.enabled = true
        incorrectButton.enabled = true
        
        if selectedTest == "Naming Pictures" {
            placeLabel.text = "\(count+1)/\(namingImages.count)"
        }
        
    }
    
    @IBAction func correct(sender: AnyObject) {
        
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
        
        imageName = getImageName()
        
        imageView.removeFromSuperview()
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if image.size.width < image.size.height {
            y = 575.0
            x = (575.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 575.0
            y = (575.0*(image.size.height)/(image.size.width))
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 180.0, x, y))
        
        imageView.image = image
        
        self.view.addSubview(imageView)
        
        if selectedTest == "Naming Pictures" {
            placeLabel.text = "\(count+1)/\(namingImages.count)"
        }
        
    }
    
    func done() {
        
        print("getting here")
        
        backButton.enabled = false
        correctButton.enabled = false
        incorrectButton.enabled = false
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
                img.center = CGPoint(x: 507.0, y: 471.0)
                
                imageName = getImageName()
                
                imageView.removeFromSuperview()
                
                image = UIImage(named: imageName)!
                
                var x = CGFloat()
                var y = CGFloat()
                if image.size.width < image.size.height {
                    y = 575.0
                    x = (575.0*(image.size.width)/(image.size.height))
                }
                else {
                    x = 575.0
                    y = (575.0*(image.size.height)/(image.size.width))
                }
                
                imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 180.0, x, y))
                
                imageView.image = image
                
                imageView.addGestureRecognizer(gesture)
                imageView.userInteractionEnabled = false
                
                self.view.addSubview(imageView)
                
                endTimer = false
                startTime = NSDate.timeIntervalSinceReferenceDate()
                
            }
                
            else{
                
                print("back to center!")
                img.center = CGPoint(x: 507.0, y: 471.0)
                
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

