//
//  LazyTableCell.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

class UIIndicatorTableViewCell: UITableViewCell {
    static let cellIdentifier: String       = "UIIndicatorCell"
    static let estimatedHeight = CGFloat(40)
    var spinner: UIActivityIndicatorView    = {
                                                let view    = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                                                view.style  = .large
                                                return view
                                            }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSpinner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSpinner()
    }
    
    deinit {
        NSObject.printUtil(["CELL:UIIndicatorTableViewCell": "deinitialized"])
    }
    
    func configure(_ data: Repository) -> Void {
        textLabel?.text                     = data.fullName
        contentView.backgroundColor         = .systemBackground
        spinner.stopAnimating()
    }
    
    func configureSpinner() {
        contentView.backgroundColor         = UIColor.systemGray
        contentView.addSubview(spinner)
        spinner.center                      = contentView.center
        spinner.color                       = .black
        spinner.hidesWhenStopped            = true
        spinner.startAnimating()
    }
}
