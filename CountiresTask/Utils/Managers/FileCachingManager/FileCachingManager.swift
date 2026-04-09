//
//  FileCachingManager.swift
//  CountiresTask
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation

actor FileCacheManager: FileCacheManagerProtocol {
    private let fileName: String

    private lazy var cacheDirectoryURL: URL = {
        let cacheDirectoryURL = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        return cacheDirectoryURL.appendingPathComponent("\(fileName).json")
    }()

    init(fileName: String) {
        self.fileName = fileName
    }

    func save<T: Codable & Identifiable>(_ object: T) async throws {
        var allObjects: [T] = loadObjects()
        if let index = allObjects.firstIndex(where: { $0.id == object.id }) {
            allObjects[index] = object
        } else {
            allObjects.append(object)
        }

        try saveObjects(allObjects)
    }

    func fetchAll<T: Codable & Identifiable>() async throws -> [T] {
        loadObjects()
    }

    func delete<T: Codable & Identifiable>(_ object: T) async throws {
        var allObjects: [T] = loadObjects()
        allObjects.removeAll { $0.id == object.id }
        try saveObjects(allObjects)
    }

    private func loadObjects<T: Codable>() -> [T] {
        guard let data = try? Data(contentsOf: cacheDirectoryURL),
              let objects = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return objects
    }

    private func saveObjects<T: Codable>(_ objects: [T]) throws {
        let data = try JSONEncoder().encode(objects)
        try data.write(to: cacheDirectoryURL, options: .atomic)
    }
}
