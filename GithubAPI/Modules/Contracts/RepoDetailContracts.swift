//
//  RepoDetailContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

protocol RepoDetailViewToPresenterProtocol: AnyObject {
    var view: RepoDetailPresenterToViewProtocol? { get set }
    var router: RepoDetailPresenterToRouterProtocol? { get set }
    
    func updateView() -> Void
}

protocol RepoDetailPresenterToViewProtocol: AnyObject {
    var presenter: RepoDetailViewToPresenterProtocol? { get set }
    
    func updateOwnerPanel(_ owner: RepositoryOwner, avatarImg: UIImage?) -> Void
    func updateRepoPanel(_ repo: Repository) -> Void
    func updateNavigationTitle(_ title: String) -> Void
}

protocol RepoDetailPresenterToRouterProtocol: AnyObject {
    static func createModule(with: Repository) -> RepoDetailViewController
}

protocol RepoDetailPresenterToInteractorProtocol: AnyObject {
    var presenter: RepoDetailInteractorToPresenterProtocol? { get set }
    
    func getRepo() -> Void
    func getOwner() -> Void
    func getNavigationTitle() -> Void
}

protocol RepoDetailInteractorToPresenterProtocol: AnyObject {
    var interactor: RepoDetailPresenterToInteractorProtocol? { get set }
    
    func getRepoSuccess(_ repo: Repository) -> Void
    func getOwnerSuccess(_ owner: RepositoryOwner, avatarImg: UIImage?) -> Void
    func getNavigationTitleSuccess(_ title: String) -> Void
}
