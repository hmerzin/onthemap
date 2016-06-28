//
//  Annotation.swift
//  en the map
//
//  Created by Harry Merzin on 6/25/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import CoreLocation
struct StudentInformation {
    var annotationDict: [String: AnyObject]
    init(annotationsDict: [String: AnyObject]) {
        self.annotationDict = annotationsDict
    }
}