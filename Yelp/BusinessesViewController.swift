//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]! {
        didSet {
            searchFilter(searchText: searchBar.text ?? "")
        }
    }
    
    let searchBar = UISearchBar()
    var searchActive = false
    var filteredBusinesses: [Business]!
    var settingFilters: [String: AnyObject] = [String: AnyObject]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        searchBar.delegate = self
        filteredBusinesses = []
        settingFilters = [:]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        if settingFilters.count == 0 {
            settingFilters["deal_filter"] = false as AnyObject?
            settingFilters["distance_filter_index"] = 0 as AnyObject?
            settingFilters["sort_filter"] = 0 as AnyObject?
            settingFilters["sort_filter_index"] = 0 as AnyObject?
            settingFilters["distance_filter"] = 0.0 as AnyObject?
        }
        updateFilter(filters: settingFilters)
    }
    
    func pullDownToRefresh() {
        self.updateFilter(filters: self.settingFilters)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? BusinessCell
        cell?.business = businesses[indexPath.row]
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let filtersViewController = navigationController?.topViewController as? FiltersViewController
        filtersViewController?.settingfilters = settingFilters
        filtersViewController?.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        self.settingFilters = filters
        updateFilter(filters: filters)
    }
    
    func updateFilter(filters: [String: AnyObject]) {
        let deals = filters["deal_filter"]  as? Bool
        let sort = filters["sort_filter"] as? Int
        let categories = filters["categories_filter"] as? [String: String] ?? [String: String]()
        
        let selectedCategories = categories.map {$0.value}
        var distance = filters["distance_filter"] as? Double ?? 0
        distance = distance * 1609.344
        Business.searchWithTerm(term: "Restaurant", sort: YelpSortMode(rawValue: sort!) , categories: selectedCategories, deals: deals, radius: distance) {[weak self] (businesses:[Business]?, error: Error?) in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
            
            self?.businesses = businesses ?? []
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFilter(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchFilter(searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({ (business: Business) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return business.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || business.categories?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || business.address?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
            if searchText != ""
            {
                searchActive = true
            }
            else {
                searchActive = false
            }
            self.tableView.reloadData()
        }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
