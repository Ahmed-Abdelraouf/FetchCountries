//
//  FileCacheManagerProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Combine

protocol FileCacheManagerProtocol {
    func save<T: Codable & Identifiable>(_ object: T) async throws
    func fetchAll<T: Codable & Identifiable>() async throws -> [T]
    func delete<T: Codable & Identifiable>(_ object: T) async throws
}
