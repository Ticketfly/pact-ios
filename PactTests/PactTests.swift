//
//  PactTests.swift
//  PactTests
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import UIKit
import XCTest
import Pact

class PactTests: XCTestCase {

    func testMockService() {
        let serviceConsumer = ServiceConsumer("Zoo App")

        let serviceProvider = serviceConsumer.hasPactWith("Animal Service Provider")

        let mockService = serviceProvider.mockService("Animal Service", port:9000)

        mockService
            .given("an alligator exists")
            .uponReceiving("a request for an alligator")
            .with(RequestDetails(
                method: "GET",
                path:"/alligator",
                query: nil
                ))
            .willRespondWith(ResponseDetails(
                status: 200,
                headers: ["Content-Type": "application/json"],
                body: ["name": "Betty"]
                ))

        mockService.run()

        let expectation = expectationWithDescription("Request Responds With Mocked Data")
        let url = NSURL(string: "http://localhost:9000/alligator")!

        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            println("Got response: \(response)")
            let urlResponse = response as! NSHTTPURLResponse
            XCTAssertNil(error, "Error message should be nil")
            XCTAssertEqual(urlResponse.statusCode, 200, "Status code should be 200")
            var parseError: NSError?
            if let body = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError) as? [String: NSObject] {
                XCTAssertNotNil(body["name"], "Body.name should not be nil")
                if let name = body["name"] as? String {
                    XCTAssertEqual(name, "Betty", "body.name should equal Betty")
                    expectation.fulfill()
                }
            }
            XCTAssertNil(parseError, "Got a parse error")
        }

        waitForExpectationsWithTimeout(30.0, handler: { (error) in
            var pactDirectoryPath = NSProcessInfo.processInfo().environment["PACT_DIRECTORY"] as? String
            println("Pact directory is \(pactDirectoryPath)")
            if pactDirectoryPath == nil {
                pactDirectoryPath = NSTemporaryDirectory()
            }
            serviceProvider.writeSpecFileInDirectory(pactDirectoryPath!)
        })
    }

}
