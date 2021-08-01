//
//  RepoDetailPresenter.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class RepoDetailPresenter {
    weak var view: RepoDetailPresenterToViewProtocol?
    var interactor: RepoDetailPresenterToInteractorProtocol?
    var router: RepoDetailPresenterToRouterProtocol?
    
    deinit {
        NSObject.printUtil(["PRESENTER:RepoDetailPresenter": "deinitialized"])
    }
}


// MARK: - RepoDetailPresenterToViewProtocol
extension RepoDetailPresenter: RepoDetailViewToPresenterProtocol {
    func updateView() {
        interactor?.getRepo()
        interactor?.getOwner()
        interactor?.getNavigationTitle()
    }
}


// MARK: - RepoDetailInteractorToPresenterProtocol
extension RepoDetailPresenter: RepoDetailInteractorToPresenterProtocol {
    func getRepoSuccess(_ repo: Repository) -> Void {
        view?.updateRepoPanel(repo)
    }
    
    func getOwnerSuccess(_ owner: RepositoryOwner, avatarImg: UIImage?) -> Void {
        view?.updateOwnerPanel(owner, avatarImg: avatarImg)
    }
    
    func getNavigationTitleSuccess(_ title: String) -> Void {
        view?.updateNavigationTitle(title)
    }
}
