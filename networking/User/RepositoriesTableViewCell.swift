//
//  RepositoriesTableViewCell.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit
import Kingfisher

class RepositoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var owner: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func buildCell(repository: Repository) {
        name.text = repository.name
        descriptionLabel.text = repository.description
        owner.text = repository.login
        
        let url = URL(string: repository.avatar_url)
        avatar.kf.setImage(with: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
