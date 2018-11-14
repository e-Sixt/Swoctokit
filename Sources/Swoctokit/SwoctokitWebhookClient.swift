//===----------------------------------------------------------------------===//
//
// This source file is part of the Swoctokit open source project
//
// Copyright (c) 2018 e-Sixt
// Licensed under MIT
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import Vapor

public protocol PullRequestEventListener: class {

    func pullRequestEventReceived(_ pullRequestEvent: PullRequestEvent)

}

public protocol CommitCommentEventListener: class {

    func commitCommentEventReceived(_ commitCommentEvent: CommitCommentEvent)

}

public protocol IssueCommentEventListener: AnyObject {

    func issueCommentEventReceived(_ event: IssueCommentEvent)

}

public class SwoctokitWebhookClient {

    private let application: Application

    private var pullRequestEventListeners = [PullRequestEventListener]()
    private var commitCommentEventListeners = [CommitCommentEventListener]()
    private var issueCommentEventListeners = [IssueCommentEventListener]()

    public init(_ application: Application) throws {
        self.application = application
        try setupRoutes()
    }

    private func setupRoutes() throws {
        let router = try application.make(Router.self)

        let webhookController = WebhookController()
        webhookController.delegate = self
        try webhookController.boot(router: router)
    }

    public func addPullRequestEventListener(_ listener: PullRequestEventListener) {
        pullRequestEventListeners.append(listener)
    }

    public func addCommitCommentEventListener(_ listener: CommitCommentEventListener) {
        commitCommentEventListeners.append(listener)
    }

    public func addIssueCommentEventListener(_ listener: IssueCommentEventListener) {
        issueCommentEventListeners.append(listener)
    }

}

extension SwoctokitWebhookClient: WebhookControllerDelegate {

    func didReceive(event: WebhookEvent) {
        switch event {
        case let event as PullRequestEvent:
            pullRequestEventReceived(event)
        case let event as CommitCommentEvent:
            commitCommentEventReceived(event)
        case let event as IssueCommentEvent:
            isuueCommentEventReceived(event)
        default:
            break
        }
    }

    func pullRequestEventReceived(_ event: PullRequestEvent) {
        pullRequestEventListeners.forEach { $0.pullRequestEventReceived(event) }
    }

    func commitCommentEventReceived(_ event: CommitCommentEvent) {
        commitCommentEventListeners.forEach { $0.commitCommentEventReceived(event) }
    }

    func isuueCommentEventReceived(_ event: IssueCommentEvent) {
        issueCommentEventListeners.forEach { $0.issueCommentEventReceived(event) }
    }

}
