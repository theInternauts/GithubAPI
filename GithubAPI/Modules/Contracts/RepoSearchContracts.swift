//
//  RepoSearchContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//


protocol RepoSearchViewToPresenterProtocol: AnyObject {
    var view: RepoSearchPresenterToViewProtocol? { get set }
    var router: RepoSearchPresenterToRouterProtocol? { get set }
    
    func updateView() -> Void
    func getRepoCount() -> Int?
    func getRepo(at index: Int) -> Repository?
    func didSelectRow(at index: Int) -> Void
    func fetchSearchResults(with: String) -> Void
}

protocol RepoSearchPresenterToViewProtocol: AnyObject {
    var presenter: RepoSearchViewToPresenterProtocol? { get set }
    
    func showData() -> Void
}

protocol RepoSearchPresenterToRouterProtocol: AnyObject {
    static func createModule() -> RepoSearchViewController
    func pushToRepoDetail(on view: RepoSearchPresenterToViewProtocol, with repo: Repository) -> Void
}

protocol RepoSearchPresenterToInteractorProtocol: AnyObject {
    var presenter: RepoSearchInteractorToPresenterProtocol? { get set }
    
    func getRepoCount() -> Int
    func getRepo(at index: Int) -> Repository
    func fetchRepos() -> Void
    func fetchSearchResults(with: String) -> Void
}

protocol RepoSearchInteractorToPresenterProtocol: AnyObject {
    var interactor: RepoSearchPresenterToInteractorProtocol? { get set }
    
    func fetchReposSuccess() -> Void
    func fetchSearchResultsSuccess() -> Void
}
