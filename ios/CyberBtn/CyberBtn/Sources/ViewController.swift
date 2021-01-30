//
//  ViewController.swift
//  CyberBtn
//
//  Created by Kyle on 2021-01-29.
//

import CoreGraphics
import QuartzCore
import UIKit

let kCyYellow10 = UIColor(red: 255.0/255.0, green: 247/255.0, blue: 0, alpha: 1)
let kCyYellow20 = UIColor(red: 245/255.0, green: 245/255.0, blue: 61.0/255.0, alpha: 1)
let kCyYellow30 = UIColor(red: 255/255.0, green: 237/255.0, blue: 0, alpha: 1)
let kCyYellow40 = UIColor(red: 230/255.0, green: 222/255.0, blue: 0, alpha: 1)
let kCyRed = UIColor(red: 236.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 1)
let kCyBlue = UIColor(red: 13.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)

class ViewController: UIViewController {

    let yellowGradientBackgroud = CAGradientLayer()

    override func loadView() {
        let view = UIView()
        self.yellowGradientBackgroud.colors = [kCyYellow30.cgColor, kCyYellow40.cgColor]
        self.yellowGradientBackgroud.locations = [NSNumber(value: 0.75), NSNumber(value: 0.75)]
        self.yellowGradientBackgroud.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.yellowGradientBackgroud.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(self.yellowGradientBackgroud)

        let button = CyberButton.create()
        button.setTitle("Glitched_", for: .normal)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.yellowGradientBackgroud.frame = self.view.frame
    }
}

let kMinWidth: CGFloat = 250.0
let kInsetHorizontal: CGFloat = 64.0
let kInsetVertical: CGFloat = 32.0
let kShadowOffsetX: CGFloat = 2.0
let kTagFontSize: CGFloat = 9.0
let kTagInset: CGFloat = 2.0
let kTagShadowOffsetX: CGFloat = 2.0
let kTagBottomOffset: CGFloat = (kTagFontSize + kTagInset)/2
let kGlitchTextShadowOffset: CGFloat = 2.0
let kMaskPathInset: CGFloat = 10.0

final class CyberButton: UIButton {
    private let maskLayer = CAShapeLayer()

    private let tagLabel = UILabel()
    private let tagView = UIView()
    private var isGlitch: Bool = false
    private var glitchButton: CyberButton?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func create() -> CyberButton {
        let button = CyberButton()
        let glitch = CyberButton()
        button.addGlitch(glitch)
        return button
    }

    private init() {
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

        self.tagView.isHidden = true
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        let attrTitle = NSAttributedString(string: (title ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 2.0])
        super.setAttributedTitle(attrTitle, for: state)

        let glitchYellowTextShadow = NSShadow()
        glitchYellowTextShadow.shadowColor = kCyYellow10
        glitchYellowTextShadow.shadowBlurRadius = 0
        glitchYellowTextShadow.shadowOffset = CGSize(width: -kGlitchTextShadowOffset, height: -kGlitchTextShadowOffset)

        let glitchAttrTitle = NSAttributedString(string: (title ?? "").uppercased(), attributes: [
            NSAttributedString.Key.kern: 2.0,
            NSAttributedString.Key.shadow: glitchYellowTextShadow
        ])

        self.glitchButton?.setAttributedTitle(glitchAttrTitle, for: state)
    }

    func setTag(_ tag: String?) {
        let attrTag = NSAttributedString(string: (tag ?? "").uppercased(), attributes: [NSAttributedString.Key.kern: 1.0])
        self.tagLabel.attributedText = attrTag
        self.tagView.isHidden = tag == nil && tag == ""
    }

