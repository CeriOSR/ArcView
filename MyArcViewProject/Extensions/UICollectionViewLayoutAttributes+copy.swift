//
//  UICollectionViewLayoutAttributes+copy.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

extension Collection where Element: UICollectionViewLayoutAttributes {
    func copy<T:UICollectionViewLayoutAttributes>() -> [T] {
        return self.map { $0.copyAttributes() }
    }
}

extension UICollectionViewLayoutAttributes {
    func copyAttributes<T: UICollectionViewLayoutAttributes>() -> T {
        guard let copy = self.copy() as? T else { fatalError() }
        return copy
    }
}
