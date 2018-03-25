//
//  ViewController.swift
//  vodka-soda
//
//  Created by Tom Meagher on 3/24/18.
//  Copyright © 2018 Tom Meagher. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    private let horizontalPadding: CGFloat = 35
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let disclaimerLabel = UILabel()
    let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.titleLabel.text = "Vodka Soda"
        self.titleLabel.font = UIFont.systemFont(ofSize: 36.0, weight: .bold)
        self.titleLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        self.titleLabel.textAlignment = .left
        self.titleLabel.frame = CGRect(x: self.horizontalPadding,
                                       y: self.screenHeight / 2.75,
                                       width: self.screenWidth - (self.horizontalPadding * 2),
                                       height: 45)
        self.view.addSubview(titleLabel)
        
        self.descriptionLabel.text = "Casual without comprimise"
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        self.descriptionLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.frame = CGRect(x: self.horizontalPadding,
                                             y: self.screenHeight / 2.75 + 55,
                                             width: self.screenWidth - (self.horizontalPadding * 2),
                                             height: 45)
        self.view.addSubview(descriptionLabel)
        
        self.disclaimerLabel.text = "Vodka Soda does not post or share your information."
        self.disclaimerLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        self.disclaimerLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        self.disclaimerLabel.textAlignment = .center
        self.disclaimerLabel.frame = CGRect(x: self.horizontalPadding,
                                            y: self.screenHeight - 150,
                                            width: self.screenWidth - (self.horizontalPadding * 2),
                                            height: 20)
        self.view.addSubview(disclaimerLabel)
        
        self.loginButton.setTitle("Continue with Facebook", for: .normal)
        self.loginButton.setTitleColor(UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00), for: .normal)
        self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        self.loginButton.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.33, alpha:1.00)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: .touchUpInside)
        self.loginButton.frame = CGRect(x: 0,
                                        y: self.screenHeight - 120,
                                        width: self.screenWidth,
                                        height: 120)
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @objc func loginButtonPressed(sender: UIButton!) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .email, .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.fetchFacebookUserInfo()
            }
        }
    }
    
    func fetchFacebookUserInfo() {
        let parameters = ["fields": "id,first_name,age_range,gender,email"]
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: parameters)) { httpResponse, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }

}
