//
//  RepositoriesViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var repositoriesFound: UILabel!
    @IBOutlet weak var tableRepositories: UITableView!
    
    var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoriesTableViewCell.self), for: indexPath) as! RepositoriesTableViewCell
        
        cell.buildCell(repository: repositories[indexPath.row])
        
        return cell
    }
    
    
}
