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
    weak var interactor: RepoSearchPresenterToInteractorProtocol?
}

extension RepoSearchPresenter: RepoSearchViewToPresenterProtocol {
    
}

extension RepoSearchPresenter: RepoSearchInteractorToPresenterProtocol {
    
}
