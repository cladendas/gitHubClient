//
//  RepositoriesTableViewCell.swift
//  networking
//
//  Created by cladendas on 04.03.2021.
//

import UIKit

final class RepositoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    func buildCell(repository: Repository) {
        
        name.text = repository.name
        descriptionLabel.text = repository.description
        owner.text = repository.login
        avatar.kf.setImage(with: URL(string: repository.avatar_url))
    }
}
