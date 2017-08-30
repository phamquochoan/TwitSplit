//
//  SettingViewController.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/30/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit
import SnapKit

protocol SettingDelegate: class {
    func splitOptionChanged(to option: SplitOption)
}

class SettingViewController: UIViewController {
    private var table: UITableView!
    private var didSetupConstraints: Bool = false
    
    var option: SplitOption!
    weak var delegate: SettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.setNeedsUpdateConstraints()
        
    }
    
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else {
            fatalError("cell not implemented")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        cell.cellTitle.text = row.displayText
        cell.switchValue = option.contains(row.rowOption)
        
        cell.switchChanged = { [unowned self] value in
            if value {
                self.option.insert(row.rowOption)
            } else {
                self.option.remove(row.rowOption)
            }
            
            self.delegate?.splitOptionChanged(to: self.option)
        }
        cell.setNeedsUpdateConstraints()
        return cell
    }
}


// MARK: - ROW
extension SettingViewController {
    
    /// Predefined rows for table view
    enum Row: Int {
        case newLine
        case multipleWhiteSpaces
        
        var rowOption: SplitOption {
            switch self {
            case .newLine:
                return .removeNewLines
                
            case .multipleWhiteSpaces:
                return .removeMultipleWhiteSpaces
            }
        }
        
        var displayText: String {
            switch self {
            case .newLine:
                return "Convert new lines to white spaces"
                
            case .multipleWhiteSpaces:
                return "Convert multiple white spaces to a single one"
            }
        }
    }
}


// MARK: - SETUP VIEWS AND CONSTRAINTS
extension SettingViewController {
    private func setupViews() {
        title = "Setting"
        view.backgroundColor = .white
        setupTableView()
        view.addSubview(table)
    }
    
    override func updateViewConstraints() {
        guard !didSetupConstraints else {
            super.updateViewConstraints()
            return
        }
        
        table.snp.makeConstraints { x in
            x.edges.equalToSuperview()
        }
        
        didSetupConstraints = true
        super.updateViewConstraints()
    }
    
    private func setupTableView() {
        table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor(white: 0.98, alpha: 1)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
}
