//
//  ArticlesViewController.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import UIKit

class ArticlesViewController: UITableViewController {

    // MARK: - Outlets
    
    // MARK: - Properties
    
    var model = ArticlesViewControllerModel()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add pull-to-refresh capability, ensuring that the control is under the table
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -1
        
        loadData()
    }
    
    // MARK: - Actions
    
    /**
     * Load the data for this VC asynchronously
     */
    func loadData() {
        API.getArticles { [self] (result) in
            switch result {
            case .failure(let error):
                print("failure: \(error.description)")
            case .success(let articles):
                print("success")
                self.model.updateArticles(articles)
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    if refreshControl?.isRefreshing ?? false {
                        refreshControl?.endRefreshing()
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    /**
     * Called by the table pull-to-refresh
     */
    @objc private func refresh(_ sender: AnyObject) {
        loadData()
    }
}

// MARK: - <UITableViewDelegate>

extension ArticlesViewController {
    
}

// MARK: - <UITableViewDataSource>

extension ArticlesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.articles == nil ? 0 : 7 // hardcoded
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let articles = model.articles else {
            return 0
        }
                
        switch ArticlesSection(rawValue: section) {
        case .breakingNews:
            return articles.breakingNews?.count ?? 0
        case .topNews:
            return articles.topNews?.count ?? 0
        case .techicalkAnalysis:
            return articles.technicalAnalysis?.count ?? 0
        case .specialReport:
            return articles.specialReport?.count ?? 0
        case .dailyBriefingsEU:
            return articles.dailyBriefings?.eu?.count ?? 0
        case .dailyBriefingsAsia:
            return articles.dailyBriefings?.asia?.count ?? 0
        case .dailyBriefingsUS:
            return articles.dailyBriefings?.us?.count ?? 0
        case .none:
            fatalError("Unexpected market section")
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        guard let articles = model.articles,
              let cell = tableView.dequeueReusableCell(
                withIdentifier: "ArticleCell",
                for: indexPath) as? ArticleCell
        else {
            return UITableViewCell()
        }
    
        let articlesData: [Article]
        
        switch ArticlesSection(rawValue: indexPath.section) {
        case .breakingNews:
            articlesData = articles.breakingNews ?? []
        case .topNews:
            articlesData = articles.topNews ?? []
        case .techicalkAnalysis:
            articlesData = articles.technicalAnalysis ?? []
        case .specialReport:
            articlesData = articles.specialReport ?? []
        case .dailyBriefingsEU:
            articlesData = articles.dailyBriefings?.eu ?? []
        case .dailyBriefingsAsia:
            articlesData = articles.dailyBriefings?.asia ?? []
        case .dailyBriefingsUS:
            articlesData = articles.dailyBriefings?.us ?? []
        case .none:
            fatalError("Unexpected market section")
        }

        let article = articlesData[indexPath.row]
        
        cell.title.text = article.articleDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard var text = ArticlesSection(rawValue: section)?.displayValue else {
            return "Unknown Article Type"
        }
        
        var count: Int?
        
        if let articles = model.articles {
            
            switch ArticlesSection(rawValue: section) {
            case .breakingNews:
                count =  articles.breakingNews?.count ?? 0
            case .topNews:
                count =  articles.topNews?.count ?? 0
            case .techicalkAnalysis:
                count =  articles.technicalAnalysis?.count ?? 0
            case .specialReport:
                count =  articles.specialReport?.count ?? 0
            case .dailyBriefingsEU:
                count =  articles.dailyBriefings?.eu?.count ?? 0
            case .dailyBriefingsAsia:
                count =  articles.dailyBriefings?.asia?.count ?? 0
            case .dailyBriefingsUS:
                count =  articles.dailyBriefings?.us?.count ?? 0
            case .none:
                fatalError("Unexpected market section")
            }
        }
        
        if let count = count {
            text += " (\(count) items)"
        }
        
       return text
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}


