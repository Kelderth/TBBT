//
//  ItemTableViewCell.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/9/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

@IBDesignable class ItemTableViewCell: UITableViewCell {

    var chapterLabelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var chapterNameConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var chapterImageConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var activityIndicatorConstraint: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    lazy var chapterNumberLabel: UILabel = {
        let chapterNumberLabel = UILabel()
        chapterNumberLabel.text = #"Default"#
        chapterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return chapterNumberLabel
    }()
    
    lazy var chapterNameLabel: UILabel = {
        let label = UILabel()
        label.text = #"Default"#
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var chapterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        activityIndicator.color = .orange
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(chapterImage)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(chapterNumberLabel)
        self.contentView.addSubview(chapterNameLabel)

        constrainLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constrainLabel() {
        chapterImageConstraints = [
            NSLayoutConstraint(item: chapterImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: chapterImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8),
            chapterImage.heightAnchor.constraint(equalToConstant: 80),
            chapterImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(chapterImageConstraints)
        
        activityIndicatorConstraint = [
            activityIndicator.centerXAnchor.constraint(equalTo: chapterImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: chapterImage.centerYAnchor)
        ]
        NSLayoutConstraint.activate(activityIndicatorConstraint)
        
        chapterLabelConstraints = [
            NSLayoutConstraint(item: chapterNumberLabel, attribute: .top, relatedBy: .equal, toItem: chapterImage, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chapterNumberLabel, attribute: .leading, relatedBy: .equal, toItem: chapterImage, attribute: .trailing, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: chapterNumberLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)
        ]
        NSLayoutConstraint.activate(chapterLabelConstraints)
        
        chapterNameConstraints = [
            NSLayoutConstraint(item: chapterNameLabel, attribute: .top, relatedBy: .equal, toItem: chapterNumberLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: chapterNameLabel, attribute: .leading, relatedBy: .equal, toItem: chapterImage, attribute: .trailing, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: chapterNameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)
        ]
        NSLayoutConstraint.activate(chapterNameConstraints)
    }
}
