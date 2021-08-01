//
//  RepoDetailRouter.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class RepoDetailRouter: RepoDetailPresenterToRouterProtocol {
    deinit {
        NSObject.printUtil(["ROUTER:RepoDetailRouter": "deinitialized"])
    }
    
    class func createModule(with repo: Repository) -> RepoDetailViewController {
        let view: RepoDetailPresenterToViewProtocol = RepoDetailViewController()
        let presenter: RepoDetailInteractorToPresenterProtocol & RepoDetailViewToPresenterProtocol = RepoDetailPresenter()
        let interactor: RepoDetailPresenterToInteractorProtocol = RepoDetailInteractor(with: repo)
        let router: RepoDetailPresenterToRouterProtocol = RepoDetailRouter()
        
        view.presenter              = presenter
        presenter.view              = view
        presenter.interactor        = interactor
        presenter.router            = router
        interactor.presenter        = presenter
        
        return view as! RepoDetailViewController
    }
}

