//
//  PronunciationTaskViewController.swift
//  CNToolkit
//
//  Created by Ellison Lim on 7/14/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PronunciationViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var count = 0
    var order = [Bool]()
    
    var correct = UIButton()
    var incorrect = UIButton()
    var resetButton = UIButton()
    var helpButton = UIButton()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var groupWords:[String] = ["two", "address", "whole", "eye", "again", "enough", "already", "cough", "fuel", "climb", "most", "excitement", "mosquito", "decorate", "fierce", "plumb", "knead", "vengeance", "gnat", "prestigious", "amphitheater", "lacuna", "iridescent", "lieu", "wily", "aesthetic", "equestrian", "porpoise", "subtle", "palatable", "homily", "ogre", "liason", "xenophobia", "dichotomy", "menagerie", "umbrage", "fecund", "scurrilous", "heinous", "obfuscate", "plethora", "exigency", "lascivious", "paradigm", "cretonne", "vicissitude", "ethereal", "uxorious", "lugubrious", "piquant", "perspicuity", "ubiquitous", "hyperbole", "facetious", "treatise", "picot", "macabre", "anechoic", "acquiesce", "dilettante", "eyrir", "misogyny", "vertiginous", "hegemony", "insouciant", "vide", "chthonic", "vivace", "celidh" ]
    
    @IBAction func Correct(sender: AnyObject) {
        
        order.append(true)
        
        count += 1
        
        if(count == groupWords.count){
            done()
        }
        
        else{
            wordLabel.text = groupWords[count]
            placeLabel.text = "\(count+1)/\(groupWords.count)"
        }
        
    }
    
    @IBAction func Incorrect(sender: AnyObject) {
        
        order.append(false)
        
        count += 1
        
        if(count == groupWords.count){
            done()
        }
            
        else{
            wordLabel.text = groupWords[count]
            placeLabel.text = "\(count+1)/\(groupWords.count)"
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let checkpic = UIImage(named: "check") as UIImage?
        correct = UIButton(type: UIButtonType.Custom) as UIButton
        correct.frame = CGRectMake(75, 100, 90, 90)
        correct.setImage(checkpic, forState: .Normal)
        correct.addTarget(self, action: "Correct:", forControlEvents:.TouchUpInside)
        correct.enabled = true
        self.view.addSubview(correct)
        
        let xpic = UIImage(named: "x") as UIImage?
        incorrect = UIButton(type: UIButtonType.Custom) as UIButton
        incorrect.frame = CGRectMake(280, 100, 90, 90)
        incorrect.setImage(xpic, forState: .Normal)
        incorrect.addTarget(self, action: "Incorrect:", forControlEvents:.TouchUpInside)
        incorrect.enabled = true
        self.view.addSubview(incorrect)
        
        let endpic = UIImage(named: "stopbutton") as UIImage?
        resetButton = UIButton(type: UIButtonType.Custom) as UIButton
        resetButton.frame = CGRectMake(590, 100, 90, 90)
        resetButton.setImage(endpic, forState: .Normal)
        resetButton.addTarget(self, action: "reset:", forControlEvents:.TouchUpInside)
        self.view.addSubview(resetButton)
        
        let helppic = UIImage(named: "earbutton") as UIImage?
        helpButton = UIButton(type: UIButtonType.Custom) as UIButton
        helpButton.frame = CGRectMake(894, 100, 90, 90)
        helpButton.setImage(helppic, forState: .Normal)
        helpButton.addTarget(self, action: "HelpButton:", forControlEvents:.TouchUpInside)
        self.view.addSubview(helpButton)

        
        wordLabel.text = groupWords[0]
        placeLabel.text = "1/\(groupWords.count)"
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
    }
    
    @IBAction func HelpButton(sender: AnyObject) {
        if count < groupWords.count {
            let imageName = groupWords[count]
            let myUtterance = AVSpeechUtterance(string: imageName)
            myUtterance.rate = 0.3
            synth.speakUtterance(myUtterance)
        }
        
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        //count += 1
        
        done()
        
    }

    
    
    func done(){
        self.navigationItem.setHidesBackButton(false, animated:true)
        correct.enabled = false
        incorrect.enabled = false
        
        let result = Results()
        result.name = "Pronunciation Task"
        
        var rightjson:[String:String] = [:]
        var wrongjson:[String:String] = [:]
        
        var rightlist = [String]()
        var wronglist = [String]()
        
        for(var k=0; k<count; k++){
            if(order[k] == false){
                wronglist.append(groupWords[k])
                wrongjson[String(k)] = groupWords[k]
            } else {
                rightlist.append(groupWords[k])
                rightjson[String(k)] = groupWords[k]
            }
        }
        
        result.longDescription.addObject("\(rightlist.count) correct out of \(wronglist.count+rightlist.count) tried")
        
        if(rightlist.count > 0){
            var str = String()
            for(var k=0; k<rightlist.count; k++){
                str += "\(rightlist[k]), "
            }
            str = str.substringToIndex(str.endIndex.predecessor().predecessor())
            print(str)
            result.longDescription.addObject("Correct words: \(str)")
        }
        
        if(wronglist.count > 0){
            var str = String()
            for(var k=0; k<wronglist.count; k++){
                str += "\(wronglist[k]), "
            }
            str = str.substringToIndex(str.endIndex.predecessor().predecessor())
            print(str)
            result.longDescription.addObject("Incorrect words: \(str)")
        }
        
        if cloudOn {
            cloudHelper.pronunciationRecord(["Incorrect":wrongjson, "Correct":rightjson])
        }
        
        resultsArray.add(result)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}