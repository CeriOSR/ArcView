//
//  Array+shift.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import Foundation

// use for the continous looping
//example: [1,2,3,4,5].shift(distanc: 3) = [4, 5, 1, 2, 3]
extension Array {
    func shift(distance: Int = 1) -> [Element] {
        let offsetIndex = distance >= 0
            ? self.index(startIndex, offsetBy: distance, limitedBy: endIndex)
            : self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
        guard let index = offsetIndex else { return self }
        let endRange = index..<endIndex
        let endOfArray = self[endRange]
        let startRange = startIndex..<index
        let startOfArray = self[startRange]
        
        return Array(endOfArray + startOfArray)
    }
    
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(distance: distance)
    }
}
