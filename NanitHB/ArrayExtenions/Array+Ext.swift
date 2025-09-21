//
//  Array+Ext.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }

    func fill<T>(with item: T) -> Array {
        var arrayTemp = self

        if arrayTemp.count > 10 {
            arrayTemp.removeLast(arrayTemp.count - 10)
        }

        if let item = item as? Element, arrayTemp.count < 10 {
            arrayTemp.append(contentsOf: Array(repeating: item, count: 10 - arrayTemp.count))
        }

        return arrayTemp.reversed()
    }
    
    func safelyRetrieve(elementAt index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }

    var second: Element? {
        return safelyRetrieve(elementAt: 1)
    }

    var isNotEmpty: Bool { !isEmpty }
    
    mutating func append(_ element: Element, if precondition: Bool) {
        guard precondition else { return }

        self.append(element)
    }

    func appending(_ element: Element) -> [Element] {
        var copy = self
        copy.append(element)
        return copy
    }

    func appending(_ elements: [Element]) -> [Element] {
        var copy = self
        copy.append(contentsOf: elements)
        return copy
    }

    func appending(_ element: Element, if precondition: Bool) -> [Element] {
        guard precondition else {
            return self
        }

        var copy = self
        copy.append(element)
        return copy
    }

    func appendingIfNotNil(_ element: Element?) -> [Element] {
        guard let element else { return self }
        return self.appending(element)
    }

    func appendingIfNotNil(_ elements: [Element]?) -> [Element] {
        guard let elements else { return self }
        return elements.appending(elements)
    }

    func inserting(_ element: Element, at index: Int) -> (array: [Element], insertedIndex: Int) {
        var copy = self
        let safeIndex = Swift.min(Swift.max(index, 0), copy.endIndex)
        copy.insert(element, at: safeIndex)
        return (copy, safeIndex)
    }

    func inserting(contentsOf elements: [Element], at index: Int) -> (array: [Element], insertedRange: Range<Int>) {
        var copy = self
        let safeIndex = Swift.min(Swift.max(index, 0), copy.endIndex)
        copy.insert(contentsOf: elements, at: safeIndex)
        return (copy, safeIndex ..< safeIndex + elements.count)
    }
}

