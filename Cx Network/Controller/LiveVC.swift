//
//  LiveVC.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-05.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import Alamofire

class LiveVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var isOfflineLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var liveTab: UITabBarItem!
    
    var cx = [CxNetwork]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        tableView.rowHeight = 250
        self.downloadStreamerDetail {
        
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(LiveVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white ]
        refreshControl.attributedTitle = NSAttributedString(string: "Looking for streamers...", attributes: attributes)
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        cx.removeAll()
        self.downloadStreamerDetail {
            
        }
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func downloadStreamerDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request("\(URL_BASE)\(URL_STREAMER)").responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                //                self.cx.sorted(by: {$0.viewers > $1.viewers})
                if let streamers = dict["streamers"] as? [Dictionary<String, AnyObject>] {
                    for stream in streamers {
                        let cxNetworks = CxNetwork(streamerDict: stream)
                        
                        if cxNetworks.liveData == true {
                            self.cx.append(cxNetworks)
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
            if self.cx.count == 0 {
                self.isOfflineLbl.isHidden = false
            } else {
                self.isOfflineLbl.isHidden = true
            }
            
            completed()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.liveTab.badgeValue = "\(cx.count)"
        return cx.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell") as? LiveCell {
            let cxNetworks = cx[indexPath.row]
            cell.configureVideo(cx: cxNetworks)
            return cell
        } else {
            return LiveCell()
        }
        
    }
    

}

