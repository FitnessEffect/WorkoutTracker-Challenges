//
//  CalendarViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/12/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController:UIViewController{
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthTitle: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var selectedMonth = 0
    var selectedYear = 0
    var dayBoxBtn:UIButton! = nil
    var buttonArray:[UIButton]!
    var passedStartingMonth = 0
    var passedStartingYear = 0
    var dateBtn = false
    var firstDayOfMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonArray = [UIButton]()
        calendarView.layer.cornerRadius = 10.0
        calendarView.clipsToBounds = true
        let currentMonth = DateConverter.getCurrentMonth()
        let currentYear = DateConverter.getCurrentYear()
        selectedYear = currentYear
        selectedMonth = currentMonth
        
        if passedStartingMonth != 0{
            selectedMonth = passedStartingMonth
            passedStartingMonth = 0
        }
        if passedStartingYear != 0{
            selectedYear = passedStartingYear
            passedStartingYear = 0
        }
        createButtonDays(month: selectedMonth)
        setToSelectedMonthAndYear()
    }
    
    func setToSelectedMonthAndYear(){
        yearLabel.text = String(selectedYear)
        if passedStartingMonth != 0{
            for index in 1...selectedMonth{
                if index != 1{
                    nextBtn()
                }
            }
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        nextBtn()
    }
    
    func nextBtn(){
        selectedMonth = selectedMonth + 1
        if selectedMonth == 13{
            selectedMonth = 1
            selectedYear = selectedYear + 1
        }
        yearLabel.text = String(selectedYear)
        createButtonDays(month: selectedMonth)
    }
    
    @IBAction func previousBtn(_ sender: UIButton) {
        selectedMonth = selectedMonth - 1
        if selectedMonth == 0{
            selectedMonth = 12
            selectedYear = selectedYear - 1
        }
        yearLabel.text = String(selectedYear)
        createButtonDays(month: selectedMonth)
    }
    
    @objc func pressedDay(sender: UIButton!) -> String{
        let btnNum = sender.tag
        var monthStr = ""
        var btnStr = ""
        
        if selectedMonth < 10 {
            monthStr = "0" + String(selectedMonth)
        }else{
            monthStr = String(selectedMonth)
        }
        
        if btnNum < 10 {
            btnStr = "0" + String(btnNum)
        }else{
            btnStr = String(btnNum)
        }
        
        let date = monthStr + "/" + btnStr + "/" + String(selectedYear)
        if dateBtn == true{
            if let presenter = self.presentingViewController?.childViewControllers.last as? InputExerciseViewController{
                presenter.setNewDate(dateStr: date)
                dateBtn = false
            }else if let presenter2 = self.presentingViewController?.childViewControllers.last as? ExercisesHistoryViewController{
                presenter2.setNewDate(dateStr: date)
                dateBtn = false
            }else if let presenter3 = self.presentingViewController?.childViewControllers.last as? SessionsViewController{
                presenter3.setNewDate(dateStr: date)
                dateBtn = false
            }
        }
        self.dismiss(animated: true, completion: nil)
        return date
    }
    
    func createButtonDays(month:Int){
        selectedMonth = month
        let monthStr = months[month-1]
        monthTitle.text = monthStr
        
        if dayBoxBtn != nil{
            for element in buttonArray{
                element.removeFromSuperview()
            }
            buttonArray.removeAll()
        }
        var xPosition = 0
        var yPosition = 47
        
        let numOfdays = DateConverter.getDaysInMonth(monthNum: month, year: selectedYear)
        firstDayOfMonth = DateConverter.findFirstDayOfMonth(monthNum: month, year: selectedYear)
        if firstDayOfMonth == 1{
            xPosition = 0
        }else if firstDayOfMonth == 2{
            xPosition = 1*43
        }else if firstDayOfMonth == 3{
            xPosition = 2*43
        }else if firstDayOfMonth == 4{
            xPosition = 3*43
        }else if firstDayOfMonth == 5{
            xPosition = 4*43
        }else if firstDayOfMonth == 6{
            xPosition = 5*43
        }else if firstDayOfMonth == 7{
            xPosition = 6*43
        }
        for index in 1...numOfdays{
            dayBoxBtn = UIButton()
            dayBoxBtn.frame = CGRect(x:xPosition, y:yPosition, width:42, height:37)
            buttonArray.append(dayBoxBtn)
            calendarView.addSubview(dayBoxBtn)
            dayBoxBtn.setTitle(String(index), for: .normal)
            
            if yPosition == 101 || yPosition == 187{
                dayBoxBtn.backgroundColor = UIColor.gray
            }else{
                dayBoxBtn.backgroundColor = UIColor.lightGray
            }
            
            dayBoxBtn.tag = index
            dayBoxBtn.addTarget(self, action: #selector(CalendarViewController.pressedDay(sender:)), for: .touchUpInside)
            xPosition = xPosition + 43
            
            if xPosition == 301{
                yPosition += 38
                xPosition = 0
            }
        }
    }
}
