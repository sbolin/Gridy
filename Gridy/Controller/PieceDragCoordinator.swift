//
//  PieceDragCoordinator.swift
//  Gridy
//
//  Created by Scott Bolin on 12/7/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import Foundation

class PieceDragCoordinator {
    let sourceIndexPath: IndexPath
    var dragCompleted = false
    var isReordering = false
    
    init(sourceIndexPath: IndexPath) {
        self.sourceIndexPath = sourceIndexPath
    }
}
