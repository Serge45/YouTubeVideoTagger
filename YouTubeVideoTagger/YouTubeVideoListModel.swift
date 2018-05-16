//
//  YouTubeVideoListModel.swift
//  YouTubeVideoTagger
//
//  Created by 呂宗錡 on 2018/5/11.
//

import Foundation

class YouTubeVideoListModel {
    struct VideoInfo {
        var id: String
        var title: String
        var thumbnailURLs: URL?
        var thumbnailWidth: Int
        var thumbnailSize: Int
    }
    
    private(set) var videoInfos: [VideoInfo] = []

    init(jsonData: Data) {
        var items: [[String:Any]] = []
        
        if let decodedObj = try? JSONSerialization.jsonObject(with: jsonData) as! [String: Any] {
            items = decodedObj["items"] as! [[String:Any]]
        }
        
        for item in items {
            let id = item["id"] as! String
            
            let snippet = item["snippet"] as! [String:Any]
            let title = snippet["title"] as! String
            
            if snippet["thumbnails"] != nil {
                let thumbnails = snippet["thumbnails"] as! [String:Any]
            
                let bestThumbnail = thumbnails["maxres"] as! [String:Any]
    
                let thumbnailURLString = bestThumbnail["url"] as! String
                let thumbnailWidth = bestThumbnail["width"] as! Int
                let thumbnailHeight = bestThumbnail["height"] as! Int
    
                self.videoInfos.append(VideoInfo(id: id,
                                                 title: title,
                                                 thumbnailURLs: URL(string: thumbnailURLString),
                                                 thumbnailWidth: thumbnailWidth,
                                                 thumbnailSize: thumbnailHeight))
            }
        }
    }
}
