//
//  ArticlesViewControllerModel.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import Foundation

struct ArticlesViewControllerModel {
    var articles: Articles? = nil
    
    /**
     * Trivial setter method
     */
    mutating func updateArticles(_ articles: Articles) {
        self.articles = articles
    }
}
