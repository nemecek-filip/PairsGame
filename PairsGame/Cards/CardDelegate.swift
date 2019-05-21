//
//  CardDelegate.swift
//  PairsGame
//
//  Created by Filip Němeček on 14/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import Foundation

protocol CardDelegate: class {
    func cardRevealed(_ card: Card)
    var canRevealCard: Bool { get }
}
