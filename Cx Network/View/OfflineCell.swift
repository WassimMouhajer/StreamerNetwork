//
//  OfflineCell.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-07.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit

class OfflineCell: UITableViewCell {

    @IBOutlet weak var offlineImage: UIImageView!
    @IBOutlet weak var offlineNameLbl: UILabel!
    @IBOutlet weak var discordBtn: UIButton!
    @IBOutlet weak var redditBtn: UIButton!
    @IBOutlet weak var streamLabsBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    var discord = ""
    var reddit = ""
    var streamLabs = ""
    var twitter = ""
    var youtube = ""
    
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
    
    
    
    func configureCell(cx: CxNetwork) {
        
        if let socialDiscord = cx.discord as? String {
            discord = socialDiscord
        }
        
        if let socialReddit = cx.reddit as? String {
            reddit = socialReddit
        }
        
        if let socialStreamLabs = cx.streamlabs as? String {
            streamLabs = socialStreamLabs
        }
        
        if let socialTwitter = cx.twitter as? String {
            twitter = socialTwitter
        }
        
        
        if let socialYoutube = cx.youtube as? String {
            youtube = socialYoutube
        }
        
        self.offlineImage.layer.masksToBounds = true
        
        self.offlineImage.layer.cornerRadius = offlineImage.frame.width/2

        self.offlineNameLbl.text = cx.name

        let streamerPictureURL = URL(string: cx.imageURL)!
        
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
                            self.offlineImage.image = image
                            
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
    
}
