//
//  YouTubeVideoListQueryWorker.swift
//  YouTubeVideoTagger
//
//  Created by 呂宗錡 on 2018/5/11.
//

import Foundation

class YouTubeVideoListQueryWorker {
    enum QueryType {
        case mostPopular
    }
    
    fileprivate let apiKey: String
    fileprivate var lastUsedQueryString: String = ""
    fileprivate var queryType: QueryType = QueryType.mostPopular
    
    public var videoQueryObservers: [YouTubeVideoListQueryCallback] = []
    
    init() {
        let dataApiKeyURL = Bundle.main.url(forResource: "youtube-data-api-key", withExtension: "txt")
        
        do {
            self.apiKey = try String(contentsOf: dataApiKeyURL!)
        } catch {
            apiKey = ""
            print("YouTube data key not found")
        }
    }
    
    deinit {
        self.videoQueryObservers.removeAll()
    }
    
    fileprivate func buildQueryString() -> String {
        return String(format: "https://www.googleapis.com/youtube/v3/videos?part=%@&chart=%@&maxResults=%d&fields=items(id,snippet(thumbnails/maxres,title))&key=%@",
            "snippet", "mostPopular", 10, self.apiKey)
    }
    
    func queryVideoList() {
        switch self.queryType {
        case .mostPopular:
            self.lastUsedQueryString = self.buildQueryString()
            let task = URLSession.shared.dataTask(with: URL(string: self.lastUsedQueryString)!) {
                (data, response, error) in
                if error == nil {
                    let videoList = YouTubeVideoListModel(jsonData: data!)
                    
                    for ob in self.videoQueryObservers {
                        ob.onVideoListQueried(videoList: videoList)
                    }
                }
            }
            task.resume()
        }
    }
}
