//
//  RepoSearchVC.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

class RepoSearchViewController: UIViewController {
    var presenter: RepoSearchViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RepoSearchViewController: RepoSearchPresenterToViewProtocol {
    
}


// MARK - Debugging Utils
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
