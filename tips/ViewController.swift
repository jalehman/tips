//
//  ViewController.swift
//  tips
//
//  Created by Josh Lehman on 1/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {
    
    // MARK: Properties

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var innerControlView: UIView!
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var splitControl: UISegmentedControl!
    @IBOutlet weak var splitBetweenLabel: UILabel!
    @IBOutlet weak var splitAmountLabel: UILabel!
    
    private let uiSlideOffset: CGFloat = 100
    private let uiSlideDuration: Double = 0.3
    private var uiActive: Bool = false
    
    var settings: Settings!
    private var originalSettings: Settings!
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettingsData()
        reloadTipControl()
        
        if settings.billAmount > 0 {
            billField.text = String(format: "%.2f", settings.billAmount)
            slideUIUp()
            updateTipAndTotal()
        } else {
            tipLabel.text = "$0.00"
            totalLabel.text = "$0.00"
            splitAmountLabel.text = "$0.00"
            controlView.alpha = 0
            billField.becomeFirstResponder()
        }
        
        

        
        splitBetweenLabel.text = "\(settings.splitBetween)"
        
        billField.keyboardAppearance = .Dark

    }
    
    override func viewWillDisappear(animated: Bool) {
        println("here")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingsModal" {
            let vc = segue.destinationViewController as SettingsViewController
            vc.settings = self.settings
            vc.delegate = self
        }
    }
            
    func settingsDidUpdate(controller: SettingsViewController, newSettings: Settings) {
        self.settings = newSettings
        
        reloadTipControl()
        updateTipAndTotal() // in the event that the default changed
        
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Actions

    @IBAction func billFieldChanged(sender: AnyObject) {
        let textLength = (billField.text as NSString).length
        if  textLength > 0 && !uiActive {
            slideUIUp()
        } else if textLength == 0{
            slideUIDown()
        }
        settings.billAmount = (billField.text as NSString).doubleValue
        updateTipAndTotal()
    }
    
    @IBAction func tipPercentChanged(sender: AnyObject) {
        updateTipAndTotal()
        view.endEditing(true)
    }
    
    @IBAction func splitBetweenChanged(sender: UISegmentedControl) {
        var splitBetweenValue = (splitBetweenLabel.text! as NSString).integerValue
        if sender.selectedSegmentIndex == 0 {
            splitBetweenValue = splitBetweenValue + 1
        } else if splitBetweenValue > 1 {
            splitBetweenValue = splitBetweenValue - 1
        }
        splitBetweenLabel.text = "\(splitBetweenValue)"
        self.settings.splitBetween = splitBetweenValue
        updateTipAndTotal()
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // MARK: Private/Internal
    
    //TODO: Better naming
    func slideUIUp() {
        uiActive = true
        UIView.animateWithDuration(uiSlideDuration, animations: {
            let newCenter = CGPoint(x: self.billField.center.x, y: self.billField.center.y - self.uiSlideOffset)
            self.billField.center = newCenter
        })
        
        UIView.animateWithDuration(uiSlideDuration, animations: {
            let newCenter = CGPoint(x: self.controlView.center.x, y: self.controlView.center.y - self.uiSlideOffset)
            self.controlView.center = newCenter
            self.controlView.frame.size.height += self.uiSlideOffset
            self.innerControlView.frame.size.height += self.uiSlideOffset
            self.controlView.alpha = 1
        })
    }
    
    func slideUIDown() {
        uiActive = false
        UIView.animateWithDuration(uiSlideDuration, animations: {
            let newCenter = CGPoint(x: self.billField.center.x, y: self.billField.center.y + self.uiSlideOffset)
            self.billField.center = newCenter
        })
        
        UIView.animateWithDuration(uiSlideDuration, animations: {
            let newCenter = CGPoint(x: self.controlView.center.x, y: self.controlView.center.y + self.uiSlideOffset)
            self.controlView.center = newCenter
            self.controlView.frame.size.height -= self.uiSlideOffset
            self.innerControlView.frame.size.height -= self.uiSlideOffset
            self.controlView.alpha = 0
        })
    }
    
    func updateTipAndTotal() {
        let tipPercent = settings.percentages[tipControl.selectedSegmentIndex]
        
        let billAmount = (billField.text as NSString).doubleValue
        let tip = billAmount * tipPercent.percentage
        let total = billAmount + tip
        let splitBetweenValue = (splitBetweenLabel.text! as NSString).doubleValue
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        splitAmountLabel.text = String(format: "$%.2f", total / splitBetweenValue)
        saveSettingsData()
    }
    
    func reloadTipControl() {
        // Update the segmented control to reflect any changes to settings.
        tipControl.removeAllSegments()
        for (index, tipPercent) in enumerate(settings.percentages) {
            tipControl.insertSegmentWithTitle(tipPercent.display(), atIndex: tipControl.numberOfSegments, animated: false)
            if tipPercent.checked {
                tipControl.selectedSegmentIndex = index
            }
        }

    }
    
    func loadSettingsData() {
        var defaults = NSUserDefaults.standardUserDefaults()
        let settings: AnyObject? = defaults.objectForKey("tipCalculatorSettings")
        
        var minutesSinceSave: Int?
        let lastSave: NSDate? = defaults.objectForKey("lastSave") as? NSDate
        
        if lastSave != nil {
            let secondsSinceSave = floor(lastSave!.timeIntervalSinceDate(NSDate())) * -1
            minutesSinceSave = Int(secondsSinceSave / 60)
        }
        

        if settings != nil {
            let encodedSettings = settings as NSData
            self.settings = NSKeyedUnarchiver.unarchiveObjectWithData(encodedSettings) as Settings
            if minutesSinceSave != nil {
                if minutesSinceSave! >= 10 {
                    self.settings.resetTemporalSettings()
                }
            }
        } else {
            self.settings = Settings(percentages: [TipPercent(0.18, checked: true), TipPercent(0.2), TipPercent(0.22)])
        }

    }
    
    func saveSettingsData() {
        let encodedSettingsObject: NSData = NSKeyedArchiver.archivedDataWithRootObject(self.settings)
        let userData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userData.setObject(encodedSettingsObject, forKey: "tipCalculatorSettings")
        userData.setObject(NSDate(), forKey: "lastSave")
    }
}

