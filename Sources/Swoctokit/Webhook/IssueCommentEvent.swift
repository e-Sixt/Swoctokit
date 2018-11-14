//
//  IssueCommentEvent.swift
//  Swoctokit
//
//  Created by Franz Busch on 14.11.18.
//

import Foundation

public struct IssueCommentEvent: Decodable, WebhookEvent {

    public let action: String
    public let issue: Issue
    public let repository: Repository

}

public struct Issue: Decodable {

    public let number: Int

}

public struct IssueComment: Decodable {

    public let id: Int
    public let url: String
    public let body: String

}
