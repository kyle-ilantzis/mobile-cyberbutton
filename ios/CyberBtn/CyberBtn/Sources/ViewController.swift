//
//  ViewController.swift
//  CyberBtn
//
//  Created by Kyle on 2021-01-29.
//

import CoreGraphics
import UIKit

let kCyYellow10 = UIColor(red: 255.0/255.0, green: 247/255.0, blue: 0, alpha: 1)
let kCyYellow20 = UIColor(red: 245/255.0, green: 245/255.0, blue: 61.0/255.0, alpha: 1)
let kCyRed = UIColor(red: 236.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 1)
let kCyBlue = UIColor(red: 13.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = kCyYellow10

        let button = CyberButton()
        button.setTitle("Clipped_", for: .normal)
        button.setTag("R25")

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
let kShadowOffsetX: CGFloat = 3.0
let kTagFontSize: CGFloat = 9.0
let kTagInset: CGFloat = 2.0
let kTagShadowOffsetX: CGFloat = 2.0
let kTagBottomOffset: CGFloat = (kTagFontSize + kTagInset)/2

final class CyberButton: UIButton {
    private let maskLayer = CAShapeLayer()

    private let tagLabel = UILabel()
    private let tagView = UIView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = UIFont(name: "BlenderPro-Heavy", size: 26.0)
        self.backgroundColor = kCyRed

        self.contentEdgeInsets = UIEdgeInsets(top: kInsetVertical, left: kInsetHorizontal, bottom: kInsetVertical, right: kInsetHorizontal)

        self.layer.shadowColor = kCyBlue.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: kShadowOffsetX, height: 0)

        self.layer.mask = self.maskLayer

        self.tagLabel.font = UIFont(name: "BlenderPro-Bold", size: kTagFontSize)

        self.tagView.backgroundColor = kCyYellow20
        self.tagView.layoutMargins = UIEdgeInsets(top: kTagInset, left: kTagInset, bottom: kTagInset, right: kTagInset)
        self.tagView.layoutMarginsDidChange()
        self.tagView.layer.shadowColor = kCyBlue.cgColor
        self.tagView.layer.shadowOpacity = 1
        self.tagView.layer.shadowRadius = 0
        self.tagView.layer.shadowOffset = CGSize(width: -kTagShadowOffsetX, height: 0)

        let tagViewShadowPath = CGMutablePath()
        tagViewShadowPath.move(to: .zero)
        tagViewShadowPath.addLine(to: CGPoint(x: kTagShadowOffsetX*2, y: 0))
        tagViewShadowPath.addLine(to: CGPoint(x: kTagShadowOffsetX*2, y: kTagBottomOffset*4.5/3))
        tagViewShadowPath.addLine(to: CGPoint(x: 0, y: kTagBottomOffset*4.5/3))
        tagViewShadowPath.addLine(to: .zero)
        self.tagView.layer.shadowPath = tagViewShadowPath

        self.tagView.addSubview(self.tagLabel)
        self.addSubview(self.tagView)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        self.tagLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: kMinWidth),

            self.tagLabel.leadingAnchor.constraint(equalTo: self.tagView.leadingAnchor, constant: kTagInset),
            self.tagLabel.trailingAnchor.constraint(equalTo: self.tagView.trailingAnchor, constant: -kTagInset),
            self.tagLabel.topAnchor.constraint(equalTo: self.tagView.topAnchor, constant: kTagInset),
            self.tagLabel.bottomAnchor.constraint(equalTo: self.tagView.bottomAnchor, constant: -kTagInset),

            self.tagView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: kTagBottomOffset),
            self.tagView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kInsetHorizontal/6)
        ])
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        let attrTitle = NSAttributedString(string: (title ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 2.0])
        super.setAttributedTitle(attrTitle, for: state)
    }

    func setTag(_ tag: String?) {
        let attrTag = NSAttributedString(string: (tag ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 1.0])
        self.tagLabel.attributedText = attrTag
    }

    override var bounds: CGRect {
        get { super.bounds }
        set {
            super.bounds = newValue
            self.maskLayer.frame = newValue

            let height = newValue.height + kTagBottomOffset

            let path = CGMutablePath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: newValue.width + kShadowOffsetX, y: 0))
            path.addLine(to: CGPoint(x: newValue.width + kShadowOffsetX, y: height))
            path.addLine(to: CGPoint(x: kInsetHorizontal/3, y: height))
            path.addLine(to: CGPoint(x: 0, y: height - kInsetHorizontal/3))
            path.addLine(to: .zero)

            let shadowPath = CGMutablePath()
            shadowPath.move(to: .zero)
            shadowPath.addLine(to: CGPoint(x: newValue.width + kShadowOffsetX, y: 0))
            shadowPath.addLine(to: CGPoint(x: newValue.width + kShadowOffsetX, y: newValue.height))
            shadowPath.addLine(to: CGPoint(x: kInsetHorizontal/3, y: newValue.height))
            shadowPath.addLine(to: CGPoint(x: 0, y: newValue.height - kInsetHorizontal/3))
            shadowPath.addLine(to: .zero)

            self.layer.shadowPath = shadowPath
            self.maskLayer.path = path
        }
    }
}
