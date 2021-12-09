//
//  Array.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/09.
//

import Foundation

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
