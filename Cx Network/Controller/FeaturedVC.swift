//
//  FeatureVC.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-05.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import Alamofire
import youtube_ios_player_helper

class FeaturedVC: UIViewController {
    
    @IBOutlet weak var featuredNameLbl: UILabel!
    @IBOutlet weak var viewersLbl: UILabel!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var youtubeView: YTPlayerView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var isOnline: UILabel!
    
    @IBOutlet weak var youtubeBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var streamLabsBtn: UIButton!
    @IBOutlet weak var redditBtn: UIButton!
    @IBOutlet weak var discordBtn: UIButton!
    var cx = [CxNetwork]()
    var bestCx = CxNetwork()
    var discord = ""
    var reddit = ""
    var streamLabs = ""
    var twitter = ""
    var youtube = ""
    
    override func viewDidAppear(_ animated: Bool) {
        if isInternetAvailable() == false {
            var refreshAlert = UIAlertController(title: "Connection Error", message: "Check your internet connection and try again.", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        prepareView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveView.layer.masksToBounds = true
        liveView.layer.cornerRadius = 15
    }
    
    
    func downloadStreamerDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request("\(URL_BASE)\(URL_STREAMER)").responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let streamers = dict["streamers"] as? [Dictionary<String, AnyObject>] {
                    for stream in streamers {
                        let cxNetworks = CxNetwork(streamerDict: stream)
                        if cxNetworks.liveData == true {
                            self.cx.append(cxNetworks)
                            if let highestStream = self.cx.max(by: { $0.viewers < $1.viewers }) {
                                self.bestCx = highestStream
                            }
                        }
                        
                    }
                }
            }
            completed()
        }
    }
    
    func prepareView() {
        downloadStreamerDetail {
            
            DispatchQueue.main.async {
                self.youtubeView.load(withVideoId: self.bestCx.videoId)
            }
            
            self.viewersLbl.text = "\(self.bestCx.viewers) watching now"
            self.featuredNameLbl.text = self.bestCx.name
            
            self.profileImage.layer.masksToBounds = true
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
            
            if self.featuredNameLbl.text == "" {
                self.isOnline.isHidden = false
                self.discordBtn.isHidden = true
                self.redditBtn.isHidden = true
                self.streamLabsBtn.isHidden = true
                self.twitterBtn.isHidden = true
                self.youtubeBtn.isHidden = true
                self.liveView.isHidden = true
            } else {
                self.liveView.isHidden = false
                self.isOnline.isHidden = true
                self.discordBtn.isHidden = false
                self.redditBtn.isHidden = false
                self.streamLabsBtn.isHidden = false
                self.twitterBtn.isHidden = false
                self.youtubeBtn.isHidden = false
                let streamerPictureURL = URL(string: self.bestCx.imageURL)!
                
                // Creating a session object with the default configuration.
                let session = URLSession(configuration: .default)
                
                // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                let downloadPicTask = session.dataTask(with: streamerPictureURL) { (data, response, error) in
                    // The download has finished.
                    if let e = error {
                        print("error: \(e)")
                    } else {
                        // No errors found.
                        // It would be weird if we didn't have a response, so check for that too.
                        if let res = response as? HTTPURLResponse {
                            
                            if let imageData = data {
                                // Finally convert that Data into an image and do what you wish with it.
                                DispatchQueue.main.async {
                                    
                                    let image = UIImage(data: imageData)
                                    self.profileImage.image = image
                                    
                                }
                                
                            } else {
                                print("Couldn't get image: Image is nil")
                            }
                        } else {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
                
                downloadPicTask.resume()
            }
            self.discord = self.bestCx.discord
            self.reddit = self.bestCx.reddit
            self.streamLabs = self.bestCx.streamlabs
            self.twitter = self.bestCx.twitter
            self.youtube = self.bestCx.youtube
            
        }
    }
    
    @IBAction func openDiscord(_ sender: UIButton) {
        guard let url = URL(string: "https://discordapp.com/invite/\(discord)") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openReddit(_ sender: UIButton) {
        guard let url = URL(string: "https://www.reddit.com/r/\(reddit)") else {
            return
        }
        print(reddit)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openStreamLabs(_ sender: UIButton) {
        if streamLabs == "" {
            streamLabs = "https://streamlabs.com/"
        }
        guard let url = URL(string: "\(streamLabs)") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openTwitter(_ sender: UIButton) {
        guard let url = URL(string: "https://twitter.com/\(twitter)") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openYoutube(_ sender: UIButton) {
        guard let url = URL(string: "https://www.youtube.com/channel/\(youtube)") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
}

