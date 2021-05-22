//
//  RepositoriesViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit
import Kingfisher

final class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var repositoriesFound: UILabel!
    @IBOutlet weak var tableRepositories: UITableView!
    
    ///Наименование репозитория
    var repositoryName = ""
    ///Язык
    var language = ""
    ///Сортировка
    var order = 0
    
    private var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.key = repositoryName
        NetworkManager.language = language
        NetworkManager.order = order

        NetworkManager.performSearchRepoRequest { [weak self] (repositories) in
            self?.repositories = repositories
            
            DispatchQueue.main.async {
                self?.tableRepositories.reloadData()
                self?.repositoriesFound.text = "Repositories found: \(self?.repositories.count ?? 0)"
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let wkWebVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: WKWebViewViewController.self)) as WKWebViewViewController
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoriesTableViewCell.self), for: indexPath) as! RepositoriesTableViewCell
        
        wkWebVC.htmlUrl = cell.htmlUrl
        navigationController?.pushViewController(wkWebVC, animated: true)
    }
}
