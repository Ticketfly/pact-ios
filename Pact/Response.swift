//
//  Response.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation
import OHHTTPStubs

public struct ResponseDetails {
    let status: Int32
    let headers: [String: AnyObject]
    let body: [String: AnyObject]

    public init(status: Int32, headers: [String: AnyObject], body: [String: AnyObject]) {
        self.status = status
        self.headers = headers
        self.body = body
    }
}

public class Response {

    let status: Int32
    let headers: [String: AnyObject]
    let body: [String: AnyObject]

    public var stubResponse: OHHTTPStubsResponse {
        get {
            return OHHTTPStubsResponse(JSONObject: body, statusCode: status, headers: headers)
        }
    }

    public init(_ responseDetails: ResponseDetails) {
        self.status = responseDetails.status
        self.headers = responseDetails.headers
        self.body = responseDetails.body
    }

    public var jsonDictionary: NSDictionary {
        get {
            var dictionary = [String: AnyObject]()
            dictionary["status"] = NSNumber(int: status)
            dictionary["headers"] = headers
            dictionary["body"] = body
            return dictionary as NSDictionary
        }
    }
}