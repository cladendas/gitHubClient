//
//  UserViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repositoryName: UITextField!
    @IBOutlet weak var language: UITextField!
    
    var repositories: [Repository] = []
    
    @IBAction func ascendedSegmentControl(_ sender: UISegmentedControl) {
        NetworkManager.order = sender.selectedSegmentIndex
        NetworkManager.key = repositoryName.text ?? ""
        NetworkManager.language = language.text ?? ""
        
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
