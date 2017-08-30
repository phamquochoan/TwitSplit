//
//  InputView.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/30/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit
import SnapKit

/// Input view for `TweetViewController`
class InputView: UIView {
    internal var textView: UITextView!
    internal var send: UIButton!
    private var seperator: UIView!
    private var textViewBottom: UIView!
    private var didSetupConstraints: Bool = false
    
    internal var hasUserInputContent: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setPlaceHolderText(to value: Bool) {
        if value {
            textView.text = "Enter your message"
            textView.textColor = .lightGray
        } else {
            textView.text = nil
            textView.textColor = .black
        }
        
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0.99, alpha: 1)

        textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .lightGray
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        setPlaceHolderText(to: true)
        addSubview(textView)
        
        send = UIButton()
        send.setTitle("Send", for: .normal)
        send.setTitleColor(.black, for: .normal)
        send.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addSubview(send)
        
        seperator = UIView()
        seperator.backgroundColor = UIColor(white: 0.9, alpha: 1)
        addSubview(seperator)
        
        textViewBottom = UIView()
        textViewBottom.backgroundColor = UIColor(white: 0.94, alpha: 1)
        addSubview(textViewBottom)
    }
    
    override func updateConstraints() {
        guard !didSetupConstraints else {
            super.updateConstraints()
            return
        }
        
        send.snp.makeConstraints { x in
            x.trailing.equalToSuperview().inset(15)
            x.top.equalToSuperview().offset(10)
            x.width.equalTo(50)
        }
        
        textView.snp.makeConstraints { x in
            x.leading.equalToSuperview().offset(10)
            x.trailing.equalTo(send.snp.leading).offset(-10)
            x.top.equalToSuperview().offset(10)
            x.bottom.equalToSuperview().inset(10)
        }
        
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        seperator.snp.makeConstraints { x in
            x.leading.trailing.top.equalToSuperview()
            x.height.equalTo(1 / UIScreen.main.scale)
        }
        
        textViewBottom.snp.makeConstraints { x in
            x.leading.trailing.equalTo(textView)
            x.bottom.equalToSuperview().inset(10)
            x.height.equalTo(1)
        }
        
        didSetupConstraints = true
        super.updateConstraints()
    }
}
