//
//  GithubAPIContracts.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

protocol GitHubAPIProtocol: AnyObject {
    func request(_ endpoint: Endpoint, then completion: @escaping (Result<RepositoryResponse, Error>) -> Void)
}
