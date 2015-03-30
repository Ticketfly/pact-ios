//
//  ServiceConsumer.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation

public class ServiceConsumer {

    let name: String

    public init(_ name: String) {
        self.name = name
    }

    public func hasPactWith(serviceProviderName: String) -> ServiceProvider {
        return ServiceProvider(serviceProviderName, serviceConsumer:self)
    }

    public var jsonDictionary: NSDictionary {
        get {
            return ["name": name] as NSDictionary
        }
    }
}