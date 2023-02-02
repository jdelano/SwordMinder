//
//  String+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

extension String {
    func truncate(to limit: Int, ellipsis: Bool = true) -> String {
        if count > limit {
            let truncated = String(prefix(limit)).trimmingCharacters(in: .whitespacesAndNewlines)
            return ellipsis ? truncated + "\u{2026}" : truncated
        } else {
            return self
        }
    }
    
    func alphaOnly() -> String {
        self.replacingOccurrences(of:"[^a-zA-Z\\s]", with: "", options: .regularExpression)
    }
    
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }

}
