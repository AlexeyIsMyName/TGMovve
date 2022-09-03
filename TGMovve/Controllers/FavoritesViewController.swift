//
//  FavoritesViewController.swift
//  TGMovve
//
//  Created by Anton Ermokhin on 01.09.2022.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    var contentList = [Content]()
    
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
            DispatchQueue.global().async {
                URLManager.get.smallImageFor(posterURL) { imageURL in
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    DispatchQueue.main.async {
                        cell.posterImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: nil)
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
    
    
    // MARK: - Core Data method
    func loadContent() {
        if let contentList = ContextManager.shared.fetchContents() {
            self.contentList = contentList
        }
    }
    
    
    // MARK: - Deleting Cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ContextManager.shared.delete(content: contentList[indexPath.row])
            contentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
