//
//  RepoSearchVC.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchViewController: UIViewController {
    var presenter: RepoSearchViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RepoSearchViewController: RepoSearchPresenterToViewProtocol {
    
}
