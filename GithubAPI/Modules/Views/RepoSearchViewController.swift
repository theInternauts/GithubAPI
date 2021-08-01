//
//  RepoSearchVC.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchViewController: UIViewController {
    var presenter: RepoSearchViewToPresenterProtocol?
    var tableView: UITableView?
    var searchController: UISearchController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    override func loadView() {
        super.loadView()
        presenter?.updateView()
    }
    
    func buildViews() -> Void {
        configureView()
        configureTableViews()
        configureSearchController()
    }
    
    func configureView() -> Void {
        view.backgroundColor = .systemBackground
    }
    
    func configureTableViews() -> Void {
        // MARK: - TableView Config
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.prefetchDataSource = self
        tableView?.register(UIIndicatorTableViewCell.self, forCellReuseIdentifier: UIIndicatorTableViewCell.cellIdentifier)
        
        view.addSubview(tableView!)
        tableView?.pinToEdges(of: self.view, constrainToMargins: true)
        tableView?.backgroundColor = .systemBackground
    }
    
    func configureSearchController() -> Void {
        // MARK: - SearchController Config
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Repositories"
        
        // MARK: - NavigationController Config
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    deinit {
        NSObject.printUtil(["VIEW:RepoSearchViewController": "deinitialized"])
    }
}


// MARK: - RepoSearchPresenterToViewProtocol
extension RepoSearchViewController: RepoSearchPresenterToViewProtocol {
    func showData() -> Void {
        tableView?.reloadData()
    }
    
    func fetchReposSuccess(with newIndexPathsToReload: [IndexPath]?) -> Void {
        if let tableView = self.tableView {
            guard let newIndexPathsToReload = newIndexPathsToReload else {
                tableView.isHidden = false
                tableView.reloadData()
                return
            }
            // 2
            let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
}


// MARK: - UISearchBarDelegate
extension RepoSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else {
            return
        }
        presenter?.fetchRepos(with: searchBar.text!)
        searchBar.endEditing(true)
    }
}


// MARK: - UITableViewDataSourcePrefetching
// MARK: - Helpers for Table Prefetching
extension RepoSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            if let presenter = self.presenter {
                presenter.fetchNextPage(with: .none)
                NSObject.printUtil(["repo ct": "\(presenter.getRepoCount() ?? 0)"])
            }
        }
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView?.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= presenter?.getRepoCount() ?? 0
    }
}


// MARK: - UITableViewDelegate
extension RepoSearchViewController: UITableViewDelegate {}


// MARK: - UITableViewDataSource
extension RepoSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getTotalRepoSearchResultsCount() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIIndicatorTableViewCell.cellIdentifier, for: indexPath) as! UIIndicatorTableViewCell
        if isLoadingCell(for: indexPath) {
//            cell.textLabel?.text = ""
//            cell.configure(.none)
        } else {
            if let repo = presenter?.getRepo(at: indexPath.row) {
                cell.configure(repo)
//                cell.textLabel?.text = repo.fullName
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        presenter?.didSelectRow(at: indexPath.row)
    }
}


// MARK: - Debugging Utils
extension NSObject {
    // DEBUGGING UTILS
    static var debugUtilsEnabled = GithubAPIApp.debugUtilsEnabled
    
    static func printUtil(_ msgs: [String: Any]) {
        if debugUtilsEnabled {
            for (label,msg) in msgs {
                print("\(label): \(msg)")
            }
        }
    }
}


// MARK: - Layout Utilities
extension UIView {
    func pinToEdges(of superview: UIView, constrainToMargins: Bool = false) {
        /*
         Use cases cover edge-to-edge fullscreen (ignoring the notch/safeAreas) AND
         full page margin-to-margin on all four sides (may or may not respect safeAreas)
         based on margin constraints set in the containing view.
         
         NOTE TO SELF: CHECK WITH THE TECH LEAD about margin conventions before
         going wild with this in production
         */
        var rules: [NSLayoutConstraint]?
        translatesAutoresizingMaskIntoConstraints = false
        if constrainToMargins {
            rules = [
                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
                leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor),
                bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor)
            ]
        } else {
            rules = [
                topAnchor.constraint(equalTo: superview.topAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ]
        }
        NSLayoutConstraint.activate(rules!)
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
