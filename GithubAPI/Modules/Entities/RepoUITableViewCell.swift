//
//  RepoUITableViewCell.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class RepoUITableViewCell: UITableViewCell {
    static let estimatedHeight = CGFloat(40)
    static let cellIdentifier: String = "RepoCell"
    
    deinit {
        NSObject.printUtil(["CELL:RepoUITableViewCell": "deinitialized"])
    }
    
    func configure(_ data: Repository) -> Void {
        textLabel?.text                     = data.fullName
        contentView.backgroundColor         = .systemBackground
    }
}
