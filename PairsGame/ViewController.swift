//
//  ViewController.swift
//  PairsGame
//
//  Created by Filip Němeček on 12/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardsContainerDelegate {
    @IBOutlet var cardsContainer: CardsContainer!
    @IBOutlet var selectedPairsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsContainer.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentPairsChoice()
    }
    
    func cardsContainer(cardsContainer: CardsContainer, gameDidEnd numberOfFlips: Int) {
        let ac = UIAlertController(title: "Game Complete", message: "All cards found! Congratulations. It took \(numberOfFlips) pairs flip to find them all.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New game", style: .default, handler: { [weak self] (action) in
            self?.selectedPairsLabel.text = ""
            cardsContainer.resetCards()
            self?.presentPairsChoice()
        }))
        present(ac, animated: true)
    }
    
    func presentPairsChoice() {
        let ac = UIAlertController(title: "Choose pairs to start", message: nil, preferredStyle: .alert)
        
        for pairsChoice in Pairs.allCases {
            ac.addAction(UIAlertAction(title: pairsChoice.rawValue, style: .default, handler: { [weak self] (action) in
                self?.assignPairsToCards(pairsChoice: pairsChoice)
                self?.selectedPairsLabel.text = pairsChoice.rawValue
            }))
        }
        
        present(ac, animated: true, completion: nil)
    }
    
    func assignPairsToCards(pairsChoice: Pairs) {
        let pairs = DataProvider.standard.getPairs(pairsChoice)
        
        cardsContainer.assignValuesToCards(pairs: pairs)
    }
}

