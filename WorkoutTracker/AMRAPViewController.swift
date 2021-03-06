//
//  AMRAPViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/15/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class AmrapViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var emomMinutesLabel: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exercises = [Exercise]()
    var categoryPassed:String!
    var minutes = [String]()
    var seconds = [String]()
    var emomTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryPassed
        for x in 0...59{
            minutes.append(String(x))
            seconds.append(String(x))
        }
        
        secondsLabel.alpha = 0
        minutesLabel.alpha = 0
        emomMinutesLabel.alpha = 0
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SupersetViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        self.navigationItem.setHidesBackButton(true, animated:true)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        for i in 1...100{
            emomTime.append(String(i))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercises = DBService.shared.supersetExercises
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if categoryPassed == "Emom"{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryPassed == "Emom"{
            return emomTime.count
        }else{
            if component == 0{
                return seconds.count
            }else{
                return minutes.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryPassed == "Emom"{
            return emomTime[row]
        }else{
            if component == 0{
                return seconds[row]
            }else{
                return minutes[row]
            }
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        if exercises.count == 0{
            let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if categoryPassed == "Amrap"{
                let myExercise = Exercise()
                let idMin:Int = pickerOutlet.selectedRow(inComponent: 0)
                let idSec:Int = pickerOutlet.selectedRow(inComponent: 1)
                
                myExercise.name = "Amrap"
                myExercise.category = "Amrap"
                myExercise.type = "Crossfit"
                
                myExercise.exerciseDescription = minutes[idMin] + " min(s) " + seconds[idSec] + " sec(s)"
                myExercise.exerciseDescription = Formatter.formatResult(str: myExercise.exerciseDescription)
                
                for exercise in exercises{
                    myExercise.exerciseDescription = exercise.exerciseDescription + " | " + myExercise.exerciseDescription
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                self.navigationItem.setHidesBackButton(true, animated:true)
                DBService.shared.clearSupersetExercises()
                self.dismiss(animated: true, completion: nil)
                
            }else{
                let myExercise = Exercise()
                let idMin:Int = pickerOutlet.selectedRow(inComponent: 0)
                myExercise.name = "Emom"
                myExercise.category = "Emom"
                myExercise.type = "Crossfit"
                for exercise in exercises{
                    if myExercise.exerciseDescription == ""{
                        myExercise.exerciseDescription = exercise.exerciseDescription
                    }else{
                        myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + exercise.exerciseDescription
                    }
                }
                myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + emomTime[idMin] + " min(s)"
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                DBService.shared.setEmomTime(time: emomTime[idMin])
                DBService.shared.clearSupersetExercises()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "supersetCell")! as! SupersetCustomCell
        cell.descriptionTextField.text = self.exercises[indexPath.row].exerciseDescription
        cell.numLabel.text = String(indexPath.row + 1)
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this exercise?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                self.exercises.remove(at: x)
                DBService.shared.setSupersetExercises(exercises: self.exercises)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        secondsLabel.alpha = 0
        minutesLabel.alpha = 0
        emomMinutesLabel.alpha = 0
        
        if categoryPassed == "Emom"{
            emomMinutesLabel.alpha = 1
            let label = UILabel()
            label.text = emomTime[row]
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
            return label
        }else{
            secondsLabel.alpha = 1
            minutesLabel.alpha = 1
            let label = UILabel()
            if component == 0{
                label.text = seconds[row]
            }else if component == 1{
                label.text = minutes[row]
            }
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
            return label
        }
    }
}
