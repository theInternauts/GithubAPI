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
    
    func sanitizeAndFormatString(_ inputString: String) -> String {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let sanitizedOutput = inputString.trimmingCharacters(in: whitespaceCharacterSet)
        return sanitizedOutput.lowercased()
    }
    
    deinit {
        UIViewController.printUtil(["PRESENTER:RepoSearchPresenter": "deinitialized"])
    }
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
    
    func fetchSearchResults(with query: String) -> Void {
        interactor?.fetchSearchResults(with: sanitizeAndFormatString(query))
    }
    
}

extension RepoSearchPresenter: RepoSearchInteractorToPresenterProtocol {
    func fetchReposSuccess() -> Void {
        view?.showData()
    }
    
    func fetchSearchResultsSuccess() -> Void {
        view?.showData()
    }
}
