//
// ViewControllerOK1.swift
// 
//
// Copyright (c) 2020 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

class ViewControllerOK1: UITableViewController {
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = user.name
            return cell
        })
        
        let button = UIBarButtonItem(title: "Button", style: .plain, target: self, action: #selector(handleButton))
        navigationItem.rightBarButtonItem = button
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.first])
        snapshot.appendItems([
            .init(id: 1, name: "Henry"),
            .init(id: 2, name: "Thomas"),
            .init(id: 3, name: "Percy"),
        ], toSection: .first)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc
    func handleButton() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.first])
        snapshot.appendItems([
            .init(id: 1, name: "Henry"),
            .init(id: 2, name: "Tommy"),    // be modified
            .init(id: 3, name: "Percy"),
        ], toSection: .first)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private enum Section: Hashable {
    case first
}

private struct User: Hashable {
    let id: Int
    let name: String
}
