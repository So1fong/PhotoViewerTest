//
//  PhotoCollectionViewCell.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    let photoImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let idLabel: UILabel =
    {
        let label = UILabel()
        label.text = "id"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    func setup()
    {
        self.addSubview(photoImageView)
        self.addSubview(idLabel)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10).isActive = true
        idLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        idLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        idLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
