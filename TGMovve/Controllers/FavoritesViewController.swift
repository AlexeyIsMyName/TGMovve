//
//  FavoritesViewController.swift
//  TGMovve
//
//  Created by Anton Ermokhin on 01.09.2022.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    
    // MARK: - Private Properties
    private var contentList = [Content]()
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
        tableView.reloadData()
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let infoScreenVC = segue.destination as? InfoScreenViewController else { return }
        let content = contentList[indexPath.item]
        infoScreenVC.prepareWith(content)
    }
    
    
    // MARK: - Private Methods
    private func loadContent() {
        if let contentList = ContextManager.shared.fetchContents() {
            self.contentList = contentList
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! FavoriteCell
        
        let content = contentList[indexPath.row]
        
        cell.titleLabel.text = content.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:content.releaseData!)
        
        if let date = date {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let posterURL = content.posterPath {
            ImageManager.shared.fetchImegeOf(size: .small, from: posterURL) { image in
                cell.posterImage.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ContextManager.shared.delete(content: contentList[indexPath.row])
            contentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: nil)
    }
    
    
}
