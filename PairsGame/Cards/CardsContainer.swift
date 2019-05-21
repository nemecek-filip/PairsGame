//
//  CardsContainer.swift
//  PairsGame
//
//  Created by Filip Němeček on 12/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class CardsContainer: UIView, CardDelegate {
    
    private let rows = 3
    private let cols = 6
    
    private var numberOfCards: Int {
        return rows * cols
    }
    
    private var removedCardsCounter: Int = 0 {
        didSet {
            if removedCardsCounter == numberOfCards {
                delegate?.cardsContainer(cardsContainer: self, gameDidEnd: pairsFlipCounter)
            }
        }
    }
    
    private var pairsFlipCounter = 0
    
    private var cards = [Card]()
    
    private var revealedCards = [Card]()
    
    private var numberOfRevealedCards = 0 {
        didSet {
            handleNumberOfRevealedCardsChange()
        }
    }
    
    var canRevealCard: Bool = true
    
    var delegate: CardsContainerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        assert(frame.width != 0)
        assert(frame.height != 0)
        
        initCards()
    }
    
    private func handleNumberOfRevealedCardsChange() {
        guard numberOfRevealedCards == 2 else { return }
        
        pairsFlipCounter += 1
        canRevealCard = false
        
        if checkRevealedCardsMatch() {
            // remove both cards
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.revealedCards.forEach { (card) in
                    card.removeFromDeck()
                    self.removedCardsCounter += 1
                }
                self.resetRevealedCards()
            }
        } else {
            // flip cards back after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.revealedCards.forEach({ (card) in
                    card.flipCard()
                })
                self.resetRevealedCards()
            }
        }
    }
    
    private func resetRevealedCards() {
        numberOfRevealedCards = 0
        revealedCards.removeAll(keepingCapacity: true)
        canRevealCard = true
    }
    
    func cardRevealed(_ card: Card) {
        revealedCards.append(card)
        numberOfRevealedCards += 1
    }
    
    func checkRevealedCardsMatch() -> Bool {
        return revealedCards[0].matchesWith(other: revealedCards[1])
    }
    
    func resetCards() {
        for card in cards {
            card.removeFromSuperview()
        }
        cards.removeAll(keepingCapacity: true)
        revealedCards.removeAll(keepingCapacity: true)
        
        initCards()
    }
    
    private func initCards() {
        let margin = 20
        
        let cardWidth = Int(frame.width) / cols - margin
        let cardHeight = Int(frame.height) / rows - margin
        
        print("Calculated card dimensions: \(cardWidth)x\(cardHeight)")
        
        assert(cardWidth > 0)
        assert(cardHeight > 0)
        
        let patternGenerator: PatternGenerator = RectanglePatternGenerator()
        
        let randomPattern = patternGenerator.generateRandomPattern(withSize: CGSize(width: cardWidth, height: cardHeight))
        
        for col in 0 ..< cols {
            let currentMargin = col == 0 ? 0 : margin
            for row in 0 ..< rows {
                let frame = CGRect(x: col * cardWidth + (col * currentMargin), y: row * cardHeight + margin + (row * margin), width: cardWidth, height: cardHeight)
                
                let card = Card(frame: frame)
                card.delegate = self
                card.setPattern(randomPattern)
                
                cards.append(card)
                addSubview(card)
            }
        }
    }
    
    func assignValuesToCards(pairs: [Pair]) {
        precondition(pairs.count * 2 >= numberOfCards, "Number of pairs must be equal or greater than half the number of cards in container. Current number of cards: \(numberOfCards)")
        
        let pairsToAssign: [Pair]
        
        if pairs.count * 2 == numberOfCards {
            pairsToAssign = pairs.shuffled()
        } else {
            pairsToAssign = Array<Pair>(pairs.shuffled()[0..<numberOfCards / 2])
        }
        
        assert(pairsToAssign.count * 2 == numberOfCards)
        
        var cardsToAssign = cards
        
        for (index, pair) in pairsToAssign.enumerated() {
            cardsToAssign.shuffle()
            let cardOne = cardsToAssign.popLast()!
            let cardTwo = cardsToAssign.popLast()!
                        
            cardOne.text = pair.firstValue
            cardOne.tag = index + 1 // Just to avoid default zero tag
            
            cardTwo.text = pair.secondValue
            cardTwo.tag = index + 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCards()
    }
    
}
