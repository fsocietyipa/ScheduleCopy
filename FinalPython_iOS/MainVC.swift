//
//  ViewController.swift
//  FinalPython_iOS
//
//  Created by fsociety.1 on 11/20/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView


struct Data: Codable {
    let timetable: [Timetable]
}

struct Timetable: Codable {
    let id, subject_id, teacher_id, bundle_id, day_id, time_id, subject_type_id: String
    let time_value: TimeValue
}

struct TimeValue: Codable {
    let start_time, end_time: String
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    var saveData = [Timetable]()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshScheduleData(_:)), for: .valueChanged)
        startAnimating(CGSize(width: 30, height: 30), message: "Loading...", type: .circleStrokeSpin)
        getData()
    }
    
    @objc private func refreshScheduleData(_ sender: Any) {
        saveData.removeAll()
        tableView.reloadData()
        getData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
            
        default :
            return ""
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if saveData.isEmpty{
            return 0
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.tintColor = UIColor.white
            headerTitle.textLabel?.textColor =  #colorLiteral(red: 0.4391209483, green: 0.4399314523, blue: 0.7670679092, alpha: 1)
            headerTitle.textLabel?.font = UIFont(name: (headerTitle.textLabel?.font.fontName)!, size: 25)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saveData.isEmpty {
            return 0
        }
        else {
            switch (section) {
            case 0:
//                let tmp = saveData.filter({$0.day_id == "1"})
//                return Int(tmp[tmp.count-1].time_id)! - Int(tmp[0].time_id)! + 1
                return saveData.filter({$0.day_id == "1"}).count
            case 1:
                return saveData.filter({$0.day_id == "2"}).count
            case 2:
                return saveData.filter({$0.day_id == "3"}).count
            case 3:
                return saveData.filter({$0.day_id == "4"}).count
            case 4:
                return saveData.filter({$0.day_id == "5"}).count
            case 5:
                return saveData.filter({$0.day_id == "6"}).count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubjectCell
        let noClassCell = tableView.dequeueReusableCell(withIdentifier: "noCell") as! NoClassCell
        
        cell.selectionStyle = .none

        var tmpData = saveData.filter({$0.day_id == "1"})

        switch (indexPath.section) {
        case 0:
            tmpData = saveData.filter({$0.day_id == "1"})
        case 1:
            tmpData = saveData.filter({$0.day_id == "2"})
        case 2:
            tmpData = saveData.filter({$0.day_id == "3"})
        case 3:
            tmpData = saveData.filter({$0.day_id == "4"})
        case 4:
            tmpData = saveData.filter({$0.day_id == "5"})
        case 5:
            tmpData = saveData.filter({$0.day_id == "6"})
        default:
            break
        }
        
        tmpData = tmpData.sorted(by: { Int($0.time_id)! < Int($1.time_id)! })
        
//        if indexPath.row+1 < tmpData.count {
//            if Int(tmpData[indexPath.row].time_id)! != Int(tmpData[indexPath.row+1].time_id)! - 1 {
//                tmpData.insert(tmpData[indexPath.row+1], at: indexPath.row+2)
//                return noClassCell
//            }
//        }

        
        cell.teacherNameLabel.text = tmpData[indexPath.row].teacher_id
        cell.subjectNameLabel.text = tmpData[indexPath.row].subject_id
        cell.roomNumberLabel.text = tmpData[indexPath.row].bundle_id
        cell.subjectTypeLabel.text = tmpData[indexPath.row].subject_type_id
        cell.startTimeLabel.text = String(tmpData[indexPath.row].time_value.start_time.dropLast(3))
        cell.endTimeLabel.text = String(tmpData[indexPath.row].time_value.end_time.dropLast(3))
        return cell
    }
    
    func getData() {
        let url = "https://schedulecopy.herokuapp.com/beautifulData"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    guard let result = response.data else { return }
                    let res = try decoder.decode(Data.self, from: result)
                    self.saveData = res.timetable
                    self.stopAnimating()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    self.tableView.reloadData()
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
