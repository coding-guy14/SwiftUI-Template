//
//  Defaults.swift
//  Workspace
//
//  Created by Soham Divekar on 2/11/2026.
//

import Foundation


// MARK: - APP SERVICE

/// Base protocol for all domain services.
protocol AppService: Sendable {}


// MARK: - MANAGER PROTOCOL

/// Base protocol for state coordinators.
protocol Manager {

    var service: any AppService { get }
}


// MARK: - DEPENDENCIES

/// Application dependency container and environment mode configuration.
@MainActor
struct Dependencies {

    enum BuildMode {
        case production
        case development(_ usesMocks: Bool = true)
    }

    var buildMode: BuildMode = .development()
}


// MARK: - MOCK SERVICE

/// Protocol for mock services providing configurable delays and error simulation.
protocol MockService {

    var delay: Double { get }
    var showError: Bool { get }

    func syncThrowableCall() throws(AppError)
    func asyncThrowableCall() async throws(AppError)
}

extension MockService {

    var delay: Double { 0 }
    var showError: Bool { false }

    func syncThrowableCall() throws(AppError) {
        if showError { throw .debug("Mock Sync Error :: \(#file) * \(#line) * \(#function)") }
    }

    func asyncThrowableCall() async throws(AppError) {
        do { try await Task.sleep(for: .seconds(delay)) }
        catch { throw .unknown }
        if showError { throw .debug("Mock Async Error :: \(#file) * \(#line) * \(#function)") }
    }
}
