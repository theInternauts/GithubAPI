//
//  RepoSearchPresenter.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchPresenter {
    var view: RepoSearchPresenterToViewProtocol?
    var router: RepoSearchPresenterToRouterProtocol?
    var interactor: RepoSearchPresenterToInteractorProtocol?
}

extension RepoSearchPresenter: RepoSearchViewToPresenterProtocol {
    func updateView() -> Void {
        interactor?.fetchRepos()
    }
    
    func getRepoCount() -> Int? {
        return interactor?.getRepoCount()
    }
    
    func getRepo(at index: Int) -> Repository? {
        return interactor?.getRepo(at: index)
    }
    
    func didSelectRow(at index: Int) -> Void {
        guard let repo = getRepo(at: index) else {
            UIViewController.printUtil(["RepoSearchPresenter:didSelectRow": "data for detail view not found - index: \(index)"])
            return
        }
        router?.pushToRepoDetail(on: view!, with: repo)
    }
    
}

extension RepoSearchPresenter: RepoSearchInteractorToPresenterProtocol {
    func fetchReposSuccess() -> Void {
        view?.showData()
    }
}
