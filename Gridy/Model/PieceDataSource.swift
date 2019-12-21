//
//  PieceDataSource.swift
//  Gridy
//
//  Created by Scott Bolin on 11/30/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

class PieceDataSource: NSObject, UICollectionViewDataSource {
    
    //MARK: - Properties
    private var pieceCollection: [UIImage]
    
    //MARK: - Initialization
    init(pieceCollection: [UIImage]) {
        self.pieceCollection = pieceCollection
        super.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pieceCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PieceCell", for: indexPath)
        
        
        if let cell = cell as? PieceCell {
            let item = pieceCollection[indexPath.item]
            cell.pieceImage.image = item
        }
        cell.backgroundColor = .white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        return cell
        
    }
}

// MARK: - Create the dragItem
extension PieceDataSource {
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let item = pieceCollection[indexPath.item]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func addItem(_ newItem: UIImage, at index: Int) {
        pieceCollection.insert(newItem, at: index)
    }
    
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let item = pieceCollection[sourceIndex]
        pieceCollection.insert(item, at: destinationIndex)
        pieceCollection.remove(at: sourceIndex)
    }
    
    func swapItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
//        let sourceItem = pieceCollection[sourceIndex]
//        let destinationItem = pieceCollection[destinationIndex]
        pieceCollection.swapAt(sourceIndex, destinationIndex)
    }
    
    func deleteItem(at sourceIndex: Int) {
        pieceCollection.remove(at: sourceIndex)
    }
    
    func getItemAtIndex(indexPath: Int) -> UIImage? {
        return pieceCollection[indexPath]
    }
    
}


