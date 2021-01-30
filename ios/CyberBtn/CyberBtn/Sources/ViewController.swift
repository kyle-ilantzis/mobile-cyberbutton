//
//  ViewController.swift
//  CyberBtn
//
//  Created by Kyle on 2021-01-29.
//

import UIKit

let kCyYellow = UIColor(red: 255.0/255.0, green: 247/255.0, blue: 0, alpha: 1)
let kCyRed = UIColor(red: 236.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 1)
let kCyBlue = UIColor(red: 13.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = kCyYellow

        let button = CyberButton()
        button.setTitle("Beginning_", for: .normal)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}

final class CyberButton: UIButton {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = UIFont(name: "BlenderPro-Heavy", size: 26.0)
        self.backgroundColor = kCyRed

        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 250.0).isActive = true
        self.contentEdgeInsets = UIEdgeInsets(top: 32.0, left: 64.0, bottom: 32.0, right: 64.0)

        self.layer.shadowColor = kCyBlue.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 3, height: 0)
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        let attrTitle = NSAttributedString(string: (title ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 2.0])
        super.setAttributedTitle(attrTitle, for: state)
    }
}
