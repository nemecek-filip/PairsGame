//
//  Pair.swift
//  PairsGame
//
//  Created by Filip Němeček on 14/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import Foundation

struct Pair: Equatable {
    
    static func ==(lhs: Pair, rhs: Pair) -> Bool {
         return (lhs.firstValue == rhs.firstValue && lhs.secondValue == rhs.secondValue) || (lhs.secondValue == rhs.firstValue && lhs.firstValue == rhs.secondValue)
    }
    
    let firstValue: String
    let secondValue: String   
    
}
