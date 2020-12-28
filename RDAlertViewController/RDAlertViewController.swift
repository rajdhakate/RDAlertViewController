//
//  RDAlertViewController.swift
//
//  Created by Raj Dhakate on 22/12/20.
//  Copyright © 2020 Raj Dhakate. All rights reserved.
//

import UIKit

struct RDAlertAction {
    let title: String
    let action: (UIViewController) -> ()
}

private struct InternalRDAlertAction {
    let title: String
    let tag: Int
    let action: (UIViewController) -> ()
}

class RDAlertViewController: UIViewController {
    
    @IBOutlet private weak var popupWidth: NSLayoutConstraint!
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    
    private var actionsArray = [InternalRDAlertAction]()
    
    private var titleString: String?
    private var subtitleString: String?
    
    private var attributedTitleString: NSAttributedString?
    private var attributedSubtitleString: NSAttributedString?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets a popup view controller
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        initializeViews()
        
        setupViews()
    }
    
    func setWith(title: String?, subtitle: String?, actions: [RDAlertAction]?) {
        titleString = title
        subtitleString = subtitle
        
        if let actions = actions {
            for (index, action) in actions.enumerated() {
                let internalRDAlertAction = InternalRDAlertAction(title: action.title, tag: index, action: action.action)
                actionsArray.append(internalRDAlertAction)
            }
        }
    }
    
    func setWith(attributedTitle: NSAttributedString?, attributedsubtitle: NSAttributedString?, actions: [RDAlertAction]?) {
        attributedTitleString = attributedTitle
        attributedSubtitleString = attributedsubtitle
        
        if let actions = actions {
            for (index, action) in actions.enumerated() {
                let internalRDAlertAction = InternalRDAlertAction(title: action.title, tag: index, action: action.action)
                actionsArray.append(internalRDAlertAction)
            }
        }
    }
    
    private func initializeViews() {
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    private func setupViews() {
        
        if !UIDevice.current.iPad {
            popupWidth.constant = UIScreen.main.bounds.size.width * 0.8
        } else {
            popupWidth.constant = 350
        }
        
        self.view.backgroundColor = UIColor.init(hexString: "#000000", alpha: 0.6)
        
        self.bgView.layer.cornerRadius = 8
        self.bgView.backgroundColor = UIColor(hexString: "#202020")
        
        self.bgView.layer.shadowColor = UIColor.black.cgColor
        self.bgView.layer.shadowOffset = .zero
        self.bgView.layer.shadowRadius = 5
        self.bgView.layer.shadowOpacity = 0.9
        
        self.titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        self.titleLabel.textColor = .white
        
        self.subtitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        self.subtitleLabel.textColor = .white
        
        if let title = titleString {
            // show title
            titleLabel.text = title
        }
        if let attributedTitle = attributedTitleString {
            // show attributed title
            titleLabel.attributedText = attributedTitle
        }
        
        if let subtitle = subtitleString {
            // show subtitle
            subtitleLabel.text = subtitle
        }
        if let attributedsubtitle = attributedSubtitleString {
            // show attributed subtitle
            subtitleLabel.attributedText = attributedsubtitle
        }
        
        for (index, action) in actionsArray.enumerated() {
            let button = OvalButton()
            button.setTitle(action.title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            button.backgroundColor = UIColor(hexString: "#5B5A5A")
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            button.setTitleColor(UIColor(hexString: "#FFEC41"), for: .normal)
            buttonsStackView.addArrangedSubview(button)
        }
        
        UIView.animate(withDuration: 0.3 / 2, animations: {
            self.bgView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        }) { finished in
            UIView.animate(withDuration: 0.3 / 2, animations: {
                self.bgView.transform = CGAffineTransform.identity.scaledBy(x: 1.15, y: 1.15)
            }) { finished in
                UIView.animate(withDuration: 0.3 / 2, animations: {
                    self.bgView.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if let action = actionsArray.first(where: { (internalRDAlertAction) -> Bool in
            return internalRDAlertAction.tag == sender.tag
        }) {
            action.action(self)
        }
    }
}

// Mark - Extensions
extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }

}

//Mark - Oval button
class OvalButton: UIButton {
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
    }
}
