//
//  CxNetwork.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-06.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import Foundation
import Alamofire

class CxNetwork {
    
    private var _twitter: String!
    private var _reddit: String!
    private var _streamlabs: String!
    private var _youtube: String!
    private var _discord: String!
    
    private var _name: String!
    
    private var _liveData: Bool!
    private var _viewers: Int!
    private var _videoId: String!
    private var _chatID: String!
    private var _imageURL: String!
    
    var chatId: String {
        if _chatID == nil {
            _chatID = ""
        }
        return _chatID
    }
    
    var videoId: String {
        if _videoId == nil {
            _videoId = ""
        }
        return _videoId
    }
    
    var viewers: Int {
        if _viewers == nil {
            _viewers = 0
        }
        return _viewers
    }
    
    
    var twitter: String {
        if _twitter == nil {
            _twitter = ""
        }
        return _twitter
        
    }
    
    var reddit: String {
        if _reddit == nil {
            _reddit = ""
        }
        return _reddit
        
    }
    
    var streamlabs: String {
        if _streamlabs == nil {
            _streamlabs = ""
        }
        return _streamlabs
        
    }
    
    var youtube: String {
        if _youtube == nil {
            _youtube = ""
        }
        return _youtube
        
    }
    
    var discord: String {
        if _discord == nil {
            _discord = ""
        }
        return _discord
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        
        return _name
    }
    
    var liveData: Bool {
        if _liveData == nil {
            _liveData = false
        }
        return _liveData
    }
    
    var imageURL: String {
        if _imageURL == nil {
            _imageURL = ""
        }
        return _imageURL
    }
    
    init() {
        
    }
    
    init(streamerDict: Dictionary<String,AnyObject>) {
        
        if let streamerName = streamerDict["name"] as? String {
            self._name = streamerName
        }
        
        
        if let socials = streamerDict["socials"] as? Dictionary<String,String> {
            
            if let socialTwitter = socials["twitter"] {
                self._twitter = socialTwitter
                
                
            }
            
            if let socialYoutube = socials["yt"] {
                self._youtube = socialYoutube
            }
            
            if let socialDiscord = socials["discord"] {
                self._discord = socialDiscord
            }
            
            if let socialReddit = socials["reddit"]  {
                self._reddit = socialReddit
            }
            
            if let socialDonate = socials["donate"] {
                self._streamlabs = socialDonate
            }
            
        }
        
        if let isLive = streamerDict["liveData"] as? Dictionary<String, AnyObject> {
            if let live = isLive["live"] as? Bool {
                self._liveData = live
            }
            
            if let viewer = isLive["viewers"] as? Int {
                self._viewers = viewer
            }
            
            if let chatIden = isLive["chatId"] as? String {
                self._chatID = chatIden
            }
            
            if let videoIden = isLive["videoId"] as? String {
                self._videoId = videoIden
            }
            
        }
        
        
        if let images = streamerDict["images"] as? Dictionary<String,AnyObject> {
            
            if let avatars = images["avatars"] as? Dictionary<String,AnyObject> {
                
                
                if let defaults = avatars["default"] as? Dictionary<String,AnyObject> {
                    
                    if let url = defaults["url"] as? String {
                        self._imageURL = url
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}
