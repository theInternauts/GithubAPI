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
        tableView?.register(RepoUITableViewCell.self, forCellReuseIdentifier: RepoUITableViewCell.cellIdentifier)
        tableView?.estimatedRowHeight = RepoUITableViewCell.estimatedHeight
        tableView?.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView!)
        tableView?.pinToEdges(of: self.view, constrainToMargins: true)
        tableView?.backgroundColor = .systemBackground
    }
    
    func configureAndReturnTableFooter() -> UIView {
        let footerView = UIView()
        if let tableView = tableView {
            footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        }
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.color                           = .systemGray
        spinner.hidesWhenStopped                = true
        footerView.isUserInteractionEnabled     = false
        spinner.center = footerView.center
        spinner.startAnimating()
        
        return footerView
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
        tableView?.tableFooterView?.removeFromSuperview()
    }
}


// MARK: - UISearchBarDelegate
extension RepoSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.fetchRepos(with: searchBar.text)
        searchBar.endEditing(true)
    }
}


// MARK: - UITableViewDelegate
extension RepoSearchViewController: UITableViewDelegate {}


// MARK: - UITableViewDataSource
extension RepoSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repoCt = presenter?.getRepoCount() else {
            return 0
        }
        return (repoCt > 0) ? (repoCt + 1) : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoUITableViewCell.cellIdentifier, for: indexPath) as! RepoUITableViewCell
        if let repo = presenter?.getRepo(at: indexPath.row) {
            cell.configure(repo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        presenter?.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == presenter!.getRepoCount()) && !presenter!.isFetchingDataStatus() {
            tableView.tableFooterView = configureAndReturnTableFooter()
            presenter?.fetchNextPage()
        }
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
