//
//  Interaction.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation
import OHHTTPStubs

public class Interaction {
    let providerState: String
    var description: String?
    var request: Request?
    var response: Response?
    var stubs = [OHHTTPStubsDescriptor]()

    public init(providerState: String) {
        self.providerState = providerState
    }

    public func uponReceiving(description: String) -> Interaction {
        self.description = description
        return self
    }

    public func with(requestDetails: RequestDetails) -> Interaction {
        request = Request(requestDetails)
        return self
    }

    public func willRespondWith(responseDetails: ResponseDetails) -> Interaction {
        response = Response(responseDetails)
        return self
    }

    public func run() {
        let stub = OHHTTPStubs.stubRequestsPassingTest({ (urlRequest: NSURLRequest!) -> Bool in
            if let request = self.request {
                return request.matchesRequest(urlRequest)
            }
            return false
            },
            withStubResponse: { (request: NSURLRequest!) -> OHHTTPStubsResponse! in
                return self.response!.stubResponse
        })
        stubs.append(stub)
    }

    public func stop() {
        for stub in stubs {
            OHHTTPStubs.removeStub(stub)
        }
    }

    public var jsonDictionary: NSDictionary {
        get {
            var jsonDictionary = [
                "given": providerState,
                "description": description,
                "request": request?.jsonDictionary,
                "response": response?.jsonDictionary
            ] as [NSObject: AnyObject!]
            return jsonDictionary as NSDictionary
        }
    }
}