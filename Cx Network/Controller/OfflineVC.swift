//
//  OfflineVC.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-06.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import Alamofire

class OfflineVC: UIViewController, UITableViewDelegate ,UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
 
    var cx = [CxNetwork]()
    
    var selectedIndex : NSInteger! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadStreamerDetail {
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        

    }
    

    
    
    func downloadStreamerDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request("\(URL_BASE)\(URL_STREAMER)").responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
            
                if let streamers = dict["streamers"] as? [Dictionary<String, AnyObject>] {
                    for stream in streamers {
                        let cxNetworks = CxNetwork(streamerDict: stream)
                        self.cx.append(cxNetworks)
                    }
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
 
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == selectedIndex{
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        tableView.reloadData()
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex
        {
            return 230
        }else{
            return 130
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? OfflineCell {
            let network = cx[indexPath.row]
            cell.configureCell(cx: network)
            var cellView = UIView()
            cellView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0)
            cell.selectedBackgroundView = cellView
            return cell
        } else {
            return OfflineCell()
        }
    }
    
  
    
}
