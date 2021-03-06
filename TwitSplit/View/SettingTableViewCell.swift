//
//  SettingTableViewCell.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/30/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit
import SnapKit

/// Cell with a switch, used in `SettingViewController`
class SettingTableViewCell: UITableViewCell {
    static let identifier: String = "settingCellIdentifier"
    private var switchControl: UISwitch!
    internal var cellTitle: UILabel!
    private var didSetupConstraints: Bool = false
    
    var switchChanged: ((Bool) -> Void)?
    var switchValue: Bool = false {
        didSet {
            switchControl.isOn = switchValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    @objc private func switchDidChanged(_ sender: UISwitch!) {
        sender.isOn = !sender.isOn
        if let callback = switchChanged {
            callback(sender.isOn)
        }
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        switchControl = UISwitch()
        switchControl.onTintColor = UIColor.black.alpha(0.75)
        switchControl.addTarget(self, action: #selector(switchDidChanged(_:)), for: .valueChanged)
        contentView.addSubview(switchControl)
        
        cellTitle = UILabel()
        cellTitle.numberOfLines = 0
        cellTitle.textAlignment = .left
        cellTitle.lineBreakMode = .byWordWrapping
        cellTitle.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(cellTitle)
    }
    
    override func updateConstraints() {
        guard !didSetupConstraints else {
            super.updateConstraints()
            return
        }
        
        switchControl.snp.makeConstraints { x in
            x.trailing.equalToSuperview().inset(15)
            x.centerY.equalToSuperview()
            x.width.equalTo(50)
        }
        
        cellTitle.snp.makeConstraints { x in
            x.top.leading.equalToSuperview().offset(15)
            x.trailing.equalTo(switchControl.snp.leading).inset(15)
            x.centerY.equalToSuperview()
            x.bottom.equalToSuperview().inset(15)
        }
        
        cellTitle.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        didSetupConstraints = true
        super.updateConstraints()
    }
}
