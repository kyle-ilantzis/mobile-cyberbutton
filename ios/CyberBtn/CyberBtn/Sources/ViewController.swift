//
//  ViewController.swift
//  CyberBtn
//
//  Created by Kyle on 2021-01-29.
//

import UIKit

let kCyYellow = UIColor(red: 255.0/255.0, green: 247/255.0, blue: 0, alpha: 1)

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = kCyYellow

        let button = CyberButton()
        button.setTitle("Beginning_".uppercased(), for: .normal)

        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
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
    }
}
