//
//  ViewController.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages

class TweetViewController: UIViewController {
    
    private var table: UITableView!
    private var input: InputView!
    private var warning: MessageView!
    
    private var didSetupConstraints: Bool = false
    private var inputBottomConstraint: Constraint!

    private var tweetViewModel = TweetViewModel()
    private var data: [[String]] = [
        [
            "DEMO -- Bold number on the left is the count of characters in a tweet's fragment.",
            "1/11 We want to see how you create a new project",
            "2/11 and what technologies you decide to you use.",
            "3/11 A good project will be cleanly structured,",
            "4/11 will only contain the dependencies it needs,",
            "5/11 and will be well-documented and well-tested.",
            "6/11 What matters is not the technologies you use,",
            "7/11 but the reasons for your decisions. Bonus",
            "8/11 points will be given for demonstrating",
            "9/11 knowledge of modern Swift techniques and best",
            "10/11 practices. Create an iOS application that",
            "11/11 serves the Tweeter interface."
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.setNeedsUpdateConstraints()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardNotification(_:)),
            name: Notification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
    }
    
    @objc private func keyboardNotification(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let endFrame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
        else { return }
        
        if endFrame.cgRectValue.origin.y >= UIScreen.main.bounds.size.height {
            inputBottomConstraint.update(inset: 0)
        } else {
            inputBottomConstraint.update(inset: endFrame.cgRectValue.size.height)
        }
        
        UIView.animate(withDuration: duration.doubleValue) { [unowned self] in
            self.view.layoutIfNeeded()
            self.scrollToLatestTweet()
        }
    }
    
    @objc private func goToSettingController() {
        let controller = SettingViewController()
        controller.option = tweetViewModel.options
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func sendTweet(_ sender: UIButton!) {
        guard !input.textView.text.isEmpty && input.hasUserInputContent else { return }
        do {
            data.append(try tweetViewModel.splitMessage(message: input.textView.text))
            input.textView.text = nil
            table.insertSections(IndexSet(integer: data.count - 1), with: .automatic)
            scrollToLatestTweet()
        }
        catch {
            guard case let SplitError.exceedsWordLength(word) = error else { return }
            warning.configureContent(title: "Alert", body: "The word '\(word)' is exceed character limit.")
            SwiftMessages.show(view: warning)
        }
    }
    
    private func scrollToLatestTweet() {
        table.scrollToRow(
            at: IndexPath(row: data[data.count - 1].count - 1, section: data.count - 1),
            at: .bottom,
            animated: true
        )
    }
    
}

extension TweetViewController: SettingDelegate {
    func splitOptionChanged(to option: SplitOption) {
        tweetViewModel.options = option
    }
}

extension TweetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as! TweetTableViewCell
        cell.setContent(data[indexPath.section][indexPath.row])
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if input.textView.isFirstResponder {
            input.textView.resignFirstResponder()
        }
    }
}

extension TweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = textView.contentSize.height > 100
        input.hasUserInputContent = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !input.hasUserInputContent {
            input.setPlaceHolderText(to: false)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        input.hasUserInputContent = !textView.text.isEmpty
        if textView.text.isEmpty {
            input.setPlaceHolderText(to: true)
        }
    }
    
}


extension TweetViewController {
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icon_setting"),
            style: .plain,
            target: self,
            action: #selector(goToSettingController)
        )
        
        title = "Twit Split"
        view.backgroundColor = .white
        setupTableView()
        view.addSubview(table)
        
        setupInputView()
        view.addSubview(input)
        
        setupWarningView()
    }
    
    override func updateViewConstraints() {
        guard !didSetupConstraints else {
            super.updateViewConstraints()
            return
        }
        
        table.snp.makeConstraints { x in
            x.leading.trailing.top.equalToSuperview()
            x.bottom.equalTo(input.snp.top)
        }
        
        input.snp.makeConstraints { x in
            x.leading.trailing.equalToSuperview()
            inputBottomConstraint = x.bottom.equalToSuperview().constraint
            x.height.lessThanOrEqualTo(150)
        }
        
        didSetupConstraints = true
        super.updateViewConstraints()
    }
    
    private func setupInputView() {
        input = InputView()
        input.textView.delegate = self
        input.send.addTarget(self, action: #selector(sendTweet(_:)), for: .touchUpInside)
    }
    
    private func setupTableView() {
        table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor(white: 0.98, alpha: 1)
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
    }
    
    private func setupWarningView() {
        warning = MessageView.viewFromNib(layout: .MessageViewIOS8)
        warning.configureTheme(backgroundColor: UIColor(white: 0.97, alpha: 1), foregroundColor: .black)
    }
}
