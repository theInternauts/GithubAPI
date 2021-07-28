//
//  RepoSearchContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//


protocol RepoSearchViewToPresenterProtocol: AnyObject {
    var view: RepoSearchPresenterToViewProtocol? { get set }
    var router: RepoSearchPresenterToRouterProtocol? { get set }
}

protocol RepoSearchPresenterToViewProtocol: AnyObject {
    var presenter: RepoSearchViewToPresenterProtocol? { get set }
}

protocol RepoSearchPresenterToRouterProtocol: AnyObject {
    static func createModule() -> RepoSearchViewController
}

protocol RepoSearchPresenterToInteractorProtocol: AnyObject {
    var presenter: RepoSearchInteractorToPresenterProtocol? { get set }
}

protocol RepoSearchInteractorToPresenterProtocol: AnyObject {
    var interactor: RepoSearchPresenterToInteractorProtocol? { get set }
}
