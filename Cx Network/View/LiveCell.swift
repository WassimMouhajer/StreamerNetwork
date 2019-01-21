//
//  LiveCell.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-07.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class LiveCell: UITableViewCell {
    
    @IBOutlet weak var youtubeLive: YTPlayerView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var amountViewers: UILabel!
    @IBOutlet weak var streamerLive: UILabel!
    
    func configureVideo(cx: CxNetwork) {
        liveView.layer.masksToBounds = true
        liveView.layer.cornerRadius = 15
        amountViewers.layer.cornerRadius = 5
        amountViewers.layer.masksToBounds = true
        
        streamerLive.text = "\(cx.name)"
        amountViewers.text = "\(cx.viewers) watching now"
        DispatchQueue.main.async {
            self.youtubeLive.load(withVideoId: cx.videoId)
        }
        
    }
    
}

