//
//  RepoDetailInteractor.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class RepoDetailInteractor {
    weak var presenter: RepoDetailInteractorToPresenterProtocol?
    private var repo: Repository?
    private let dataManager: ImageLoaderProtocol = ImageLoader.shared()
    
    
    init(with data: Repository) {
        self.repo = data
    }
    
    deinit {
        NSObject.printUtil(["INTERACTOR:RepoDetailInteractor": "deinitialized"])
    }
}


// MARK: - RepoDetailPresenterToInteractorProtocol
extension RepoDetailInteractor: RepoDetailPresenterToInteractorProtocol {
    func getRepo() -> Void {
        if let repo = repo {
            presenter?.getRepoSuccess(repo)
        }
    }
    
    func getOwner() -> Void {
        if let owner = repo?.owner {
            if let avatarUrl = owner.avatarUrl {
                dataManager.loadImage(url: avatarUrl) { [weak self] data in
                    self?.presenter?.getOwnerSuccess(owner, avatarImg: UIImage(data: data))
                }
            } else {
                presenter?.getOwnerSuccess(owner, avatarImg: .none)
            }
        }
    }
    
    func getNavigationTitle() -> Void {
        if let repo = repo {
            presenter?.getNavigationTitleSuccess(repo.name ?? "")
        }
    }
}
