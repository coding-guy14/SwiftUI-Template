//
//  AppError.swift
//  Workspace
//
//  Created by Soham Divekar on 2/11/2026.
//

import Foundation


/// Application-level errors representing known failure states.
enum AppError: Error, LocalizedError {

    case unknown
    case debug(_ message: String? = nil)
}
