//
//  YouTubeVideoListViewCell.swift
//  YouTubeVideoTagger
//
//  Created by 呂宗錡 on 2018/5/12.
//

import UIKit

class YouTubeVideoListViewCell: UITableViewCell {
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoTumbnailImageView: UIImageView!
    var thumbnailImage: UIImage!
    
    public func updateThumbnailImage(image: UIImage) {
        DispatchQueue.main.async {
            self.thumbnailImage = image
            self.videoTumbnailImageView.image = image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
