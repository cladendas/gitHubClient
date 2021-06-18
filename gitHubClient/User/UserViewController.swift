//
//  UserViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit

final class UserViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repositoryName: UITextField!
    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var order: UISegmentedControl!
    
    var tmpUserName = ""
    var tmpAvatarURL = ""
    
    @IBAction func ascendedSegmentControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.userName.text = self.tmpUserName
            self.avatar.kf.setImage(with: URL(string: self.tmpAvatarURL))
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //При переходе передаём наименование репозитория, язык и сортировку
        if let vc = segue.destination as? RepositoriesViewController {
            vc.repositoryName = repositoryName.text ?? ""
            vc.language = language.text ?? ""
            vc.order = order.selectedSegmentIndex
        }
    }
}
