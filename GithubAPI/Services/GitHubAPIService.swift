//
//  GitHubAPIService.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//

import Foundation

class GitHubAPIService {
    // MARK: - Properties/Configuration
    private static var privateManagerForConfiguration: GitHubAPIService = { return GitHubAPIService() }()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Accessors
    class func shared() -> GitHubAPIService {
        return privateManagerForConfiguration
    }
}


// MARK: - GitHubAPIService: GitHubAPIProtocol
extension GitHubAPIService: GitHubAPIProtocol {
    func request(_ endpoint: Endpoint,
                 then completion: @escaping (Result<RepositoryResponse, Error>) -> Void) {
        guard let url = endpoint.url else {
            return completion(.failure(APIErrors.invalidRequestUrl))
        }
        NSObject.printUtil(["FETCHING: --->": "\(url.absoluteString)"])
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(APIErrors.fetchError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let repositoryResponse = try decoder.decode(RepositoryResponse.self, from: jsonData)
                completion(.success(repositoryResponse))
            } catch {
                print("-decode-fail--\(error)----")
                completion(.failure(APIErrors.unprocessableData))
            }
        }
        task.resume()
    }
}


// MARK: - Endpoint
struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

enum Sorting: String {
    case numberOfStars = "stars"
    case recency = "updated"
    case helpIssues = "help-wanted-issues"
    case numberOfForks = "forks"
    case bestMatch = ""
}

extension Endpoint {
    static func searchRepositories(matching query: String,
                                   onPage: Int,
                                   perPage: Int,
                                   sortedBy sorting: Sorting = .recency) -> Endpoint {
        return Endpoint(
            path: "/search/repositories",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: String(onPage)),
                URLQueryItem(name: "sort", value: sorting.rawValue),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
