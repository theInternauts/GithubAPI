//
//  RepoSearchRouter.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchRouter: RepoSearchPresenterToRouterProtocol {
    
    class func createModule() -> RepoSearchViewController {
        let view: RepoSearchPresenterToViewProtocol = RepoSearchViewController()
        let presenter: RepoSearchInteractorToPresenterProtocol & RepoSearchViewToPresenterProtocol = RepoSearchPresenter()
        let interactor: RepoSearchPresenterToInteractorProtocol = RepoSearchInteractor()
        let router: RepoSearchPresenterToRouterProtocol = RepoSearchRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view as! RepoSearchViewController
    }
    
    func pushToRepoDetail(on view: RepoSearchPresenterToViewProtocol, with repo: Repository) -> Void {
        print("tapped cell: \(repo.title).")
    }
    
    deinit {
        UIViewController.printUtil(["ROUTER:RepoSearchRouter": "deinitialized"])
    }
}
