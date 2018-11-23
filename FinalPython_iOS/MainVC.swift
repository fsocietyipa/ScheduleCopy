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
import Intents

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, Dateble {

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
        configSiri()
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

        if self.checkTimeRange() == Int(tmpData[indexPath.row].time_id) && self.getDayOfWeek() == Int(tmpData[indexPath.row].day_id)!  {
            cell.statusView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            cell.statusView.isHidden = false
            cell.statusLabel.text = "Now"
        }
        else if self.checkTimeRange() == Int(tmpData[indexPath.row].time_id)! - 1 && self.getDayOfWeek() == Int(tmpData[indexPath.row].day_id)!  {
            cell.statusView.isHidden = false
            cell.statusLabel.text = "Next"
        }
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
    
    func configSiri() {
        let intent = LessonNowIntent()
        
        intent.suggestedInvocationPhrase = "What lesson is now"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
        
        let intent1 = LessonNextIntent()
        
        intent1.suggestedInvocationPhrase = "What lesson is next"
        
        let interaction1 = INInteraction(intent: intent1, response: nil)
        
        interaction1.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
        
        let intent2 = LessonCalendarIntent()
        
        intent2.suggestedInvocationPhrase = "What is the"
        intent2.sequencing = "first"
        intent2.dayOfWeek = "Saturday"
        let interaction2 = INInteraction(intent: intent2, response: nil)
        
        interaction2.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
    
    @IBAction func addToSiri(_ sender: Any) {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .authorized:
                print("We have access!")
            default:
                print("Not granted")
                break
            }
        }
    }
}
