//
//  SettingsViewController.swift
//  tips
//
//  Created by Josh Lehman on 1/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsDidUpdate(controller: SettingsViewController, newSettings: Settings)
}

class SettingsViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tipPercentagesTable: UITableView!
    @IBOutlet weak var addTipPercentageButton: UIButton!
    @IBOutlet weak var newTipPercentageField: UITextField!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    var delegate: SettingsViewControllerDelegate?
    var settings: Settings!
    
    // MARK: VC Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //addTipPercentageButton.enabled = false
        
        addTipPercentageButton.hidden = true        
        
        newTipPercentageField.keyboardAppearance = .Dark
        
        // The tap gesture recognizer to hide the keyboard blocks the selection signal to the tableView. Disable it on start...
        tapGestureRecognizer.enabled = false
        // and monitor appearance/disappearance of the keyboard for when to turn it on/off
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardDidShow:"),
            name: UIKeyboardDidShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardDidHide:"),
            name: UIKeyboardDidHideNotification,
            object: nil)
        
        self.navigationItem.hidesBackButton = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if settings.percentages.count == 1 {
                let alert = UIAlertView(title: "Oops!",
                    message: "At least one tip percentage is required.",
                    delegate: self,
                    cancelButtonTitle: "Ok")
                alert.show()
            } else {
                let toRemove = settings.percentages[indexPath.row]
                settings.percentages = settings.percentages.filter { $0.percentage != toRemove.percentage }
                if toRemove.checked {
                    settings.percentages[0].checked = true
                }
                tipPercentagesTable.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.percentages.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        updateCheckedTipPercentage(settings.percentages[indexPath.row])
        tipPercentagesTable.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        let tipPercent = settings.percentages[indexPath.row]
        cell.textLabel?.text = tipPercent.display()
        cell.textLabel?.textColor = UIColor(red: 0.843, green: 0.875, blue: 0.953, alpha: 1)
        
        let cellFont = UIFont(name: "HelveticaNeue-LightItalic", size: 20)
        
        cell.textLabel?.font = cellFont
        
        if tipPercent.checked {
            cell.accessoryType = .Checkmark
        }
        cell.selectionStyle = .None
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.047, green: 0.204, blue: 0.561, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 0.024, green: 0.141, blue: 0.416, alpha: 1)
        }
        

        return cell
    }
    
    // MARK: Actions
    
    func keyboardDidShow(notification: NSNotification) {
        tapGestureRecognizer.enabled = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        tapGestureRecognizer.enabled = false
    }
    
    @IBAction func newTipPercentageChanged(sender: AnyObject) {
        if asPercentage(newTipPercentageField.text) > 0 {
            addTipPercentageButton.hidden = false
        } else {
            addTipPercentageButton.hidden = true
        }
    }
    
    @IBAction func addNewTipPercentage(sender: AnyObject) {
        if settings.percentages.count == 4 {
            let alert = UIAlertView(title: "Oops!",
                    message: "Only four tip percentages are allowed. Swipe left to delete some.",
                    delegate: self,
                    cancelButtonTitle: "Ok")
            alert.show()
        } else {
            // Add the new percentage
            var newTipPercent = TipPercent(asPercentage(newTipPercentageField.text))
            addTipPercentage(newTipPercent)
            // Show the new tip percentage
            tipPercentagesTable.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            // Empty the textfield
            newTipPercentageField.text = ""
            // Hide the add button
            addTipPercentageButton.hidden = true
        }
        // Hide the keyboard
        view.endEditing(true)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // Having updateSettings return self.settings means that I save a line of code -- it reads better (to me) to do it this way versus updating self.settings in one step and then passing self.settings to settingsDidUpdate
    @IBAction func done(sender: AnyObject) {
        if delegate != nil {
            delegate?.settingsDidUpdate(self, newSettings: updatedSettings())
        }
    }
    
    // MARK: Private/internal
    
    private func asPercentage(text: NSString) -> Double {
        return text.doubleValue / 100
    }
    
    private func updatedSettings() -> Settings {
        return settings
    }
    
    private func addTipPercentage(tipPercent: TipPercent) {
        // ensure that the tip percent is unique
        let exists = settings.percentages.filter { $0.percentage == tipPercent.percentage }.count == 1
        
        if !exists {
            settings.percentages.append(tipPercent)
            updateCheckedTipPercentage(tipPercent)
        }
    }
    
    private func updateCheckedTipPercentage(tipPercent: TipPercent) {
        settings.percentages = settings.percentages
            .map {
                (tip: TipPercent) -> TipPercent in
                tip.checked = tip.percentage == tipPercent.percentage
                return tip
            }
            .sorted { $0.percentage < $1.percentage }
    }
    
}
