//
//  NewClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  Creates a new Client and returns it to the ClientViewController.

import UIKit

protocol createClientDelegate{
    func addClient(client:Client)
}

class NewClientViewController: UIViewController {
    
    var delegate:createClientDelegate! = nil
    var myClient = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageOutlet.image = UIImage(named: "curl.png")
         self.view.backgroundColor = UIColor(red: 185.0/255.0, green: 230.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func genderSelection(sender: UISegmentedControl) {
    
        if genderSegmentedControl.selectedSegmentIndex == 0 {
             imageOutlet.image = UIImage(named: "curl.png")
            self.view.backgroundColor = UIColor(red: 185.0/255.0, green: 230.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
             imageOutlet.image = UIImage(named: "woman.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func createClient(sender: UIButton) {
    
        if genderSegmentedControl.selectedSegmentIndex == 0{
        myClient.gender = "Male"
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
            myClient.gender = "Female"
        }
        myClient.firstName = firstNameOutlet.text!
        myClient.lastName = lastNameOutlet.text!
        myClient.age = ageOutlet.text!
       
        delegate.addClient(myClient)
        dismissViewControllerAnimated(true, completion: nil)
    }
}