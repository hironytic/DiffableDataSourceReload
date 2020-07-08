//
// ViewControllerOK2.swift
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

class ViewControllerOK2: UITableViewController {
    private var dataSource: UITableViewDiffableDataSource<Section, UserID>!
    private var users: [UserID: User] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = [
            UserID(id: 1): User(name: "Henry"),
            UserID(id: 2): User(name: "Thomas"),
            UserID(id: 3): User(name: "Percy"),
        ]
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, userID) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.users[userID]?.name
            return cell
        })
        
        let button = UIBarButtonItem(title: "Button", style: .plain, target: self, action: #selector(handleButton))
        navigationItem.rightBarButtonItem = button
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserID>()
        snapshot.appendSections([.first])
        snapshot.appendItems([
            .init(id: 1),
            .init(id: 2),
            .init(id: 3),
        ], toSection: .first)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc
    func handleButton() {
        let userID = UserID(id: 2)
        users[userID] = User(name: "Tommy")
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([userID])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private enum Section: Hashable {
    case first
}

private struct UserID: Hashable {
    let id: Int
}

private struct User {
    let name: String
}
