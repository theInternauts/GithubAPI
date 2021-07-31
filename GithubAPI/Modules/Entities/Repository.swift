//
//  Repositories.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import UIKit

struct RepositoryResponse: Codable {
    var totalCount: Int?
    var incompleteResults: Bool?
    var items: [Repository]
}

struct RepositoryOwner: Codable {
    var login: String?
    var id: Int?
    var nodeId: String?
    var avatarUrl: String?
    var gravatarId: String?
    var url: String?
    var receivedEventsUrl: String?
    var type: String?
    var htmlUrl: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var subscriptionsUrl: String?
    var organizationsUrl: String?
    var reposUrl: String?
    var eventsUrl: String?
    var siteAdmin: Bool?
}

struct ResponseLicense: Codable {
    var key: String?
    var name: String?
    var url: String?
    var spdxId: String?
    var nodeId: String?
}

struct Repository: Codable {
    var id: Int?
    var nodeId: String?
    var name: String?
    var fullName: String?
    var owner: RepositoryOwner?
    var `private`: Bool?
    var htmlUrl: String?
    var description: String?
    var fork: Bool?
    var url: String?
    var createdAt: String?
    var updatedAt: String?
    var pushedAt: String?
    var homepage: String?
    var size: Int?
    var stargazersCount: Int?
    var watchersCount: Int?
    var language: String?
    var forksCount: Int?
    var openIssuesCount: Int?
    var masterBranch: String?
    var defaultBranch: String?
    var score: Int?
    var archiveUrl: String?
    var assigneesUrl: String?
    var blobsUrl: String?
    var branchesUrl: String?
    var collaboratorsUrl: String?
    var commentsUrl: String?
    var commitsUrl: String?
    var compareUrl: String?
    var contentsUrl: String?
    var contributorsUrl: String?
    var deploymentsUrl: String?
    var downloadsUrl: String?
    var eventsUrl: String?
    var forksUrl: String?
    var gitCommitsUrl: String?
    var gitRefsUrl: String?
    var gitTagsUrl: String?
    var gitUrl: String?
    var issueCommentUrl: String?
    var issueEventsUrl: String?
    var issuesUrl: String?
    var keysUrl: String?
    var labelsUrl: String?
    var languagesUrl: String?
    var mergesUrl: String?
    var milestonesUrl: String?
    var notificationsUrl: String?
    var pullsUrl: String?
    var releasesUrl: String?
    var sshUrl: String?
    var stargazersUrl: String?
    var statusesUrl: String?
    var subscribersUrl: String?
    var subscriptionUrl: String?
    var tagsUrl: String?
    var teamsUrl: String?
    var treesUrl: String?
    var cloneUrl: String?
    var mirrorUrl: String?
    var hooksUrl: String?
    var svnUrl: String?
    var forks: Int?
    var openIssues: Int?
    var watchers: Int?
    var hasIssues: Bool?
    var hasProjects: Bool?
    var hasPages: Bool?
    var hasWiki: Bool?
    var hasDownloads: Bool?
    var archived: Bool?
    var disabled: Bool?
    var license: ResponseLicense?
}
