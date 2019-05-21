//
//  CardsContainerDelegate.swift
//  PairsGame
//
//  Created by Filip Němeček on 21/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import Foundation

protocol CardsContainerDelegate {
    func cardsContainer(cardsContainer: CardsContainer, gameDidEnd numberOfFlips: Int)
}
