//
//  ViewController.swift
//  YouTubeVideoTagger
//
//  Created by 呂宗錡 on 2018/5/11.
//

import UIKit
import FirebaseMLVision

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YouTubeVideoListQueryCallback {
    @IBOutlet weak var videoListView: UITableView!
    @IBOutlet weak var tagLabel: UILabel!
    var videoQueryWorker: YouTubeVideoListQueryWorker?
    var videoQueryResult: YouTubeVideoListModel?
    var labelDetector: VisionLabelDetector?
    lazy var vision: Vision = Vision.vision()

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uiImage = (tableView.cellForRow(at: indexPath) as! YouTubeVideoListViewCell).thumbnailImage
        
        if uiImage != nil {
            let vImage = VisionImage(image: uiImage!)
            self.labelDetector?.detect(in: vImage) {
                (labels, error) in
                guard error == nil, let labels = labels, !labels.isEmpty else {
                    return
                }
                
                var tagString = ""
                
                for label in labels {
                    tagString.append(label.label)
                    tagString.append(", ")
                }
                
                self.tagLabel.text = tagString
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoQueryResult != nil {
            return (self.videoQueryResult?.videoInfos.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListViewCell", for: indexPath) as! YouTubeVideoListViewCell
        cell.videoTitleLabel.text = self.videoQueryResult?.videoInfos[indexPath.row].title
        
        if cell.thumbnailImage == nil {
            DispatchQueue.global().async {
                let imageData = try? Data(contentsOf: (self.videoQueryResult?.videoInfos[indexPath.row].thumbnailURLs)!)
                
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    cell.updateThumbnailImage(image: image!)
                }
            }
        }
        
        return cell
    }

    func onVideoListQueried(videoList: YouTubeVideoListModel) {
        self.videoQueryResult = videoList
        
        DispatchQueue.main.async {
            self.videoListView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "YouTubeVideoListViewCell", bundle: nil)
        self.videoListView.register(nib, forCellReuseIdentifier: "VideoListViewCell")
        self.videoQueryWorker = YouTubeVideoListQueryWorker()
        self.videoQueryWorker?.videoQueryObservers.append(self)
        self.videoListView.dataSource = self
        self.videoListView.delegate = self
        self.videoQueryWorker?.queryVideoList()
        
        self.labelDetector = vision.labelDetector()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
