/**
Copyright (c) 2015 Qualcomm Education, Inc.
All rights reserved.


Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Qualcomm Education, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

import Foundation
import UIKit

class OEXCourseDashboardViewControllerEnvironment : NSObject {
    weak var config: OEXConfig?
    weak var router: OEXRouter?
    
    init(config: OEXConfig, router: OEXRouter) {
        self.config = config
        self.router = router
    }
}


class OEXCourseDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var environment: OEXCourseDashboardViewControllerEnvironment
    private var course: OEXCourse
    
    var tableView: UITableView = UITableView()
    
    var iconsArray = NSArray()
    var titlesArray = NSArray()
    var detailsArray = NSArray()
    
    
    init(environment: OEXCourseDashboardViewControllerEnvironment, course: OEXCourse) {
        self.environment = environment
        self.course = course
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        // required by the compiler because UIViewController implements NSCoding,
        // but we don't actually want to serialize these things
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { make -> Void in
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
        }
        
        // Register tableViewCell
        tableView.registerClass(OEXCourseDashboardCourseInfoCell.self, forCellReuseIdentifier: OEXCourseDashboardCourseInfoCell.identifier)
        tableView.registerClass(OEXCourseDashboardCell.self, forCellReuseIdentifier: OEXCourseDashboardCell.identifier)
        
        prepareTableViewData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    // TODO: this is the temp data
    func prepareTableViewData() {
        
        if shouldEnableDiscussions() {
            self.titlesArray = ["Course", "Discussion", "Handouts", "Announcements"]
        }else {
            self.titlesArray = ["Course", "Handouts", "Announcements"]
        }
        
        if shouldEnableDiscussions() {
            self.detailsArray = ["Lectures, videos & homework, oh my!",
                "Lets talk about single-molecule diodes",
                "Virtual, so not really a handout",
                "It's 3 o'clock and all is well"]
        }else {
            self.detailsArray = ["Lectures, videos & homework, oh my!",
                "Virtual, so not really a handout",
                "It's 3 o'clock and all is well"]
        }
    }
    
    
    func shouldEnableDiscussions() -> Bool {
        return self.environment.config!.shouldEnableDiscussions()
    }
    

    // MARK: - TableView Data and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesArray.count + 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }else{
            return 80.0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(OEXCourseDashboardCourseInfoCell.identifier, forIndexPath: indexPath) as! OEXCourseDashboardCourseInfoCell
            
            cell.titleLabel.text = self.course.name
            cell.detailLabel.text = self.course.org + " | " + self.course.number
            
            //TODO: the way to load image is not perfect, need to do refactoring later
            cell.course = self.course
            cell.setCoverImage()
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(OEXCourseDashboardCell.identifier, forIndexPath: indexPath) as! OEXCourseDashboardCell
            
            cell.titleLabel.text = self.titlesArray.objectAtIndex(indexPath.row - 1) as? String
            cell.detailLabel.text = self.detailsArray.objectAtIndex(indexPath.row - 1) as? String
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 1 {
            showCourseware()
        }else if indexPath.row == self.titlesArray.count {
            showAnnouncements()
        }else if indexPath.row == self.titlesArray.count - 1 {
            showHandouts()
        }else{
            showDiscussions()
        }
        
    }
    
    func showCourseware() {
        self.environment.router?.showCoursewareForCourseWithID(self.course.course_id, fromController: self)
    }
    
    func showDiscussions() {
        self.environment.router?.showDiscussionTopicsForCourse(self.course, fromController: self)
    }
    
    func showHandouts() {
        // TODO
    }
    
    func showAnnouncements() {
        // TODO
    }
    
    
    
}
