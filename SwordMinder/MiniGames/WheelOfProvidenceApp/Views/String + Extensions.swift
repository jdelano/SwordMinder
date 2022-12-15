//
//  String + Extensions.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
