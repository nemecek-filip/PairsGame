//
//  PatternGenerator.swift
//  PairsGame
//
//  Created by Filip Němeček on 12/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

protocol PatternGenerator {
    func generateRandomPattern(withSize size: CGSize) -> UIImage
}
