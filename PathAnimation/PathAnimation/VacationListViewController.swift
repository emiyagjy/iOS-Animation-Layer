//
//  VacationListViewController.swift
//  PathAnimation
//
//  Created by GujyHy on 2018/1/11.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit
func delay(_ seconds:Double,completion:@escaping ()->()){
    let dispatchTime = DispatchTime.now() + seconds
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        completion()
    })
}

let kRefreshViewHeight: CGFloat = 110.0
let packItems = ["Icecream money", "Great weather",
                 "Beach ball", "Swim suit for him",
                 "Swim suit for her", "Beach games",
                 "Ironing board", "Cocktail mood",
                 "Sunglasses", "Flip flops"]

class VacationListViewController: UITableViewController,RefreshViewDelegate {

    var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacation pack list"
        self.view.backgroundColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        self.tableView.rowHeight = 64.0
        
        let refreshRect = CGRect(x: 0.0, y: -kRefreshViewHeight, width: view.frame.size.width, height: kRefreshViewHeight)
        refreshView = RefreshView(frame: refreshRect, scrollView: self.tableView)
        refreshView.delegate = self
        view.addSubview(refreshView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Scroll view methods
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // MARK: Table View methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel!.text = packItems[indexPath.row]
        cell.imageView!.image = UIImage(named: "summericons_100px_0\(indexPath.row).png")
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: RefreshViewDelegate
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delay(4) {
            refreshView.endRefreshing()
        }
    }

}

