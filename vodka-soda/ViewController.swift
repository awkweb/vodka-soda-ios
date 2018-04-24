import Alamofire
import FacebookCore
import FacebookLogin
import Moya
import SwiftyJSON
import UIKit

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
        self.titleLabel.frame = CGRect(
            x: self.horizontalPadding,
            y: self.screenHeight / 2.75,
            width: self.screenWidth - (self.horizontalPadding * 2),
            height: 45
        )
        self.view.addSubview(titleLabel)
        
        self.descriptionLabel.text = "Casual without compromise"
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        self.descriptionLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.frame = CGRect(
            x: self.horizontalPadding,
            y: self.screenHeight / 2.75 + 55,
            width: self.screenWidth - (self.horizontalPadding * 2),
            height: 45
        )
        self.view.addSubview(descriptionLabel)
        
        self.disclaimerLabel.text = "Vodka Soda does not post or share your information."
        self.disclaimerLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        self.disclaimerLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        self.disclaimerLabel.textAlignment = .center
        self.disclaimerLabel.frame = CGRect(
            x: self.horizontalPadding,
            y: self.screenHeight - 150,
            width: self.screenWidth - (self.horizontalPadding * 2),
            height: 20
        )
        self.view.addSubview(disclaimerLabel)
        
        self.loginButton.setTitle("Continue with Facebook", for: .normal)
        self.loginButton.setTitleColor(UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00), for: .normal)
        self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        self.loginButton.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.70, alpha:1.00)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: .touchUpInside)
        self.loginButton.frame = CGRect(
            x: 0,
            y: self.screenHeight - 120,
            width: self.screenWidth,
            height: 120
        )
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
                print("Logged in!", grantedPermissions)
                let manager = Manager(
                    configuration: URLSessionConfiguration.default,
                    serverTrustPolicyManager: CustomServerTrustPoliceManager()
                )
                let source = TokenSource()
                let tokenClosure: () -> String? = { return source.token }
                let authPlugin = AuthPlugin(tokenClosure: tokenClosure)
                let provider = MoyaProvider<VodkaSodaAPI>(
                    manager: manager,
                    plugins: [authPlugin]
                )
                provider.request(.convertToken(token: accessToken.authenticationToken)) { convertTokenResult in
                    switch convertTokenResult {
                    case .failure(let convertTokenError):
                        print(convertTokenError)
                    case .success(let convertTokenResponse):
                        let convertTokenData = convertTokenResponse.data
                        do {
                            let convertTokenJson = try JSON(data: convertTokenData)
                            let accessToken = convertTokenJson["access_token"].stringValue
                            source.token = accessToken
                            provider.request(.me) { meResult in
                                switch meResult {
                                case .failure(let meResultError):
                                    print(meResultError)
                                case .success(let meResultResponse):
                                    let meResultResponseData = meResultResponse.data
                                    do {
                                        let meResultJson = try JSON(data: meResultResponseData)
                                        print(meResultJson)
                                    } catch {
                                        print("Unexpected error: \(error).")
                                    }
                                }
                            }
                        } catch {
                            print("Unexpected error: \(error).")
                        }
                    
                    }
                }
            }
        }
    }
    
}
