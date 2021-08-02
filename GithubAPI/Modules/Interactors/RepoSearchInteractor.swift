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
    private let dataManager: GitHubAPIProtocol      = GitHubAPIService.shared()
    private var apiLimitRate: Double                = (60/500) // max unauthenticated rate is 60/5000; but lets do less. Safety first
    private var isFetchingData                      = false
    private var totalRepoSearchResultsCount: Int    = 0
    private let resultsPerPage: Int                 = 30
    private var lastRequestedPage: Int              = GitHubAPIService.searchRepositoriesAPIResultsStartingPageNumber-1
    
    
    func filterLocalData(with query: String ) -> [Repository] {
        return repos.filter({ (repo: Repository) -> Bool in
            return repo.fullName?.contains(query) ?? false
        })
    }
    
    private func calcPageNumber() -> Int {
        return (getRepoCount() /  resultsPerPage) + 1
    }
    
    private func hasNotReachedMaxResults() -> Bool {
        let repoCt = getRepoCount()
        return ((repoCt == 0 && totalRepoSearchResultsCount == 0) || (totalRepoSearchResultsCount > 0 && repoCt < totalRepoSearchResultsCount))
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
    
    func getRepo(at index: Int) -> Repository? {
        var repo: Repository?
        if index < getRepoCount() {
            repo = repos[index]
        }
        return repo
    }
    
    func isFetchingDataStatus() -> Bool {
        return isFetchingData
    }
    
    func getPageNumber() -> Int {
        calcPageNumber()
    }
    
    func resetLocalDataCaches() -> Void {
        lastRequestedPage = GitHubAPIService.searchRepositoriesAPIResultsStartingPageNumber-1
        totalRepoSearchResultsCount = 0
        repos.removeAll()
        presenter?.resetLocalDataCachesSuccess()
    }
    
    func fetchRepos(_ query: String, isNewSearch: Bool = false, onPage: Int) -> Void {
        guard onPage != lastRequestedPage, hasNotReachedMaxResults() else {
            return
        }
        lastRequestedPage = onPage
        isFetchingData = true
        let deadline = DispatchTime.now() + apiLimitRate
        DispatchQueue.global().ext_Throttle(deadline: deadline) { [weak self] in
            NSObject.printUtil(["BEFORE-Page": "\(onPage) | Count: \(self?.getRepoCount() ?? -1)"])
            self?.dataManager.request(.searchRepositories(matching: query,
                                                          onPage: onPage,
                                                          perPage: self?.resultsPerPage ?? 30,
                                                          sortedBy: .recency)) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.isFetchingData = false
                    NSObject.printUtil(["FAILED": "\(error)"])
                case .success(let data):
                    NSObject.printUtil(["SUCCESS!": ""])
                    self?.syncInteractorDataCaches(data, shouldReplaceLocalCache: isNewSearch)
                    DispatchQueue.main.async { [weak self] in
                        NSObject.printUtil(["AFTER-Page": "\(onPage) | Count: \(self?.getRepoCount() ?? -1)  |  Max: \(self?.totalRepoSearchResultsCount ?? -1)"])
                        self?.isFetchingData = false
                        self?.presenter?.fetchReposSuccess()
                    }
                }
            }
        }
    }
    
    func syncInteractorDataCaches(_ data: RepositoryResponse?, shouldReplaceLocalCache: Bool = false) -> Void {
        guard let data = data else {
            return
        }
        totalRepoSearchResultsCount = data.totalCount ?? 0
        if shouldReplaceLocalCache {
            repos.removeAll()
        }
        repos.append(contentsOf: data.items)
    }
}
