//
//  RepoSearchPresenter.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchPresenter {
    weak var view: RepoSearchPresenterToViewProtocol?
    var router: RepoSearchPresenterToRouterProtocol?
    var interactor: RepoSearchPresenterToInteractorProtocol?
    private var mostRecentQueryText: String = ""
    
    private func sanitizeAndFormatString(_ inputString: String) -> String {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let sanitizedOutput = inputString.trimmingCharacters(in: whitespaceCharacterSet)
        return sanitizedOutput.lowercased()
    }
    
    private func calculateIndexPathsToReload(from newRepos: [Repository]?) -> [IndexPath] {
        guard let newRepos = newRepos else {
            return []
        }
        
        var startIndex = interactor?.getRepoCount() ?? 0 - newRepos.count
        if startIndex < 0 {
            startIndex = 0
        }
        let endIndex = startIndex + newRepos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func updateQueryState(with query: String?) -> Void {
        if let newQuery = query {
            let cleanQuery = sanitizeAndFormatString(newQuery)
            if mostRecentQueryText != cleanQuery {
                interactor?.resetLocalDataCaches()
                mostRecentQueryText = newQuery
            }
        } else {
            resetRuntimeState()
        }
    }
    
    private func resetRuntimeState() -> Void {
        mostRecentQueryText = ""
    }
    
    deinit {
        NSObject.printUtil(["PRESENTER:RepoSearchPresenter": "deinitialized"])
    }
}

extension RepoSearchPresenter: RepoSearchViewToPresenterProtocol {
    func updateView() -> Void {}
    
    func getRepoCount() -> Int? {
        return interactor?.getRepoCount()
    }
    
    func getTotalRepoSearchResultsCount() -> Int? {
        return interactor?.getTotalRepoSearchResultsCount()
    }
    
    func getRepo(at index: Int) -> Repository? {
        return interactor?.getRepo(at: index)
    }
    
    func didSelectRow(at index: Int) -> Void {
        guard let repo = getRepo(at: index) else {
            return
        }
        router?.pushToRepoDetail(on: view!, with: repo)
    }
    
    func isFetchingDataStatus() -> Bool {
        return interactor!.isFetchingDataStatus()
    }
    
    func fetchNextPage() -> Void {
        guard !mostRecentQueryText.isEmpty, !interactor!.isFetchingDataStatus() else {
            return
        }
        let pg = interactor?.getPageNumber() ?? GitHubAPIService.searchRepositoriesAPIResultsStartingPageNumber
        interactor?.fetchRepos(mostRecentQueryText, isNewSearch: false, onPage: pg)
    }
    
    func fetchRepos(with query: String?) -> Void {
        resetRuntimeState()
        updateQueryState(with: query)
        guard !mostRecentQueryText.isEmpty else {
            return
        }
        let pg = interactor?.getPageNumber() ?? GitHubAPIService.searchRepositoriesAPIResultsStartingPageNumber
        interactor?.fetchRepos(mostRecentQueryText, isNewSearch: true, onPage: pg)
    }
}

extension RepoSearchPresenter: RepoSearchInteractorToPresenterProtocol {
    func fetchReposSuccess() -> Void {
        view?.showData()
    }
    
    func resetLocalDataCachesSuccess() -> Void {
        view?.showData()
    }
}
