//
//  RepoSearchInteractor.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchInteractor {
    var presenter: RepoSearchInteractorToPresenterProtocol?
    var repos: [Repository] = [
        Repository(title: "word 0"),
        Repository(title: "word 1"),
        Repository(title: "word 2"),
        Repository(title: "word 3"),
        Repository(title: "word 4")
    ]
}

extension RepoSearchInteractor: RepoSearchPresenterToInteractorProtocol {
    func getRepoCount() -> Int {
        return repos.count
    }
    
    func getRepo(at index: Int) -> Repository {
        return repos[index]
    }
    
    func fetchRepos() -> Void {
        presenter?.fetchReposSuccess()
    }
}
