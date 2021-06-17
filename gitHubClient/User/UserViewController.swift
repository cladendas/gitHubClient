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
    
    @IBAction func ascendedSegmentControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.performSearchUser { [weak self] (user) in
            DispatchQueue.main.async {
                self?.userName.text = user.userName
                self?.avatar.kf.setImage(with: URL(string: user.avatarURL))
            }
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
