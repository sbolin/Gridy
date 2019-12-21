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
            destinationIndexPath = indexPath // drop at location
        } else {
            destinationIndexPath = IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)
            // drop at end of collectionView if no drop location
        }
        
        
        let item = coordinator.items[0] // select the first drag item
        switch coordinator.proposal.operation {
        case .move:
            guard let dragCoordinator = coordinator.session.localDragSession?.localContext as? PieceDragCoordinator else { return }
            if let sourceIndexPath = item.sourceIndexPath {
                print("Moving within the same collectionView...")

                dragCoordinator.isReordering = true
                collectionView.performBatchUpdates({
//                    dataSource.moveItem(at: sourceIndexPath.item, to: destinationIndexPath.item)
//                    collectionView.deleteItems(at: [sourceIndexPath])
//                    collectionView.insertItems(at: [destinationIndexPath])
                    dataSource.swapItem(at: sourceIndexPath.item, to: destinationIndexPath.item)
                    collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                    collectionView.moveItem(at: destinationIndexPath, to: sourceIndexPath)
//                    collectionView.reloadData()

                    self.bloopPlayer?.play()
                    addToScore()
                })
            } else {
                print("Moving between collection views")
                
                if let destinationDataSource = playfieldView.dataSource as? PieceDataSource,
                    let image = destinationDataSource.getItemAtIndex(indexPath: destinationIndexPath.item),
                    let blankImage = UIImage(named: "Blank")  {
                    if !image.isEqual(blankImage) {
                        print("Moving to existing image, don't move")
                        return }
                }
                
                dragCoordinator.isReordering = false
                if let piece = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({
                        dataSource.deleteItem(at: destinationIndexPath.item) // added
                        dataSource.addItem(piece, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [destinationIndexPath]) // added
                        collectionView.insertItems(at: [destinationIndexPath])
                        self.bloopPlayer?.play()
                        addToScore()
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
            return UICollectionViewDropProposal(operation: .cancel)
        }
        guard session.items.count == 1 else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func addToScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
}


