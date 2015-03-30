//
//  Request.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation

public struct RequestDetails: Equatable {
    let method: String?
    let path: String?
    let query: String?

    public init(method: String?, path: String?, query: String?) {
        self.method = method
        self.path = path
        self.query = query
    }
}

public func ==(lhs: RequestDetails, rhs: RequestDetails) -> Bool {
    return lhs.method == rhs.method && lhs.path == rhs.path && lhs.query == rhs.query
}

public class Request {

    let requestDetails: RequestDetails

    public init(_ requestDetails: RequestDetails) {
        self.requestDetails = requestDetails
    }

    public func matchesRequest(request: NSURLRequest) -> Bool {
        let comparisonRequestDetails = RequestDetails(method: request.HTTPMethod, path: request.URL!.path, query: request.URL!.query)
        return comparisonRequestDetails == requestDetails
    }

    public var jsonDictionary: NSDictionary {
        get {
            var dictionary = [String: AnyObject]()
            dictionary["method"] = requestDetails.method
            dictionary["path"] = requestDetails.path
            dictionary["query"] = requestDetails.query
            return dictionary as NSDictionary
        }
    }
}