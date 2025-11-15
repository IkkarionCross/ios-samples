//
//  String+Extension.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 11/10/25.
//

import Foundation

extension String {
    func isValidURL() -> Bool {
        let pattern = #"^(?:https|http)?:\/\/(?!ww\.|w\.)(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
}
