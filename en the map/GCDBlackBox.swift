//
//  GCDBlackBox.swift
//  en the map
//
//  Created by Harry Merzin on 5/30/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}