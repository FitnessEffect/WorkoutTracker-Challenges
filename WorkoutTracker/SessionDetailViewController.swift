//
//  CreateSessionViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/29/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var paidBtn: UIButton!
    @IBOutlet weak var durationBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var exercises = [Exercise]()
    var session:Session!
    var calculatedDateStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SessionDetailViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setup session info
       session = DBService.shared.passedSession
        title = session.day
        sessionName.text = session.sessionName
        durationBtn.setTitle(String(session.duration), for: .normal)
        if session.paid == false{
           setPaidBtnToFalse()
        }else{
            setPaidBtnToTrue()
        }
        
        //setup exercises in session
        DBService.shared.retrieveExerciseListFromSessionKey(keyStr: session.key, completion: {
            self.exercises = DBService.shared.exercisesForClient
            self.tableView.reloadData()
        })
        
        calculatedDateStr = calculateDate()
    }
    
    //find day number from day name and return entire date
    func calculateDate()->String{
        var count = 0
        if title == "Sunday"{
            count = 1
        }else if title == "Monday"{
            count = 2
        }else if title == "Tuesday"{
            count = 3
        }else if title == "Wednesday"{
            count = 4
        }else if title == "Thursday"{
            count = 5
        }else if title == "Friday"{
            count = 6
        }else if title == "Saturday"{
            count = 7
        }
        
        let range = DBService.shared.dateRange
        
        let dates = range.components(separatedBy: " - ")
        let tempArrFirstDate = dates[0].components(separatedBy: "/")
        let tempArrLastDate = dates[1].components(separatedBy: "/")
        
        let firstMonth = tempArrFirstDate[0]
        let firstDay = Int(tempArrFirstDate[1])!
        let firstYear = tempArrFirstDate[2]
        
        
        let lastMonth = tempArrLastDate[0]
        let lastDay = Int(tempArrLastDate[1])!
        let lastYear = tempArrLastDate[2]
        
         let daysInMonth = DateConverter.getDaysInMonth(monthNum: Int(firstMonth)!, year: Int(firstYear)!)
        
        for _ in 0...100{
            if count == 1{
                return String(firstDay)
            }else if count == 2{
                var temp = 0
                temp = firstDay + 1
                if temp == daysInMonth{
                    return String(lastMonth) + "/01/" + String(lastYear)
                }else{
                    if String(temp).characters.count != 2{
                        let strTemp = "0" + String(temp)
                        
                        return String(firstMonth) + "/" + String(strTemp) + "/" + String(firstYear)
                    }else{
                        return String(firstMonth) + "/" + String(temp) + "/" + String(firstYear)
                    }
                }
            }else if count == 3{
                var temp = 0
                temp = firstDay + 2
                
                if temp == daysInMonth{
                    return String(lastMonth) + "/01/" + String(lastYear)
                }else{
                    if String(temp).characters.count != 2{
                        let strTemp = "0" + String(temp)
                        
                        return String(firstMonth) + "/" + String(strTemp) + "/" + String(firstYear)
                    }else{
                        return String(firstMonth) + "/" + String(temp) + "/" + String(firstYear)
                    }
                }
            }else if count == 4{
                var temp = 0
                temp = firstDay + 3
                if temp == daysInMonth{
                    return String(lastMonth) + "/01/" + String(lastYear)
                }else{
                    if String(temp).characters.count != 2{
                        let strTemp = "0" + String(temp)
                        
                        return String(firstMonth) + "/" + String(strTemp) + "/" + String(firstYear)
                    }else{
                        return String(firstMonth) + "/" + String(temp) + "/" + String(firstYear)
                    }
                }
            }else if count == 5{
                var temp = 0
                temp = firstDay + 4
                if temp == daysInMonth{
                   return String(lastMonth) + "/01/" + String(lastYear)
                }else{
                    if String(temp).characters.count != 2{
                        let strTemp = "0" + String(temp)
                        
                        return String(firstMonth) + "/" + String(strTemp) + "/" + String(firstYear)
                    }else{
                        return String(firstMonth) + "/" + String(temp) + "/" + String(firstYear)
                    }
                }
            }else if count == 6{
                var temp = 0
                temp = firstDay + 5
                if temp == daysInMonth{
                    return String(lastMonth) + "/01/" + String(lastYear)
                }else{
                    if String(temp).characters.count != 2{
                        let strTemp = "0" + String(temp)
                        
                        return String(firstMonth) + "/" + String(strTemp) + "/" + String(firstYear)
                    }else{
                        return String(firstMonth) + "/" + String(temp) + "/" + String(firstYear)
                    }
                }
            }else if count == 7{
                return String(lastDay)
                
            }
        }
       return ""
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputVC") as! InputExerciseViewController
        DBService.shared.setCurrentDay(day: title!)
        DBService.shared.setPassedDate(dateStr: calculatedDateStr)
        
        self.navigationController?.pushViewController(popController, animated: true)
    }

    func setPaidBtnToTrue(){
        paidBtn.setTitle("Paid", for: .normal)
        paidBtn.setTitleColor(UIColor(red: 0.0/255.0, green: 131.0/255.0, blue: 0.0/255.0, alpha: 1.0), for: .normal)
    }
    
    func setPaidBtnToFalse(){
        paidBtn.setTitle("No Payment", for: .normal)
        paidBtn.setTitleColor(UIColor.red, for: .normal)
    }
    
    @IBAction func paidBtn(_ sender: UIButton) {
        if paidBtn.titleLabel?.text == "No Payment"{
            DBService.shared.updatePaidForSession(boolean: true, completion: {self.setPaidBtnToTrue()
            })
        }else{
             DBService.shared.updatePaidForSession(boolean: false, completion: {self.setPaidBtnToFalse()})
        }
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCustomCell
        if exercises.count != 0{
        let exercise = exercises[(indexPath as NSIndexPath).row]
        cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
        cell.numberOutlet.text = String(indexPath.row + 1)
        cell.setExerciseKey(key: exercise.exerciseKey)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this client?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let ex = self.exercises[indexPath.row]
                DBService.shared.deleteExerciseForClient(exercise: ex, completion: {
                tableView.reloadData()
                })
                self.exercises.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                DBService.shared.passedClient.firstName = "Personal"
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
}