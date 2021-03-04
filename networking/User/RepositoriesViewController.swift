//
//  RepositoriesViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit
import Kingfisher

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var repositoriesFound: UILabel!
    @IBOutlet weak var tableRepositories: UITableView!
    
    var repositories: [Repository] = []
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.performSearchRepoRequest { (repositories) in
            self.repositories = repositories
            print("2222", self.repositories.count, repositories.count)
            
            DispatchQueue.main.async {
                self.tableRepositories.reloadData()
                self.repositoriesFound.text = "Repositories found: \(self.repositories.count)"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableRepositories.reloadData()
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoriesTableViewCell.self), for: indexPath) as! RepositoriesTableViewCell
        
        cell.buildCell(repository: repositories[indexPath.row])
        
        return cell
    }
    
    
}
