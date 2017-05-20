//
//  WorkoutInputViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/11/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class WorkoutInputViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var erase: UIButton!
    @IBOutlet weak var result: UITextField!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var challenge: UIButton!
    @IBOutlet weak var xForEmail: UIButton!
    @IBOutlet weak var client: UIBarButtonItem!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var challengeOverlay = true
    var menuShowing = false
    var dateSelected:String!
    var currentExercise = Exercise()
    var bodybuildingExercises = [String]()
    var crossfitExercises = [String]()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var nameArray = [String]()
    var buttonItemView:Any!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var clientPassed = Client()
    var tempKey:String!
    var exercisePassed:Exercise!
    var exerciseDictionary = [String:Any]()
    var edit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if clientPassed.firstName != "" {
            title = clientPassed.firstName
        }else{
            title = "Personal"
        }
        
        email.isHidden = true
        xForEmail.isHidden = true
        result.isHidden = true
        descriptionTextView.isHidden = true
        
        erase.isHidden = true
        time.isHidden = true
        weight.isHidden = true
        
       //  registerForKeyboardNotifications()

        let barButtonItem = self.navigationItem.rightBarButtonItem!
        buttonItemView = barButtonItem.value(forKey: "view")
        
//        let barButtonTitle = self.navigationItem.title!
//        titleView = barButtonTitle.value(forKey: "view")
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
//        erase.layer.cornerRadius = 5.0
//        erase.clipsToBounds = true
        erase.layer.borderWidth = 1
        erase.layer.borderColor = UIColor.black.cgColor
        
        exerciseLabel.layer.borderWidth = 1
        exerciseLabel.layer.borderColor = UIColor.black.cgColor
        
        challenge.layer.borderWidth = 1
        challenge.layer.borderColor = UIColor.black.cgColor
        
        save.layer.borderWidth = 1
        save.layer.borderColor = UIColor.black.cgColor
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
         NotificationCenter.default.addObserver(self, selector: #selector(WorkoutInputViewController.getExercise(_:)), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
        
        dateSelected = DateConverter.getCurrentDate()
        date.text = dateSelected
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -130, y: 0, width: 126, height: 500)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                self.nameArray = value?.allKeys as! [String]
            }
          self.nameArray.insert("Personal", at: 0)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getExercise(_ notification: Notification){
        let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
        let myExercise = info["exerciseKey"]
        currentExercise.name = (myExercise?.name)!
        currentExercise.exerciseDescription = (myExercise?.exerciseDescription)!
        descriptionTextView.text = myExercise?.exerciseDescription
        
        //format response
        let desStr:String = myExercise!.exerciseDescription
        let stringParts = desStr.components(separatedBy: "|")
        
      //  descriptionTextView.textColor = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
        var newString:String = ""
        newString.append("\n")
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        descriptionTextView.text = (myExercise?.name)! + newString
        
            descriptionTextView.isHidden = false
            erase.isHidden = false
            exerciseLabel.isHidden = true
            result.isHidden = false
    }
    
    func setClient(client:Client){
        clientPassed = client
    }
    
    func setExercise(exercise:Exercise){
        exercisePassed = exercise
    }
    
    @IBAction func result(_ sender: UITextField) {
        time.isHidden = false
        weight.isHidden = false
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        addSelector()
    }
    
    func addSelector() {
        //slide view in here
        if menuShowing == false{
            menuView.addFx()
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: 0, y: 0, width: 126, height: 500)
                self.view.isHidden = false
                self.overlayView.alpha = 1
            })
            menuShowing = true
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -130, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
        }
        menuView.profileBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.clientBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.historyBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.challengeBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.settingsBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
    }
    
    func btnAction(_ sender: UIButton) {
        if sender.tag == 1{
            
        }else if sender.tag == 2{
            let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! UINavigationController
            self.present(clientVC, animated: true, completion: nil)
        }else if sender.tag == 3{
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyNavID") as! UINavigationController
            self.present(historyVC, animated: true, completion: nil)
        }
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        
        if menuShowing == true{
            //remove menu view
            
            UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame = CGRect(x: -130, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
            
        }else{
            if email.isFirstResponder {
                email.resignFirstResponder()
            }else{
                if date.frame.contains(sender.location(in: view)){
                    changeDate(date)
                }
                if exerciseLabel.frame.contains(sender.location(in: view)){
                    selectExercise()
                }
                
                if result.isHidden == false{
                    if result.frame.contains(sender.location(in: view)){
                        result.isHidden = true
                        time.isHidden = false
                        weight.isHidden = false
                        return
                    }
                }
                
                if time.frame.contains(sender.location(in: view)){
                    selectPicker(tag: time.tag)
                }
                if weight.frame.contains(sender.location(in: view)){
                    selectPicker(tag: weight.tag)
                }
                
                if challengeOverlay == false{
                    if email.frame.contains(sender.location(in: view)){
                        email.becomeFirstResponder()
                    }
                }
                if challenge.frame.contains(sender.location(in: view)){
                    challengeBtn()
                    challengeOverlay = false
                }

            }
        }
    }
    
    @IBAction func eraseBtn(_ sender: UIButton) {
        if sender.tag == 0{
        descriptionTextView.text = ""
        descriptionTextView.isHidden = true
        exerciseLabel.isHidden = false
        erase.isHidden = true
        result.isHidden = true
        challengeOverlay = true
            time.text = ""
            time.isHidden = true
            weight.text = ""
            weight.isHidden = true
        }else if sender.tag == 1{
            email.text = ""
            email.isHidden = true
            challenge.isHidden = false
            xForEmail.isHidden = true
        }
    }
    
    @IBAction func client(_ sender: UIBarButtonItem) {
        selectPicker(tag: sender.tag)
    }
    
    @IBAction func time(_ sender: UITextField) {
        selectPicker(tag: sender.tag)
    }
    
    @IBAction func weight(_ sender: UITextField) {
        selectPicker(tag: sender.tag)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        
        if self.title == "Personal"{
        currentExercise.date = date.text!
        currentExercise.creator = user.email!
        currentExercise.result = weight.text!
        
        //move currentExercise to exerciseDictionary for firebase
        exerciseDictionary["name"] = currentExercise.name 
        exerciseDictionary["description"] = currentExercise.exerciseDescription
        exerciseDictionary["date"] = currentExercise.date
        exerciseDictionary["result"] = currentExercise.result
        exerciseDictionary["exerciseKey"] = currentExercise.exerciseKey
        let exerciseKey = self.ref.child("users").child(user.uid).child("Exercises").childByAutoId().key
    self.ref.child("users").child(user.uid).child("Exercises").child(exerciseKey).setValue(exerciseDictionary)
        }else{
           currentExercise.date = date.text!
           currentExercise.creator = user.email!
           currentExercise.result = weight.text!
            exerciseDictionary["name"] = currentExercise.name
            exerciseDictionary["description"] = currentExercise.exerciseDescription
            exerciseDictionary["date"] = currentExercise.date
            exerciseDictionary["result"] = currentExercise.result
            exerciseDictionary["exerciseKey"] = currentExercise.exerciseKey
            
            retrieveClientID(clientObj: clientPassed)
        
            //need to get exercise key
            //self.ref.child("users").child(self.user.uid).child("Clients").child(self.tempKey).child("Exercises").child(self.exercisePassed.exerciseKey).updateChildValues(self.exerciseDictionary)
        }
    }
    

    
    func retrieveClientID(clientObj:Client){

        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let clientsVal = snapshot.value as? [String: [String: AnyObject]] {
                for client in clientsVal {
                    if client.value["lastName"] as! String == clientObj.lastName && client.value["age"] as! String == clientObj.age{
                        self.tempKey = client.key
                        if self.edit == false{
                            let exerciseKey = self.ref.child("users").child(self.user.uid).child("Exercises").childByAutoId().key
                          self.ref.child("users").child(self.user.uid).child("Clients").child(self.tempKey).child("Exercises").child(exerciseKey).setValue(self.exerciseDictionary)
                        }else if self.edit == true{
                            self.ref.child("users").child(self.user.uid).child("Clients").child(self.tempKey).child("Exercises").child(self.exercisePassed.exerciseKey).updateChildValues(self.exerciseDictionary)
                        }
                        
                        return
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func selectPicker(tag: Int){
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        if tag == 1{
            xPosition = (buttonItemView as AnyObject).frame.minX + ((buttonItemView as AnyObject).frame.width/2)
            yPosition = (buttonItemView as AnyObject).frame.maxY

        }else if tag == 2{
            xPosition = time.frame.minX + (time.frame.width/2)
            yPosition = time.frame.maxY
        }else if tag == 3{
            xPosition = weight.frame.minX + (weight.frame.width/2)
            yPosition = weight.frame.maxY
        }
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        popController.setTag(tag: tag)
        if tag == 1{
         popController.setClients(clients: nameArray)
        }
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func selectExercise() {
        let xPosition = exerciseLabel.frame.minX + (exerciseLabel.frame.width/2)
        let yPosition = exerciseLabel.frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exerciseNavID") as! UINavigationController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func changeDate(_ sender: UITextField) {
        let xPosition = date.frame.minX + (date.frame.width/2)
        let yPosition = date.frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as! CalendarViewController
        
        popController.dateBtn = true
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 316)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func challengeBtn(){
        email.isHidden = false
        challenge.isHidden = true
        xForEmail.isHidden = false
    }
    
    func setNewDate(dateStr:String){
        dateSelected = dateStr
        date.text = dateSelected
    }
    
    func savePickerName(name:String){
        self.title = name
    }
    
    func saveTime(time:String){
        self.time.text = time
    }
    
    func saveWeight(weight:String){
        self.weight.text = weight
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func launchEmail(sendTo address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setMessageBody("<a href='workout-tracker://challenges/accept'>Clickme</a>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("no go")
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        //launchEmail(sendTo: email.text!)
        //use email 
        //query the db to all the emails
        //find correct one and get user id key
        //send using the key to the correct spot in db
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        let info: NSDictionary  = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.setContentOffset(CGPoint(x:0, y:(keyboardSize.height)), animated: true)
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           print(error)
        controller.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

