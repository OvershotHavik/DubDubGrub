//
//  String+Ext.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/22/22.
//

import Foundation

extension String {
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
