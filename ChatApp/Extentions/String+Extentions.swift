//
//  String+Extentions.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace:Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
