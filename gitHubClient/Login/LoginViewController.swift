//
//  LoginViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit
import Kingfisher

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tokenNotValid: UILabel!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if let tmpTokenUser = password.text, password.text != "" {

            let uVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: UserViewController.self)) as UserViewController
            
            NetworkManager.tokenUser = tmpTokenUser
            NetworkManager.performSearchUser { (user, statusCode) in
                
                if statusCode == 200, let user = user {
                    uVC.tmpUserName = user.userName
                    uVC.tmpAvatarURL = user.avatarURL
                    
                    DispatchQueue.main.async {
                        self.tokenNotValid.isHidden = true
                        self.navigationController?.pushViewController(uVC, animated: true)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.tokenNotValid.text = "http status code: \(statusCode)"
                        self.tokenNotValid.isHidden = false
                    }
                }
                
            }
        }
    }
    
    private var gitHubLogo = "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"
    
    private lazy var url = URL(string: gitHubLogo)

    override func viewDidLoad() {
        super.viewDidLoad()

        image.kf.setImage(with: url)
        userName.isHidden = true
        tokenNotValid.isHidden = true
    }
}
