//
//  RepoDetailViewController.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class RepoDetailViewController: UIViewController {
    var presenter: RepoDetailViewToPresenterProtocol?
    private var repoPanel: UIStackView?     = { return UIStackView() }()
    private var ownerPanel: UIStackView?    = { return UIStackView() }()
    private var ownerAvatar: UIImageView?   = { return UIImageView() }()
    private var ownerName:UILabel?          = { return UILabel() }()
    private var repoForkCt: UILabel?        = { return UILabel() }()
    private var repoStarCt: UILabel?        = { return UILabel() }()
    private var repoWatchCt: UILabel?       = { return UILabel() }()
    
    deinit {
        NSObject.printUtil(["VIEW:RepoDetailViewController": "deinitialized"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updateView()
    }
    
    func buildViews() -> Void {
        configureView()
        configureOwnerPanel()
        configureRepoPanel()
    }
    
    // MARK: - configure General View Aesthetics
    private func configureView() -> Void {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - configure OwnerPanel
    private func configureOwnerPanel() -> Void {
        ownerPanel?.alignment = .leading
        ownerPanel?.axis = .vertical
        ownerPanel?.distribution = .equalCentering
        ownerAvatar?.contentMode = .scaleAspectFit
        ownerPanel?.addArrangedSubview(ownerAvatar!)
        ownerPanel?.addArrangedSubview(ownerName!)
        view.addSubview(ownerPanel!)
        
        // Auto Layout
        if let panel = ownerPanel, let reference = view {
            panel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                panel.widthAnchor.constraint(equalToConstant: 250),
                panel.heightAnchor.constraint(equalToConstant: 275),
                panel.topAnchor.constraint(equalTo: reference.safeAreaLayoutGuide.topAnchor, constant: 50),
                panel.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
            ])
        }
    }
    
    private func configureRepoPanel() -> Void {
        repoPanel?.alignment        = .leading
        repoPanel?.axis             = .vertical
        repoPanel?.distribution     = .equalCentering
        repoPanel?.addArrangedSubview(repoForkCt!)
        repoPanel?.addArrangedSubview(repoStarCt!)
        repoPanel?.addArrangedSubview(repoWatchCt!)
        view.addSubview(repoPanel!)
        
        // Auto Layout
        if let panel = repoPanel, let reference = view {
            panel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                panel.widthAnchor.constraint(equalToConstant: 250),
                panel.heightAnchor.constraint(equalToConstant: 150),
                panel.bottomAnchor.constraint(equalTo: reference.safeAreaLayoutGuide.bottomAnchor, constant: -100),
                panel.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
            ])
        }
    }
}


// MARK: - RepoDetailPresenterToViewProtocol
extension RepoDetailViewController: RepoDetailPresenterToViewProtocol {
    func updateOwnerPanel(_ owner: RepositoryOwner, avatarImg: UIImage?) -> Void {
        ownerName?.text         = owner.login
        ownerAvatar?.image      = avatarImg
    }
    
    func updateRepoPanel(_ repo: Repository) -> Void {
        repoForkCt?.text        = "FORKS: \(repo.forksCount ?? 0)"
        repoStarCt?.text        = "STARS: \(repo.forksCount ?? 0)"
        repoWatchCt?.text       = "WATCHERS: \(repo.watchersCount ?? 0)"
    }
    
    func updateNavigationTitle(_ title: String) -> Void {
        navigationItem.title    = title
    }
}
