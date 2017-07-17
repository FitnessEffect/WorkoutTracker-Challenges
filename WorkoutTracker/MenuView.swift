//
//  MenuView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol MenuViewDelegate {
    func handleSelection(type: String)
}

class MenuView: UIView {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var delegate: MenuViewDelegate?
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MenuView
    }
    
    func addFx() {
        
        profileBtn.layer.cornerRadius = 5.0
        profileBtn.clipsToBounds = true
        profileBtn.layer.borderWidth = 1
        profileBtn.layer.borderColor = UIColor.black.cgColor
        
        profileBtn.layer.shadowColor = UIColor.black.cgColor
        profileBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        profileBtn.layer.shadowOpacity = 0.6
        profileBtn.layer.shadowRadius = 5
        
        clientBtn.layer.cornerRadius = 5.0
        clientBtn.clipsToBounds = true
        clientBtn.layer.borderWidth = 1
        clientBtn.layer.borderColor = UIColor.black.cgColor
        
        clientBtn.layer.shadowColor = UIColor.black.cgColor
        clientBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        clientBtn.layer.shadowOpacity = 0.6
        clientBtn.layer.shadowRadius = 5
        
        historyBtn.layer.cornerRadius = 5.0
        historyBtn.clipsToBounds = true
        historyBtn.layer.borderWidth = 1
        historyBtn.layer.borderColor = UIColor.black.cgColor
        
        historyBtn.layer.shadowColor = UIColor.black.cgColor
        historyBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        historyBtn.layer.shadowOpacity = 0.6
        historyBtn.layer.shadowRadius = 5
        
        challengeBtn.layer.cornerRadius = 5.0
        challengeBtn.clipsToBounds = true
        challengeBtn.layer.borderWidth = 1
        challengeBtn.layer.borderColor = UIColor.black.cgColor
        
        challengeBtn.layer.shadowColor = UIColor.black.cgColor
        challengeBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        challengeBtn.layer.shadowOpacity = 0.6
        challengeBtn.layer.shadowRadius = 5
        
        logoutBtn.layer.cornerRadius = 5.0
        logoutBtn.clipsToBounds = true
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.borderColor = UIColor.black.cgColor
        
        logoutBtn.layer.shadowColor = UIColor.black.cgColor
        logoutBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        logoutBtn.layer.shadowOpacity = 0.6
        logoutBtn.layer.shadowRadius = 5
        
        notificationLabel.layer.cornerRadius = 10.0
        notificationLabel.clipsToBounds = true
        notificationLabel.layer.borderWidth = 1
        notificationLabel.layer.borderColor = UIColor.red.cgColor
        
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationLabel.alpha = 0
        }else{
            notificationLabel.alpha = 1
            notificationLabel.text = String(num)
        }
    }
    
    func dismissMenu() {
        self.removeFromSuperview()
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
    
    @IBAction func btnAction(_ sender: UIButton) {
        if sender.tag == 1{
            let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputNavID") as! UINavigationController
            let currentController = self.getCurrentViewController()
            currentController?.present(inputVC, animated: false, completion: nil)
            
        }else if sender.tag == 2{
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyNavID") as! UINavigationController
            let currentController = self.getCurrentViewController()
            currentController?.present(historyVC, animated: false, completion: nil)
            
        }else if sender.tag == 3{
            let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! UINavigationController
            let currentController = self.getCurrentViewController()
            currentController?.present(clientVC, animated: false, completion: nil)
            
        }else if sender.tag == 4{
            let challengesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengesNavID") as! UINavigationController
            let currentController = self.getCurrentViewController()
            currentController?.present(challengesVC, animated: false, completion: nil)

        }else if sender.tag == 5{
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            
            let currentController = self.getCurrentViewController()
//            do{
//                try FIRAuth.auth()?.signOut()
//                
//            }catch{
//                
//            }
            
            currentController?.present(loginVC, animated: false, completion: nil)
        }
    }
}
