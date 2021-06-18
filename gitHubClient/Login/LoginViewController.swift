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
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if let tmpTokenUser = password.text, password.text != "" {
            NetworkManager.tokenUser = tmpTokenUser

            let uVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: UserViewController.self)) as UserViewController
            
            NetworkManager.performSearchUser { (user) in
                uVC.tmpUserName = user.userName
                uVC.tmpAvatarURL = user.avatarURL
            }
            
            self.navigationController?.pushViewController(uVC, animated: true)
        }
    }
    
    private var gitHubLogo = "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"
    
    private lazy var url = URL(string: gitHubLogo)

    override func viewDidLoad() {
        super.viewDidLoad()

        image.kf.setImage(with: url)
        
    }
}
