//
//  ImageLoaderContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func loadImage(url: String, then completion: @escaping (Data) -> Void) -> Void
}
