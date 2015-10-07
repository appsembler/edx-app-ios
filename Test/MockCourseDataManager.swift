//
//  MockCourseDataManager.swift
//  edX
//
//  Created by Akiva Leffert on 5/20/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import edX
import UIKit

class MockCourseDataManager : CourseDataManager {
    let querier : CourseOutlineQuerier?
    let topicsManager : DiscussionDataManager?
    
    private var _currentOutlineMode : CourseOutlineMode = .Full
    
    init(querier : CourseOutlineQuerier? = nil, topicsManager : DiscussionDataManager? = nil) {
        self.querier = querier
        self.topicsManager = topicsManager
        super.init(analytics:nil, interface : nil, networkManager: nil, session : nil)
    }
    
    override func querierForCourseWithID(courseID : String) -> CourseOutlineQuerier {
        return querier ?? super.querierForCourseWithID(courseID)
    }
    
    override func discussionManagerForCourseWithID(courseID: String) -> DiscussionDataManager {
        return topicsManager ?? super.discussionManagerForCourseWithID(courseID)
    }
    
    override var currentOutlineMode : CourseOutlineMode {
        get {
            return _currentOutlineMode
        }
        set {
            _currentOutlineMode = newValue
            NSNotificationCenter.defaultCenter().postNotificationName(self.modeChangedNotificationName, object: nil)
        }
    }
}