    private func addGlitch(_ glitchButton: CyberButton) {
        self.glitchButton = glitchButton
        glitchButton.isUserInteractionEnabled = false
        glitchButton.isGlitch = true

        glitchButton.layer.shadowOffset = CGSize(width: -kShadowOffsetX, height: kShadowOffsetX)

        glitchButton.titleLabel?.layer.shadowColor = kCyBlue.cgColor
        glitchButton.titleLabel?.layer.shadowOpacity = 1
        glitchButton.titleLabel?.layer.shadowRadius = 0
        glitchButton.titleLabel?.layer.shadowOffset = CGSize(width: kGlitchTextShadowOffset, height: kGlitchTextShadowOffset)

        let glitchBlueTextShadow = NSShadow()
        glitchBlueTextShadow.shadowColor = kCyBlue
        glitchBlueTextShadow.shadowBlurRadius = 0
        glitchBlueTextShadow.shadowOffset = CGSize(width: kGlitchTextShadowOffset, height: kGlitchTextShadowOffset)

        self.insertSubview(glitchButton, belowSubview: self.tagView)

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: kMinWidth),
            glitchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            glitchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            glitchButton.topAnchor.constraint(equalTo: self.topAnchor),
            glitchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override var bounds: CGRect {
        get { super.bounds }
        set {
            super.bounds = newValue
            self.maskLayer.frame = newValue


            self.layer.shadowPath = Self.createShadowPath(newValue)


            if !self.isGlitch {
                self.maskLayer.path = Self.createMaskPath(newValue)
            }

            if self.isGlitch {
                self.layer.removeAnimation(forKey: "glitchTransformAnim")
                self.maskLayer.removeAnimation(forKey: "glitchMaskPathAnim")

                let animMaskPath = CAKeyframeAnimation()
                animMaskPath.keyPath = "path"
                animMaskPath.values = [
                    Self.createGlitchMaskPath1(newValue),
                    Self.createGlitchMaskPath2(newValue),
                    Self.createGlitchMaskPath3(newValue),
                    Self.createGlitchMaskPath2(newValue),
                    Self.createMaskPath(newValue),
                    Self.createGlitchMaskPath2(newValue),
                ]
                let valuesCount: Double = Double((animMaskPath.values?.count ?? 1))
                animMaskPath.keyTimes = [
                    NSNumber(value: 0*1.0/valuesCount),
                    NSNumber(value: 1*1.0/valuesCount),
                    NSNumber(value: 2*1.0/valuesCount),
                    NSNumber(value: 3*1.0/valuesCount),
                    NSNumber(value: 3.3*1.0/valuesCount),
                    NSNumber(value: 4*1.0/valuesCount),
                ]

                let translateAnim = CAKeyframeAnimation()
                translateAnim.keyPath = "transform"
                translateAnim.values = [
                    CATransform3DMakeTranslation(-4, -4, 0),
                    CATransform3DMakeTranslation(-8, -4, 0),
                    CATransform3DMakeTranslation(4, -4, 0),
                ]
                translateAnim.keyTimes = [
                    0,
                    0.33,
                    0.66,
                ]

                let beginTime = 0.0
                let duration = 0.3
                let repeatDelay = 1.0

                animMaskPath.duration = duration
                animMaskPath.beginTime = beginTime

                translateAnim.beginTime = beginTime
                translateAnim.duration = duration

                let pathGroup = CAAnimationGroup()
                pathGroup.animations = [animMaskPath]
                pathGroup.beginTime = beginTime
                pathGroup.duration = duration + repeatDelay
                pathGroup.repeatCount = .infinity
                pathGroup.autoreverses = true

                let translateGroup = CAAnimationGroup()
                translateGroup.animations = [translateAnim]
                translateGroup.beginTime = beginTime
                translateGroup.duration = duration + repeatDelay
                translateGroup.repeatCount = .infinity
                translateGroup.autoreverses = true

                self.maskLayer.add(pathGroup, forKey: "glitchMaskPathAnim")
                self.layer.add(translateGroup, forKey: "glitchTransformAnim")
            }
        }
    }

    private static func createMaskPath(_ bounds: CGRect) -> CGPath {
        let width = bounds.width + kShadowOffsetX + kMaskPathInset
        let height = bounds.height + kTagBottomOffset + kMaskPathInset
        let start = CGPoint(x: -kMaskPathInset, y: -kMaskPathInset)

        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: CGPoint(x: width, y: -kMaskPathInset))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: kInsetHorizontal*2/3, y: height))
        path.addLine(to: CGPoint(x: -kMaskPathInset, y: height - kInsetHorizontal*2/3))
        path.addLine(to: start)

        return path
    }

    private static func createShadowPath(_ bounds: CGRect) -> CGPath {
        let shadowPath = CGMutablePath()
        shadowPath.move(to: .zero)
        shadowPath.addLine(to: CGPoint(x: bounds.width + kShadowOffsetX, y: 0))
        shadowPath.addLine(to: CGPoint(x: bounds.width + kShadowOffsetX, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: kInsetHorizontal/3, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: bounds.height - kInsetHorizontal/3))
        shadowPath.addLine(to: .zero)

        return shadowPath
    }

    private static func createGlitchMaskPath1(_ bounds: CGRect) -> CGPath {
        let width = bounds.width + kShadowOffsetX + kMaskPathInset
        let height = bounds.height + kTagBottomOffset + kMaskPathInset

        let path = CGMutablePath()
        path.move(to: CGPoint(x: -kMaskPathInset, y: height - kInsetHorizontal*2/3))
        path.addLine(to: CGPoint(x: width, y: height - kInsetHorizontal*2/3))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: kInsetHorizontal*2/3, y: height))
        path.addLine(to: CGPoint(x: -kMaskPathInset, y: height - kInsetHorizontal*2/3))

        return path
    }

    private static func createGlitchMaskPath2(_ bounds: CGRect) -> CGPath {
        let width = bounds.width + kShadowOffsetX + kMaskPathInset
        let center = bounds.height / 2 + 4.0
        let visibleTextHeight: CGFloat = 4.0
        let start = CGPoint(x: -kMaskPathInset, y: center - visibleTextHeight)

        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: CGPoint(x: width, y: center - visibleTextHeight))
        path.addLine(to: CGPoint(x: width, y: center + visibleTextHeight))
        path.addLine(to: CGPoint(x: -kMaskPathInset, y: center + visibleTextHeight))
        path.addLine(to: start)

        return path
    }

    private static func createGlitchMaskPath3(_ bounds: CGRect) -> CGPath {
        let width = bounds.width + kShadowOffsetX + kMaskPathInset
        let height = bounds.height + kTagBottomOffset + kMaskPathInset
        let center = height - kInsetHorizontal*2/3 - kInsetHorizontal*2/7

        let path = CGMutablePath()
        path.move(to: CGPoint(x: -kMaskPathInset, y: center))
        path.addLine(to: CGPoint(x: width, y: center))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: kInsetHorizontal*2/3, y: height))
        path.addLine(to: CGPoint(x: -kMaskPathInset, y: height - kInsetHorizontal*2/3))
        path.addLine(to: CGPoint(x: -kMaskPathInset, y: center))

        return path
    }
}
