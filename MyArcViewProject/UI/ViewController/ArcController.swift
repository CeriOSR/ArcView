//
//  ViewController.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

typealias SingleResult<T> = ((T) -> Void)

class ArcController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var viewmodel: ArcControllerViewModel!

    // Handler callers
    private var switchBackgroundColor: SingleResult<Int>?
    private var shrinkRightCell: SingleResult<CGRect>?
    private var shrinkLeftCell: SingleResult<CGRect>?
    private var shrinkFarRightCell: SingleResult<CGRect>?
    private var shrinkFarLeftCell: SingleResult<CGRect>?
    
    private var layout: ArcCollectionViewLayout!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backgroundColorView: UIView!
    
}

// MARK: - LifeCycle
extension ArcController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel = ArcControllerViewModel()
        bind()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = getCurrentCenterIndex()
    }
}

// MARK: - Binding
private extension ArcController {
    func bind() {
        switchBackgroundColor = handleBGColorSwitch()
        shrinkLeftCell = handleShrinkLeftCell()
        shrinkRightCell = handleShrinkRightCell()
        shrinkFarLeftCell = handleShrinkFarLeftCell()
        shrinkFarRightCell = handleShrinkFarRightCell()
    }
}

// MARK: - Setup
private extension ArcController {
    func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView () {
        layout = ArcCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Methods
private extension ArcController {
    func getCurrentCenterIndex() -> Int {
        let collectionViewRect = CGRect(
            origin: collectionView.contentOffset,
            size: collectionView.bounds.size
        )
        
        let centerPoint = CGPoint(
            x: collectionViewRect.midX,
            y: collectionViewRect.midY
        )
        
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            switchBackgroundColor?(centerIndexPath.item)
            let centerCell = collectionView.cellForItem(at: centerIndexPath) as? ArcCell
            centerCell?.rescaleCellViews(in: .center)
            
            shrinkRightCell?(collectionViewRect)
            shrinkLeftCell?(collectionViewRect)
            shrinkFarRightCell?(collectionViewRect)
            shrinkFarLeftCell?(collectionViewRect)

            return centerIndexPath.row
        }
        
        return 0
    }
}

// MARK: - UICollectionView Delegates/datasource
extension ArcController {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArcCell.identifier,
                for: indexPath) as? ArcCell
        else { return UICollectionViewCell() }
        
        cell.viewModel = ArcCellViewModel(color: viewmodel.colors[indexPath.item])
        
        return cell
    }
}

// MARK: - ScrollView Delegates
extension ArcController {
    func scrollViewDidEndDecelerating(
        _ scrollView: UIScrollView
    ) {
        viewmodel.midIndex = getCurrentCenterIndex()
    }
    
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        viewmodel.midIndex = getCurrentCenterIndex()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewmodel.midIndex = getCurrentCenterIndex()
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / layout.itemAndSpacingWidth
        let roundedIndex = round(index)
        offset = CGPoint(
            x: roundedIndex * layout.itemAndSpacingWidth,
            y: scrollView.contentInset.top
        )
        targetContentOffset.pointee = offset
    }
}

// MARK: - Handlers
private extension ArcController {
    func handleBGColorSwitch() -> SingleResult<Int> {
        return { [weak self] index in
            guard let self = self else { return }
            self.backgroundColorView.backgroundColor = self.viewmodel.colors[index]
        }
    }
    
    func handleShrinkFarRightCell() -> SingleResult<CGRect> {
        return { [weak self] rect in
            guard let self = self else { return }
            let farRightPoint: CGPoint = CGPoint(
                x: rect.midX + self.collectionView.bounds.width * 0.375,
                y: rect.midY
            )
            if let farRightIndexPath = self.collectionView.indexPathForItem(at: farRightPoint) {
                let farRightCell = self.collectionView.cellForItem(at: farRightIndexPath) as? ArcCell
                farRightCell?.rescaleCellViews(in: .farRight)
            }
        }
    }
    
    func handleShrinkFarLeftCell() -> SingleResult<CGRect> {
        return { [weak self] rect in
            guard let self = self else { return }
            let farLeftPoint: CGPoint = CGPoint(
                x: rect.midX - self.collectionView.bounds.width * 0.375,
                y: rect.midY
            )
            
            if let farLeftIndexPath = self.collectionView.indexPathForItem(at: farLeftPoint) {
                let farLeftCell = self.collectionView.cellForItem(at: farLeftIndexPath) as? ArcCell
                farLeftCell?.rescaleCellViews(in: .farLeft)
            }
        }
    }
    
    func handleShrinkLeftCell() -> SingleResult<CGRect> {
        return { [weak self] rect in
            guard let self = self else { return }
            let leftPoint: CGPoint = CGPoint(
                x: rect.midX - self.collectionView.bounds.width * 0.25,
                y: rect.midY
            )
            
            if let leftIndexPath = self.collectionView.indexPathForItem(at: leftPoint) {
                let leftCell = self.collectionView.cellForItem(at: leftIndexPath) as? ArcCell
                leftCell?.rescaleCellViews(in: .letToCenter)
            }
        }
    }
    
    func handleShrinkRightCell() -> SingleResult<CGRect> {
        return { [weak self] rect in
            guard let self = self else { return }
            let rightPoint = CGPoint(
                x: rect.midX + self.collectionView.bounds.width * 0.25,
                y: rect.midY
            )
            
            if let rightIndexPath = self.collectionView.indexPathForItem(at: rightPoint) {
                let centerCell = self.collectionView.cellForItem(at: rightIndexPath) as? ArcCell
                centerCell?.rescaleCellViews(in: .rightToCenter)
            }
        }
    }
}

