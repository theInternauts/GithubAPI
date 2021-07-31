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
    private var searchQuery: String = ""
    
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
    
    private func updateRuntimeState() -> Void {
        guard !(interactor?.getFetchStatus() ?? true) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if self?.interactor?.getPageNumber() ?? 0 > 1 {
                let indexPathsToReload = self?.calculateIndexPathsToReload(from: self?.interactor?.getLastFetchResponseData())
                self?.view?.fetchReposSuccess(with: indexPathsToReload)
            } else {
                self?.view?.fetchReposSuccess(with: .none)
            }
        }
    }
    
    private func updateSearchState(with query: String?) -> Void {
        if let newQuery = query {
            searchQuery = newQuery
        }
    }
    
    private func resetRuntimeState() -> Void {
        searchQuery = ""
    }
    
    deinit {
        NSObject.printUtil(["PRESENTER:RepoSearchPresenter": "deinitialized"])
    }
}

extension RepoSearchPresenter: RepoSearchViewToPresenterProtocol {
    func updateView() -> Void {
//        fetchRepos(with: .none)
    }
    
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
            NSObject.printUtil(["RepoSearchPresenter:didSelectRow": "data for detail view not found - index: \(index)"])
            return
        }
        router?.pushToRepoDetail(on: view!, with: repo)
    }
    
    func fetchNextPage(with query: String?) -> Void {
        guard !searchQuery.isEmpty else {
            return
        }
        let pg = interactor?.getPageNumber() ?? 1
        interactor?.fetchRepos(sanitizeAndFormatString(searchQuery), isNewSearch: false, onPage: pg)
    }
    
    func fetchRepos(with query: String?) -> Void {
        resetRuntimeState()
        updateSearchState(with: query)
        guard !searchQuery.isEmpty else {
            return
        }
        let pg = interactor?.getPageNumber() ?? 1
        interactor?.fetchRepos(sanitizeAndFormatString(searchQuery), isNewSearch: true, onPage: pg)
    }
}

extension RepoSearchPresenter: RepoSearchInteractorToPresenterProtocol {
    func fetchReposSuccess() -> Void {
        updateRuntimeState()
        view?.showData()
    }
}
