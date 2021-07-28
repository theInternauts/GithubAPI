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
}

protocol RepoSearchPresenterToViewProtocol: AnyObject {
    var presenter: RepoSearchViewToPresenterProtocol? { get set }
    
    func showData() -> Void
}

protocol RepoSearchPresenterToRouterProtocol: AnyObject {
    static func createModule() -> RepoSearchViewController
    func pushToRepoDetail(on view: RepoSearchPresenterToViewProtocol, with repo: Repository)
}

protocol RepoSearchPresenterToInteractorProtocol: AnyObject {
    var presenter: RepoSearchInteractorToPresenterProtocol? { get set }
    
    func getRepoCount() -> Int
    func getRepo(at index: Int) -> Repository
    func fetchRepos() -> Void
}

protocol RepoSearchInteractorToPresenterProtocol: AnyObject {
    var interactor: RepoSearchPresenterToInteractorProtocol? { get set }
    
    func fetchReposSuccess() -> Void
}
