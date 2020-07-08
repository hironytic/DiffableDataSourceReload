//
// ViewControllerOK3.swift
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

class ViewControllerOK3: UITableViewController {
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = user.info.name
            return cell
        })
        
        let button = UIBarButtonItem(title: "Button", style: .plain, target: self, action: #selector(handleButton))
        navigationItem.rightBarButtonItem = button
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.first])
        snapshot.appendItems([
            .init(id: 1, info: .init(name: "Henry")),
            .init(id: 2, info: .init(name: "Thomas")),
            .init(id: 3, info: .init(name: "Percy")),
        ], toSection: .first)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc
    func handleButton() {
        var snapshot = dataSource.snapshot()
        
        guard let user = snapshot.itemIdentifiers(inSection: .first).first(where: { $0.id == 2 }) else { return }
        user.info.name = "Tommy"
        
        snapshot.reloadItems([user])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private enum Section: Hashable {
    case first
}

private struct User: Hashable {
    let id: Int

    class Info {
        var name: String
        init(name: String) {
            self.name = name
        }
    }
    let info: Info

    init(id: Int, info: Info) {
        self.id = id
        self.info = info
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
