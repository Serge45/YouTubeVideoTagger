//
//  TagCollectionViewCell.swift
//  YouTubeVideoTagger
//
//  Created by 呂宗錡 on 2018/5/19.
//

import UIKit

@IBDesignable
class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.black
        self.tagLabel.textColor = UIColor.white
    }

}
