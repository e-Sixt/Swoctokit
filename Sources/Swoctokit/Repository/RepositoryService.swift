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

public class RepositoryService {

    private let token: String
    private let client: Client

    init(token: String, client: Client) {
        self.token = token
        self.client = client
    }

    public func createRepository(organization: String, name: String, description: String, isPrivate: Bool) -> Future<Response> {
        let request = RepositoryCreateRequest(name: name, description: description, private: isPrivate)
        return client.post("\(Constants.GitHubBaseURL)/orgs/\(organization)/repos", headers: HTTPHeaders([("Authorization", "token \(token)")])) { postRequest in
            try postRequest.content.encode(json: request)
        }.flatMap { response in
            if let error = try? response.content.syncDecode(GitHubAPIErrorResponse.self) {
                throw error
            }

            return response.eventLoop.future(response)
        }

    }

}
