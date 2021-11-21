//
//  ArcCollectionViewLayout.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

class ArcCollectionViewLayout: UICollectionViewLayout {
    // MARK: Public
    var itemAndSpacingWidth: CGFloat {
        return itemSize.width + itemXSpacing
    }
    
    // MARK: Private
    private var itemCount: Int = 0
    private var itemXSpacing: CGFloat = 10.0
    private var itemSize: CGSize = CGSize(width: 80, height: 80)
    // Radius of the circle that the cells will arc over - Lower for steeper arc.
    private var arcRadius: CGFloat = 600
    
    // Make this large enough so a fast swipe will stop before bouncing. Needed for Looping.
    private let insetWidth: CGFloat = 16000
    
    // calculating the total content width of the collectionView
    private var contentWidth: CGFloat {
        let totalItemAndSpacingWidth = (CGFloat(itemCount) * itemAndSpacingWidth)
        return totalItemAndSpacingWidth
    }
    
    // preemptively widening the content width
    private var leadingOffsetX: CGFloat {
        return insetWidth
    }
    private var trailingOffsetX: CGFloat {
        return collectionViewContentSize.width - insetWidth
    }
    
    private var hasSetInitialContentOffsetOnce = false
    
    // For Arcing
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var adjustedLayoutAttributes: [UICollectionViewLayoutAttributes] = []
}

// MARK: - Overrides
extension ArcCollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else { return .zero }
        
        let totalInsetWidth = insetWidth * 2.0
        let totalContentWidth = totalInsetWidth + contentWidth
        
        return CGSize(width: totalContentWidth, height: cv.frame.height)
    }
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        
        itemCount = cv.numberOfItems(inSection: 0)
        
        // These are cached until reloadData or bounds size change.
        if layoutAttributes.count == 0 {
            var currentX = leadingOffsetX
            layoutAttributes = []
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.size = itemSize
                
                // Determine the vertical center
                let xCenter = currentX + (itemSize.width / 2.0)
                let yCenter = cv.bounds.midY // * differs from original *
                
                attributes.center = CGPoint(x: xCenter, y: yCenter)
                layoutAttributes.append(attributes)
                
                currentX += itemSize.width + itemXSpacing
                
            }
        }
        
        // if there are no items, we dont need to do anything else.
        if itemCount == 0 { return }
        
        setInitialContentOffsetIfRequired(collectionView: cv)
        
        // normalized the value so that the first item's left edge would be at 0
        let normalizedContentOffsetX = cv.contentOffset.x - leadingOffsetX
        
        // find the nearest item index (this can be larger than the itemCount as we scroll to the right
        let nearestContentIndex = Int(normalizedContentOffsetX / itemAndSpacingWidth)
        let nearestItemIndex = Int(nearestContentIndex) % itemCount
        
        // how many full content widths are we offset by
        let multiple = (nearestContentIndex - nearestItemIndex) / itemCount
        
        adjustedLayoutAttributes = layoutAttributes
            .copy()
            .shift(distance: nearestItemIndex)
        
        let firstAttribute = adjustedLayoutAttributes[0]
        
        // find the currentX and then change all attributes after first index to move right along the layout.
        var currentX = firstAttribute.center.x
        currentX += (contentWidth * CGFloat(multiple))
        for attributes in adjustedLayoutAttributes {
            attributes.center = CGPoint(x: currentX, y: attributes.center.y)
            currentX += itemAndSpacingWidth
            
            adjustAttribute(attributes, collectionView: cv)
        }
        
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        return adjustedLayoutAttributes.filter { rect.intersects( $0.frame ) }
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        for attributes in adjustedLayoutAttributes
        where attributes.indexPath == indexPath {
            return attributes
        }
        return nil
    }
    
    override func shouldInvalidateLayout(
        forBoundsChange newBounds: CGRect
    ) -> Bool {
        return true
    }
    
    override func invalidationContext(
        forBoundsChange newBounds: CGRect
    ) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let cv = collectionView else { return context }
        
        // if we are scrolling off the leading/trailing offsets we need to adjust the contentOffset so we can wrap around.
        // this will be seamless for the user as the current momentum is maintained.
        if cv.contentOffset.x >= trailingOffsetX {
            let offset = CGPoint(x: -contentWidth, y: 0)
            context.contentOffsetAdjustment = offset
        } else if cv.contentOffset.x <= leadingOffsetX {
            let offset = CGPoint(x: contentWidth, y: 0)
            context.contentOffsetAdjustment = offset
        }
        
        return context
    }
    
    override func invalidateLayout(
        with context: UICollectionViewLayoutInvalidationContext
    ) {
        // re-ask the delegate for centered indexPath if we ever reload data
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            layoutAttributes = []
            adjustedLayoutAttributes = []
            hasSetInitialContentOffsetOnce = false
        }
        super.invalidateLayout(with: context)
    }
}

// MARK: Private Methods
extension ArcCollectionViewLayout {
    private func initialContentOffset(collectionView cv: UICollectionView) -> CGPoint? {
        guard let cv = collectionView, itemCount > 0 else { return nil }
        let firstIndexPath = IndexPath(item: 0, section: 0)
        let attributes = layoutAttributes[firstIndexPath.item]
        // start at the end of the content if we are wrapping.
        let initialContentOffsetX = contentWidth
        
        let centeredOffsetX = (attributes.center.x + initialContentOffsetX) - (cv.frame.width / 2.0)
        let contentOffsetAdjustment = CGPoint(x: centeredOffsetX, y: 0)
        return contentOffsetAdjustment
    }
    
    private func setInitialContentOffsetIfRequired(collectionView cv: UICollectionView) {
        guard !hasSetInitialContentOffsetOnce,
              let initialContentOffset = initialContentOffset(collectionView: cv)
        else { return }
        
        // we only do this once, until reload data and everything gets invalidated
        hasSetInitialContentOffsetOnce = true
        cv.setContentOffset(initialContentOffset, animated: false)
    }
    
    private func adjustAttribute(
        _ attribute: UICollectionViewLayoutAttributes,
        collectionView cv: UICollectionView
    ) {
        let visibleRect = CGRect(
            origin: cv.contentOffset,
            size: cv.bounds.size
        )
        // if the cell is visible it needs to be3 translated to the arc.
        let activeArcDistance = (visibleRect.width + itemSize.width) / 2
        
        let distanceFromCenter = abs(visibleRect.midX - attribute.center.x)
        var transform: CATransform3D = CATransform3DIdentity
        
        if distanceFromCenter < activeArcDistance {
            // divide the latter part by higher number to make the curve smaller. 5 is straight
            let yTranslation = arcRadius - sqrt((arcRadius * arcRadius) - (distanceFromCenter * distanceFromCenter))
            transform = CATransform3DMakeTranslation(0, yTranslation, 0)
        }
        attribute.transform3D = transform
        
    }
}
