//
//  EncapsulateText.swift
//  EncapsulateText
//
//  Created by Matt Hogg on 24/12/2022.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class EncapsulateText: NSObject, EncapsulateTextProtocol {
    /// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
    @objc func encapsulate(string: String, with reply: @escaping (String) -> Void) {
		let response = string.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\t", with: "\\t").replacingOccurrences(of: "\r", with: "\\r").replacingOccurrences(of: "\"", with: "\\\"")
        reply(response)
    }
}
