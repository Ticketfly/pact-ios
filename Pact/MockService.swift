//
//  MockService.swift
//  Pact
//
//  Created by Patrick Tescher on 3/24/15.
//  Copyright (c) 2015 Ticketfly. All rights reserved.
//

import Foundation

public class MockService {
    let name: String
    let port: UInt
    var interactions = [Interaction]()

    public init(name: String, port: UInt) {
        self.name = name
        self.port = port
    }

    public func given(providerState: String) -> Interaction {
        let interaction = Interaction(providerState: providerState)
        interactions.append(interaction)
        return interaction
    }

    public func run() {
        for interaction in interactions {
            interaction.run()
        }
    }

    public func stop() {
        for interaction in interactions {
            interaction.stop()
        }
    }
}