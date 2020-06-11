//
//  Error+AbortReason.swift
//  App
//
//  Created by William Woolard on 2/13/20.
//

import Vapor

extension Error {
    var abortReason: String? {
        return (self as? AbortError)?.reason
    }
}
