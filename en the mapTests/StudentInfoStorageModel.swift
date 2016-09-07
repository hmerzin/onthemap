//
//  StudentInfoStorageModel.swift
//  en the map
//
//  Created by Harry Merzin on 9/5/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
class StudentInfoStorageModel {
    static let sharedInstance = StudentInfoStorageModel()
    var infoArray = [StudentInformation]()
}