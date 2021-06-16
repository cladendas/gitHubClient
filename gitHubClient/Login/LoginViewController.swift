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
        
        if let tmpTokenUser = password.text {
            NetworkManager.tokenUser = tmpTokenUser
        }
    }
    
    private var gitHubLogo = "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"
    
    private lazy var url = URL(string: gitHubLogo)

    override func viewDidLoad() {
        super.viewDidLoad()

        image.kf.setImage(with: url)
    }
}
