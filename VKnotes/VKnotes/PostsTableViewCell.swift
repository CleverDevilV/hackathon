//
//  PostsTableViewCell.swift
//  VKnotes
//
//  Created by Дарья Витер on 16/11/2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit
import WebKit

class PostsTableViewCell: UITableViewCell {
    
    let noteLabel = UILabel()
//    let wedView = WKWebView()
    
    var heightOfNote: CGFloat = 50
    
    var isPicked = false
    
    let noteImage: UIImageView = {
        let image = UIImage(named: "tick")
        let noteImage = UIImageView(image: image)
        return noteImage
    }()
    
    public static let reuseId = "PostCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        noteLabel.numberOfLines = 0
        //        noteLabel.frame = self.contentView.frame
        //        noteLabel.center = self.contentView.center
        noteLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(noteLabel)
        
        contentView.addSubview(noteImage)
        
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func updateConstraints() {
        
        noteImage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 1).isActive  = true
        noteImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
        
        noteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1).isActive = true
        //        noteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1).isActive = true //
        noteImage.trailingAnchor.constraint(equalTo: noteLabel.leadingAnchor, constant: -5).isActive = true
        
        //        noteImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        noteImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noteImage.widthAnchor.constraint(equalTo: noteImage.heightAnchor, constant: 0.0).isActive = true
        
        // ---------------------
        
        //        noteLabel.topAnchor.constraint(equalTo: noteImage.bottomAnchor, constant:  10).isActive = true
        noteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  1).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: noteImage.trailingAnchor, constant: 5).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1).isActive = true
        noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1).isActive = true
        
        let heightForContentView = noteLabel.heightAnchor.constraint(equalToConstant: heightOfNote)
        heightForContentView.priority = UILayoutPriority(rawValue: 999)
        heightForContentView.isActive = true
        
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    
    
    
}
