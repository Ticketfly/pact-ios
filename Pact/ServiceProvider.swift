//
//  ServiceProvider.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation

public class ServiceProvider {
    let name: String
    let serviceConsumer: ServiceConsumer
    var service: MockService?

    public init(_ name: String, serviceConsumer: ServiceConsumer) {
        self.name = name
        self.serviceConsumer = serviceConsumer
    }

    public func mockService(name: String, port: UInt) -> MockService {
        let mockService = MockService(name: name, port: port)
        service = mockService
        return mockService
    }

    public var jsonDictionary: NSDictionary {
        get {
            return ["name": name] as NSDictionary
        }
    }

    public var specJsonDictionary: NSDictionary {
        get {
            if let service = service as MockService! {
                return [
                    "provider": jsonDictionary,
                    "consumer": serviceConsumer.jsonDictionary,
                    "interactions": service.interactions.map({ (interaction) -> NSDictionary in
                        interaction.jsonDictionary
                    })
                    ] as NSDictionary
            }
            return NSDictionary()
        }
    }

    public var specFileName: String {
        get {
            let consumerName = serviceConsumer.name.stringByReplacingOccurrencesOfString(" ", withString:"_").lowercaseString
            let providerName = service!.name.stringByReplacingOccurrencesOfString(" ", withString:"_").lowercaseString
            return "\(consumerName)-\(providerName).json"
        }
    }

    public func writeSpecFileInDirectory(directory: String) {
        if let jsonData = NSJSONSerialization.dataWithJSONObject(specJsonDictionary, options: NSJSONWritingOptions.PrettyPrinted, error: nil) {
            if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as? String {
                let pactFilePath = directory.stringByAppendingPathComponent(specFileName)
                NSString(string: jsonString).writeToFile(pactFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                println("Wrote pact to \(pactFilePath)")
            }
        }
    }
}