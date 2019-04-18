//
//  ShowViewController.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/7/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

@IBDesignable
class ShowViewController: UIViewController {
    
    let vm = TBBTViewModel()
    
    var tableViewSetConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    @IBInspectable lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        vm.downloadJSON {
            DispatchQueue.main.async {
                self.vm.setEpisodes()
                print("=================================")
                print(#"Number of Seasons: \#(self.vm.getNumberOfSeasons())"#)
                print("=================================")
                self.tableView.reloadData()
            }
        }
        
        showViews()
        addConstraints()
    }

    func showViews() {
        self.view.addSubview(tableView)
    }
    
    func addConstraints() {
        tableViewSetConstraints = [
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        ]
        NSLayoutConstraint.activate(tableViewSetConstraints)
    }
    
    func confirmLogout() {
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endSession(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ending Session", message: "Do you want to end your session?", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionConfirm = UIAlertAction(title: "End Session", style: .default) { (UIAlertAction) in
            self.confirmLogout()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionConfirm)
        self.present(alert, animated: true)
    }
}

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.getNumberOfSeasons()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section  = section + 1
        return "Season \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getNumberOfChapters(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemTableViewCell else { return UITableViewCell() }
        
        cell.chapterNumberLabel.text = #"Chapter \#(indexPath.row + 1)"#
        cell.chapterNameLabel.text = vm.getChapterTitle(season: indexPath.section, chapter: indexPath.row)
        if let imageURL = vm.getChapterImage(season: indexPath.section, chapter: indexPath.row) {
            cell.activityIndicator.startAnimating()
            vm.downloadImage(from: imageURL) { (image) in
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.chapterImage.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.episode = vm.getEpisodeInfo(season: indexPath.section, chapter: indexPath.row)
        if let imageURL = vm.getChapterImage(season: indexPath.section, chapter: indexPath.row) {
            vm.downloadImage(from: imageURL, completion: { (image) in
                if let image = image {
                    vc.episodeImage = image
                }
            })
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
