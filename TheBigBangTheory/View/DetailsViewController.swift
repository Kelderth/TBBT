//
//  DetailsViewController.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/11/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var vm: TBBTViewModel?
    var episode: Episode!
    var episodeImage: UIImage = UIImage(imageLiteralResourceName: "imageNotAvailable")
    
    var scrollViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var mainViewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var episodeNameConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var episodeImageConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleSeasonTagConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleChapterTagConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleAirDateTagConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleAirTimeTagConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleSummaryTagConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var valueSeasonConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var valueChapterConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var valueAirDateConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var valueAirTimeConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var valueSummaryConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .orange
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var mainViewContent: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.red.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var episodeImageView: UIImageView = {
        let imageContainer = UIImageView()
        imageContainer.contentMode = .scaleAspectFit
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return imageContainer
    }()
    
    lazy var seasonTitleTag: UILabel = {
        let label = UILabel()
        label.text = "SEASON"
        label.layer.borderWidth = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.layer.borderColor = UIColor.green.cgColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var titleChapterTag: UILabel = {
        let label = UILabel()
        label.text = "CHAPTER"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var titleAirDateTag: UILabel = {
        let label = UILabel()
        label.text = "AIR DATE"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var titleAirTimeTag: UILabel = {
        let label = UILabel()
        label.text = "AIR TIME"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var titleSummaryTag: UILabel = {
        let label = UILabel()
        label.text = "SUMMARY"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var valueSeasonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var valueChapterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var valueAirDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var valueAirTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    lazy var valueSummaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        showViews()
        updateView()
        addContraints()
    }
    
    func showViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(mainViewContent)
        mainViewContent.addSubview(episodeTitleLabel)
        mainViewContent.addSubview(episodeImageView)
        mainViewContent.addSubview(seasonTitleTag)
        mainViewContent.addSubview(titleChapterTag)
        mainViewContent.addSubview(valueSeasonLabel)
        mainViewContent.addSubview(valueChapterLabel)
        mainViewContent.addSubview(titleAirDateTag)
        mainViewContent.addSubview(titleAirTimeTag)
        mainViewContent.addSubview(valueAirDateLabel)
        mainViewContent.addSubview(valueAirTimeLabel)
        mainViewContent.addSubview(titleSummaryTag)
        mainViewContent.addSubview(valueSummaryLabel)
    }
    
    func addContraints() {
        let heightConstraint = NSLayoutConstraint(item: mainViewContent, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)
        heightConstraint.priority = .defaultLow
        
        scrollViewConstraints = [
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        mainViewConstraints = [
            NSLayoutConstraint(item: mainViewContent, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainViewContent, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainViewContent, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainViewContent, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0),
            heightConstraint,
            NSLayoutConstraint(item: mainViewContent, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self.view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0.0)
        ]
        NSLayoutConstraint.activate(mainViewConstraints)
        
        episodeNameConstraints = [
            NSLayoutConstraint(item: episodeTitleLabel, attribute: .top, relatedBy: .equal, toItem: mainViewContent, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: episodeTitleLabel, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: episodeTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0),
            episodeTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ]
        NSLayoutConstraint.activate(episodeNameConstraints)
        
        episodeImageConstraints = [
            NSLayoutConstraint(item: episodeImageView, attribute: .top, relatedBy: .equal, toItem: episodeTitleLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: episodeImageView, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: episodeImageView, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: -20),
//            NSLayoutConstraint(item: episodeImageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: scrollView, attribute: .width, multiplier: episodeImage.size.height / episodeImage.size.width, constant: 20),
            episodeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
        ]
        NSLayoutConstraint.activate(episodeImageConstraints)

        titleSeasonTagConstraints = [
            NSLayoutConstraint(item: seasonTitleTag, attribute: .top, relatedBy: .equal, toItem: episodeImageView, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: seasonTitleTag, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seasonTitleTag, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 0.5, constant: 0)
        ]
        NSLayoutConstraint.activate(titleSeasonTagConstraints)
        
        titleChapterTagConstraints = [
            NSLayoutConstraint(item: titleChapterTag, attribute: .top, relatedBy: .equal, toItem: episodeImageView, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleChapterTag, attribute: .leading, relatedBy: .equal, toItem: seasonTitleTag, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: titleChapterTag, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(titleChapterTagConstraints)
        
        valueSeasonConstraints = [
            NSLayoutConstraint(item: valueSeasonLabel, attribute: .top, relatedBy: .equal, toItem: seasonTitleTag, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: valueSeasonLabel, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueSeasonLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 0.5, constant: 0),
        ]
        NSLayoutConstraint.activate(valueSeasonConstraints)

        valueChapterConstraints = [
            NSLayoutConstraint(item: valueChapterLabel, attribute: .top, relatedBy: .equal, toItem: titleChapterTag, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: valueChapterLabel, attribute: .leading, relatedBy: .equal, toItem: valueSeasonLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueChapterLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0),
        ]
        NSLayoutConstraint.activate(valueChapterConstraints)

        titleAirDateTagConstraints = [
            NSLayoutConstraint(item: titleAirDateTag, attribute: .top, relatedBy: .equal, toItem: valueSeasonLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleAirDateTag, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleAirDateTag, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 0.5, constant: 0)
        ]
        NSLayoutConstraint.activate(titleAirDateTagConstraints)
        
        titleAirTimeTagConstraints = [
            NSLayoutConstraint(item: titleAirTimeTag, attribute: .top, relatedBy: .equal, toItem: valueChapterLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleAirTimeTag, attribute: .leading, relatedBy: .equal, toItem: seasonTitleTag, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: titleAirTimeTag, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(titleAirTimeTagConstraints)

        valueAirDateConstraints = [
            NSLayoutConstraint(item: valueAirDateLabel, attribute: .top, relatedBy: .equal, toItem: titleAirDateTag, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: valueAirDateLabel, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueAirDateLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 0.5, constant: 0),
        ]
        NSLayoutConstraint.activate(valueAirDateConstraints)
        
        valueAirTimeConstraints = [
            NSLayoutConstraint(item: valueAirTimeLabel, attribute: .top, relatedBy: .equal, toItem: titleAirTimeTag, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: valueAirTimeLabel, attribute: .leading, relatedBy: .equal, toItem: valueSeasonLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueAirTimeLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0),
        ]
        NSLayoutConstraint.activate(valueAirTimeConstraints)

        titleSummaryTagConstraints = [
            NSLayoutConstraint(item: titleSummaryTag, attribute: .top, relatedBy: .equal, toItem: valueAirDateLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleSummaryTag, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleSummaryTag, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(titleSummaryTagConstraints)

        valueSummaryConstraints = [
            NSLayoutConstraint(item: valueSummaryLabel, attribute: .top, relatedBy: .equal, toItem: titleSummaryTag, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: valueSummaryLabel, attribute: .leading, relatedBy: .equal, toItem: mainViewContent, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: valueSummaryLabel, attribute: .trailing, relatedBy: .equal, toItem: mainViewContent, attribute: .trailing, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: valueSummaryLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: mainViewContent, attribute: .bottom, multiplier: 1, constant: -8)
        ]
        NSLayoutConstraint.activate(valueSummaryConstraints)
    }
    
    func updateView() {
        episodeTitleLabel.text = episode.name
        episodeImageView.image = episodeImage
        valueSeasonLabel.text = #"\#(episode.season)"#
        valueChapterLabel.text = #"\#(episode.chapter)"#
        valueAirDateLabel.text = episode.airDate
        valueAirTimeLabel.text = episode.airTime
        valueSummaryLabel.text = episode.summary.htmlToString
    }

}
