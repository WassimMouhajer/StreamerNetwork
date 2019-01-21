//
//  ChatVC.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-10.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import Alamofire
import youtube_ios_player_helper

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoView: YTPlayerView!
    @IBOutlet weak var backButton: UIButton!
    
    var chatCx = [CxChat]()
    var numMessages = 0
    var videoId = ""
    var chatId = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 1, "autoplay": 1, "modestbranding": 1]
        videoView.load(withVideoId: videoId, playerVars: playvarsDic)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateChat), userInfo: nil, repeats: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    
    @objc func updateChat() {
        downloadChatMessages {
            self.chatCx.reverse()
        }
    }
    
    func downloadChatMessages(completed: @escaping DownloadComplete) {
        
        let parameters = ["part":"snippet","key":API_KEY,"liveChatId":chatId]
        
        Alamofire.request(URL_LIST, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON { response in
            self.chatCx.removeAll()
            self.tableView.reloadData()
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let items = dict["items"] as? [Dictionary<String,AnyObject>] {
                    for item in items {
                        var chat = CxChat(chatDict: item)
                        self.chatCx.append(chat)
                    }
                    self.tableView.reloadData()
                }
            }
            completed()
        }
        
    }
    
    func addChat() {
        
        let params: [String : String] =
            ["part" : "snippet",
                "key" : API_KEY,
                "liveChatId" : chatId,
                "type" : "textMessageEvent"
        ]
        
        let url = "https://www.googleapis.com/youtube/v3/liveChat/messages"
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in params
                {
                    
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                    }
                    upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                        
                        
                    })
                    
                case .failure(let encodingError): break
                    
                }
        }
        )
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatCx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatCell {
            let cx = chatCx[indexPath.row]
            cell.configureChat(chat: cx)
            return cell
        } else {
            return ChatCell()
        }
        
    }
    
    
    @IBAction func returnToLive(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    
}
