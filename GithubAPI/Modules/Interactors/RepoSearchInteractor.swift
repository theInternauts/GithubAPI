//
//  RepoSearchInteractor.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchInteractor {
    weak var presenter: RepoSearchInteractorToPresenterProtocol?
    private var repos: [Repository]                 = []
    private var lastFetch: [Repository]             = []
    private var dataManager: GitHubAPIProtocol      = GitHubAPIService.shared()
    private var apiLimitRate: Double                = 1.5
    private var isFetchingData                      = false
    private var totalRepoSearchResultsCount: Int    = 0
    private let resultsPerPage: Int                 = 30
    
    
    func filterLocalData(with query: String ) -> [Repository] {
        return repos.filter({ (repo: Repository) -> Bool in
            return repo.fullName?.contains(query) ?? false
        })
    }
    
    private func calcPageNumber() -> Int {
        return (getRepoCount() /  resultsPerPage) + 1
    }
    
    deinit {
        NSObject.printUtil(["INTERACTOR:RepoSearchInteractor": "deinitialized"])
    }
}

extension RepoSearchInteractor: RepoSearchPresenterToInteractorProtocol {
    func getRepoCount() -> Int {
        return repos.count
    }
    
    func getTotalRepoSearchResultsCount() -> Int {
        return totalRepoSearchResultsCount
    }
    
    func getRepo(at index: Int) -> Repository {
        return repos[index]
    }
    
    func getFetchStatus() -> Bool {
        return isFetchingData
    }
    
    func getLastFetchResponseData() -> [Repository] {
        return lastFetch
    }
    
    func getPageNumber() -> Int {
        calcPageNumber()
    }
    
    func fetchRepos(_ query: String, isNewSearch: Bool = false, onPage: Int) -> Void {
        isFetchingData = true
        let deadline = DispatchTime.now() + apiLimitRate
        DispatchQueue.global().ext_Throttle(deadline: deadline) { [weak self] in
            NSObject.printUtil(["Page": "\(onPage)"])
            self?.dataManager.request(.searchRepositories(matching: query,
                                                          onPage: onPage,
                                                          perPage: self?.resultsPerPage ?? 30,
                                                          sortedBy: .recency)) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.isFetchingData = false
                    print("FAILED \(error)")
                case .success(let data):
                    print("SUCCESS!")
                    self?.resetInteractorDataCaches(data, shouldReplaceLocalCache: isNewSearch)
                    DispatchQueue.main.async { [weak self] in
                        self?.isFetchingData = false
                        self?.presenter?.fetchReposSuccess()
                    }
                }
            }
        }
    }
    
    func resetInteractorDataCaches(_ data: RepositoryResponse?,shouldReplaceLocalCache: Bool = false) -> Void {
        guard let data = data else {
            return
        }
        totalRepoSearchResultsCount = data.totalCount ?? 0
        lastFetch = data.items
        if shouldReplaceLocalCache {
            repos.removeAll()
        }
        repos.append(contentsOf: lastFetch)
    }
}
