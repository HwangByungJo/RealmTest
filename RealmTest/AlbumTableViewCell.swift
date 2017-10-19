//
//  AlbumTableViewCell.swift
//  RealmTest
//
//  Created by Pang on 2017. 10. 18..
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        photo.image = UIImage(named: "album_placeholder")
    }

}
