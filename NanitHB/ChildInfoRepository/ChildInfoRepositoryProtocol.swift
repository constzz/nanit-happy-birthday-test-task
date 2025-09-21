//
//  ChildInfoRepositoryProtocol.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import Foundation

protocol ChildInfoRepositoryProtocol {
    func save(name: String)
    func save(birthday: Date)
    func save(fileCached: FileCached)
    
    func getName() -> String?
    func getBirthday() -> Date?
    func getFileCached() -> FileCached?
}
