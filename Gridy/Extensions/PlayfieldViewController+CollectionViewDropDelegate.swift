//
//  PlayfieldViewController+CollectionViewDropDelegate.swift
//  Gridy
//
//  Created by Scott Bolin on 12/18/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDropDelegate
extension PlayfieldViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let dataSource = dataSourceForCollectionView(collectionView)
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.item > 15 { return }
            destinationIndexPath = indexPath // drop at location

        } else {
            destinationIndexPath = IndexPath(item: collectionView.numberOfItems(inSection: 0) - 1, section: 0)
            // drop at end of collectionView if no drop location
        }
        
        let blankImage = UIImage(named: "Blank")
        
        let item = coordinator.items[0] // select the first drag item
        switch coordinator.proposal.operation {
        case .move:
            guard let dragCoordinator = coordinator.session.localDragSession?.localContext as? PieceDragCoordinator else { return }
            if let sourceIndexPath = item.sourceIndexPath {
                dragCoordinator.isReordering = true
                collectionView.performBatchUpdates({
                    dataSource.swapItem(at: sourceIndexPath.item, to: destinationIndexPath.item)
                    collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                    collectionView.moveItem(at: destinationIndexPath, to: sourceIndexPath)
                    
                    self.bloopPlayer?.play()
                    addToScore()
                    checkIfGameOver(dataSource: dataSource)
                })
            } else {
                if let destinationDataSource = collectionView.dataSource as? PieceDataSource,
                    let image = destinationDataSource.getItemAtIndex(indexPath: destinationIndexPath.item) {
                    if !image.isEqual(blankImage) {
                        return
                    }
                }
                dragCoordinator.isReordering = false
                if let piece = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({
                        if destinationIndexPath.item > 15 { return }
                        dataSource.deleteItem(at: destinationIndexPath.item)
                        dataSource.addItem(piece, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [destinationIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        self.bloopPlayer?.play()
                        addToScore()
                        checkIfGameOver(dataSource: dataSource)
                    })
                }
            }
            dragCoordinator.dragCompleted = true
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard session.localDragSession != nil else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        guard session.items.count == 1 else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    func addToScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
}
