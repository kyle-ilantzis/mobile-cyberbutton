//
//  ViewController.swift
//  CyberBtn
//
//  Created by Kyle on 2021-01-29.
//

import CoreGraphics
import UIKit

let kCyYellow = UIColor(red: 255.0/255.0, green: 247/255.0, blue: 0, alpha: 1)
let kCyRed = UIColor(red: 236.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 1)
let kCyBlue = UIColor(red: 13.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = kCyYellow

        let button = CyberButton()
        button.setTitle("Clipped_", for: .normal)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

let kMinWidth: CGFloat = 250.0
let kInsetHorizontal: CGFloat = 64.0
let kInsetVertical: CGFloat = 32.0
let kShadowOfferX: CGFloat = 3.0

final class CyberButton: UIButton {
    private let maskLayer = CAShapeLayer()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = UIFont(name: "BlenderPro-Heavy", size: 26.0)
        self.backgroundColor = kCyRed

        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: kMinWidth).isActive = true
        self.contentEdgeInsets = UIEdgeInsets(top: kInsetVertical, left: kInsetHorizontal, bottom: kInsetVertical, right: kInsetHorizontal)

        self.layer.shadowColor = kCyBlue.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: kShadowOfferX, height: 0)

        self.layer.mask = self.maskLayer
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        let attrTitle = NSAttributedString(string: (title ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 2.0])
        super.setAttributedTitle(attrTitle, for: state)
    }

    override var bounds: CGRect {
        get { super.bounds }
        set {
            super.bounds = newValue
            self.maskLayer.frame = newValue

            let path = CGMutablePath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: newValue.width + kShadowOfferX, y: 0))
            path.addLine(to: CGPoint(x: newValue.width + kShadowOfferX, y: newValue.height))
            path.addLine(to: CGPoint(x: kInsetHorizontal / 3, y: newValue.height))
            path.addLine(to: CGPoint(x: 0, y: newValue.height - kInsetHorizontal / 3))
            path.addLine(to: .zero)

            self.maskLayer.path = path.copy()
        }
    }
}
