//
//  RepoSearchInteractor.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchInteractor {
    var presenter: RepoSearchInteractorToPresenterProtocol?
    var repos: [Repository] = []
    
    init() {
        self.resetLocalData()
    }
    
    func filterLocalData(with query: String ) -> [Repository] {
        return repos.filter({ (repo: Repository) -> Bool in
            return repo.title.contains(query)
        })
    }
}

extension RepoSearchInteractor: RepoSearchPresenterToInteractorProtocol {
    func getRepoCount() -> Int {
        return repos.count
    }
    
    func getRepo(at index: Int) -> Repository {
        return repos[index]
    }
    
    func fetchRepos() -> Void {
        // call API Module
        resetLocalData()
        presenter?.fetchReposSuccess()
    }
    
    func fetchSearchResults(with query: String) -> Void {
        // call API Module with params
        resetLocalData()
        repos = filterLocalData(with: query)
        presenter?.fetchSearchResultsSuccess()
    }
    
    func resetLocalData() -> Void {
        print("resetting")
        repos = [
            Repository(title: "word 0"),
            Repository(title: "word 1"),
            Repository(title: "word 2"),
            Repository(title: "word 3"),
            Repository(title: "word 4")
        ]
        
    }
}
