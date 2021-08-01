//
//  RepoSearchContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import Foundation

protocol RepoSearchViewToPresenterProtocol: AnyObject {
    var view: RepoSearchPresenterToViewProtocol? { get set }
    var router: RepoSearchPresenterToRouterProtocol? { get set }
    
    func updateView() -> Void
    func getRepoCount() -> Int?
    func getTotalRepoSearchResultsCount() -> Int?
    func getRepo(at index: Int) -> Repository?
    func didSelectRow(at index: Int) -> Void
    func fetchNextPage() -> Void
    func fetchRepos(with: String?) -> Void
}

protocol RepoSearchPresenterToViewProtocol: AnyObject {
    var presenter: RepoSearchViewToPresenterProtocol? { get set }
    
    func showData() -> Void
    func fetchReposSuccess(with newIndexPathsToReload: [IndexPath]?) -> Void
}

protocol RepoSearchPresenterToRouterProtocol: AnyObject {
    static func createModule() -> RepoSearchViewController
    func pushToRepoDetail(on view: RepoSearchPresenterToViewProtocol, with repo: Repository) -> Void
}

protocol RepoSearchPresenterToInteractorProtocol: AnyObject {
    var presenter: RepoSearchInteractorToPresenterProtocol? { get set }
    
    func getRepoCount() -> Int
    func getTotalRepoSearchResultsCount() -> Int
    func getRepo(at index: Int) -> Repository
    func isFetchingDataStatus() -> Bool
    func getLastFetchResponseData() -> [Repository]
    func getPageNumber() -> Int
    func resetLocalDataCaches() -> Void
    func fetchRepos(_ with: String, isNewSearch: Bool, onPage: Int) -> Void
}

protocol RepoSearchInteractorToPresenterProtocol: AnyObject {
    var interactor: RepoSearchPresenterToInteractorProtocol? { get set }
    
    func fetchReposSuccess() -> Void
    func resetLocalDataCachesSuccess() -> Void
}
