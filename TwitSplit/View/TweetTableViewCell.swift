//
//  TweetTableViewCell.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/30/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit
import SnapKit

/// Display a `Tweet` content.
class TweetTableViewCell: UITableViewCell {
    static let identifier: String = "tweetCellIdentifier"
    private var counterLabel: UILabel!
    private var contentLabel: UILabel!
    
    private var didSetupConstraints: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setContent(_ content: String) {
        counterLabel.text = String(content.count)
        contentLabel.text = content
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        counterLabel = UILabel()
        counterLabel.numberOfLines = 1
        counterLabel.textAlignment = .left
        counterLabel.lineBreakMode = .byWordWrapping
        counterLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(counterLabel)
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textAlignment = .left
        contentLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
    }
    
    override func updateConstraints() {
        guard !didSetupConstraints else {
            super.updateConstraints()
            return
        }
        
        counterLabel.snp.makeConstraints { x in
            x.leading.equalToSuperview().offset(10)
            x.centerY.equalToSuperview()
            x.width.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints { x in
            x.leading.equalTo(counterLabel.snp.trailing).offset(15)
            x.trailing.equalToSuperview().inset(15)
//            x.centerY.equalToSuperview()
            x.top.equalToSuperview().offset(10)
            x.bottom.equalToSuperview().offset(-10)
        }
        
        contentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        didSetupConstraints = true
        super.updateConstraints()
    }
}
