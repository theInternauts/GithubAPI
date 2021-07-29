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
        configureTableViews()
        configureSearchController()
    }
    
    func configureTableViews() -> Void {
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        view.addSubview(tableView!)
        tableView?.pinToEdges(of: self.view, constrainToMargins: true)
        tableView?.backgroundColor = .white        
    }
    
    func configureSearchController() -> Void {
        // MARK: - NavigationController Config
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Repositories"
        
        // MARK: - NavigationController Config
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    deinit {
        UIViewController.printUtil(["VIEW:RepoSearchViewController": "deinitialized"])
    }
}


// MARK: - RepoSearchPresenterToViewProtocol
extension RepoSearchViewController: RepoSearchPresenterToViewProtocol {
    func showData() -> Void {
        tableView?.reloadData()
    }
}


// MARK: - UISearchResultsUpdating
extension RepoSearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    if !(searchBar.text?.isEmpty ?? true) {
        presenter?.fetchSearchResults(with: searchBar.text!)
    }
  }
}


// MARK: - UISearchControllerDelegate
extension RepoSearchViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        UIViewController.printUtil(["EVENT": "UISearchControllerDelegate"])
        presenter?.updateView()
    }
}


// MARK: - UITableViewDelegate
extension RepoSearchViewController: UITableViewDelegate {}


// MARK: - UITableViewDataSource
extension RepoSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getRepoCount() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        if let repo = presenter?.getRepo(at: indexPath.row) {
            cell.textLabel?.text = repo.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        presenter?.didSelectRow(at: indexPath.row)
    }
}


// MARK: - Debugging Utils
extension UIViewController {
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
