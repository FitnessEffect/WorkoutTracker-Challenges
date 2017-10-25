//
//  ProgressChartViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/24/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Charts

class ProgressChartViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var dataInputBtn: UIButton!
    
    //var weightValues = [Int]()
    var dataValues = [String:String]()
    var lineChartEntry = [ChartDataEntry]()
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.frame = CGRect(x:(chartView.frame.width/2)-25, y:(chartView.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        chartView.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //let currentDate = DateConverter.stringToDate(dateStr: DateConverter.getCurrentDate())
        //DBService.shared.setCurrentWeekNumber(strWeek: String(DateConverter.weekNumFromDate(date: currentDate as NSDate)))
        //DBService.shared.setCurrentYearNumber(strYear: String(DateConverter.yearFromDate(date: currentDate as NSDate)))
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            dataValues = [:]
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            let btnTitle = dataInputBtn.titleLabel?.text
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveProgressData(selection:btnTitle!,completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    //self.exerciseArray.removeAll()
                    self.dataValues = DBService.shared.weightProgressData
                    self.dataValues.sorted(by: {a, b in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "y-M-d HH:mm:ss"
                        
                        
                        let dateA = dateFormatter.date(from: a.key)!
                        let dateB = dateFormatter.date(from: b.key)!
                        if dateA > dateB {
                            return true
                        }
                        return false
                    })
                    if self.dataValues.count == 0{
                        self.chartView.noDataText = "No Values"
                        self.chartView.noDataFont = UIFont(name: "DJBCHALKITUP", size: 23)
                    }else{
                        self.createChart(values: self.dataValues)
                    }
                    //self.refreshTableViewData()
//                    if self.exerciseArray.count == 0{
//                        self.noExercisesLabel.alpha = 1
//                    }else{
//                        self.noExercisesLabel.alpha = 0
//                    }
                })
            }
        }
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "notifAlphaToZero"), object: nil, userInfo: nil)
    }
    
    func createChart(values:[String:String]){
        lineChartEntry.removeAll()
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.axisMinimum = 0.0
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.leftAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 10)!
        chartView.rightAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 10)!

        let keys = dataValues.keys
        var count = 0
        for key in keys{
            print(dataValues[key]!)
            let lbsNum = dataValues[key]?.components(separatedBy: " ")
            let dataEntry = ChartDataEntry(x: Double(count), y: Double(lbsNum![0])!)
            lineChartEntry.append(dataEntry)
            count += 1
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Weight")
        line1.setColor(NSUIColor.blue)
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        data.setValueFont(NSUIFont(name: "DJBCHALKITUP", size: 10))
        data.setValueTextColor(NSUIColor.white)
        chartView.data = data
    }

    @IBAction func inputData(_ sender: UIButton) {
        let xPosition = dataInputBtn.frame.minX + (dataInputBtn.frame.width/2)
        let yPosition = dataInputBtn.frame.maxY - 25
        
        let currentController = self.getCurrentViewController()
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "progressPickerVC") as! ProgressPickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = currentController?.view
        popController.preferredContentSize = CGSize(width: 300, height: 210)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if dataInputBtn.titleLabel?.text == "Weight"{
            popController.setTag(tag: 1)
        }
        
        // present the popover
        currentController?.present(popController, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}