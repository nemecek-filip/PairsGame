//
//  DataProvider.swift
//  PairsGame
//
//  Created by Filip Němeček on 14/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import Foundation

class DataProvider {
    
    static let standard = DataProvider()
    
    func getCapitalPairs() -> [Pair] {
        return loadPairsFromFile(filename: "Capitals")
    }
    
    func getPairs(_ pairs: Pairs) -> [Pair] {
        return loadPairsFromFile(filename: pairs.rawValue)
    }
    
    private func loadPairsFromFile(filename: String) -> [Pair] {
        let filePath = Bundle.main.url(forResource: filename, withExtension: "txt")!
        
        let contents = try! String(contentsOf: filePath)
        
        let lines = contents.components(separatedBy: "\n")
        
        assert(lines.count > 0)
        
        return lines.compactMap { (line) -> Pair? in
            let parts = line.components(separatedBy: ":")
            if parts.count == 2 {
                return Pair(firstValue: parts[0], secondValue: parts[1])
            } else {
                return nil
            }
        }
    }
    
}
