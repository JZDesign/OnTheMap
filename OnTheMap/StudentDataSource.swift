//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/9/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit

class StudentDataSource {
    var studentData = [StudentLocation]()
    var myinfo: StudentLocation? = nil
    var userPins = [StudentLocation]()
    
    static let sharedInstance = StudentDataSource()
    private init() {} 
}
