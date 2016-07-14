//
//  TestPickerViewController.swift
//  CNToolkit
//
//  Created by saman on 7/10/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
var startCount: Int = 0

class TestPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var TestPicker: UIPickerView!
    
     var imagelist:[Int] = [Int]()
    
    var image = UIImage()
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in 1...namingImages.count {
           imagelist.append(i)
        }
        
        self.TestPicker.delegate = self
        self.TestPicker.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        toPicture = "Test Picker"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imagelist.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        startCount = row

        let imageName = namingImages[row]
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if image.size.width < image.size.height {
            y = 300.0
            x = (300.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 300.0
            y = (300.0*(image.size.height)/(image.size.width))
        }
        
        // remove the old imageView
        if let viewWithTag = self.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 480.0, x, y))
        imageView.tag = 1000
        
        imageView.image = image
        self.view.addSubview(imageView)

        return String(imagelist[row]) + "   " + namingImages[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        startCount = row
        
        let imageName = namingImages[row]
        
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if image.size.width < image.size.height {
            y = 300.0
            x = (300.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 300.0
            y = (300.0*(image.size.height)/(image.size.width))
        }
        
        // remove the old imageView
        if let viewWithTag = self.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), 480.0, x, y))
        imageView.tag = 1000
        
        imageView.image = image
        self.view.addSubview(imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
