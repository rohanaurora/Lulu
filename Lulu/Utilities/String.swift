//
//  String.swift
//  Lulu
//
//  Created by Rohan Aurora on 9/2/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import Foundation

extension String {
    
    /// A string extension that checks for an empty string including white spaces and new lines.
    func isEmptyString() -> Bool {
        
        if self.isEmpty {
            return true
        }
        
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return (trimmed == "")
    }
}
