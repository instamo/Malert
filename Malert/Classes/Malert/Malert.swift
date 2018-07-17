//
//  MalertManager.swift
//  Pods
//
//  Created by Vitor Mesquita on 01/11/16.
//
//

import UIKit

public class Malert: BaseMalertViewController {
    
    // MARK: - private
    private let malertPresentationManager = MalertPresentationManager()
    
    // MARK: - internal
    let malertView: MalertView
    var malertConstraints: [NSLayoutConstraint] = []
    var visibleViewConstraints: [NSLayoutConstraint] = []
    
    let tapToDismiss: Bool
    let dismissOnActionTapped: Bool
    
    lazy var visibleView: UIView = {
        let visibleView = UIView()
        visibleView.translatesAutoresizingMaskIntoConstraints = false
        return visibleView
    }()
    
    public init(title: String? = nil, customView: UIView, tapToDismiss: Bool = true, dismissOnActionTapped: Bool = true) {
        self.malertView = MalertView()
        self.tapToDismiss = tapToDismiss
        self.dismissOnActionTapped = dismissOnActionTapped
        super.init(nibName: nil, bundle: nil)
        
        self.malertView.seTitle(title)
        self.malertView.setCustomView(customView)
        
        self.animationType = .modalBottom
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = malertPresentationManager
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override public func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        malertView.alpha = 1
        malertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visibleView)
        visibleView.addSubview(malertView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        listenKeyboard()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeContraints()
    }
    
    override func keyboardWillShow(sender: NSNotification) {
        super.keyboardWillShow(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    deinit {
        print("dealloc ---> Malert")
    }
}

extension Malert {
    
    /* Container config */
    public var margin: CGFloat {
        get { return malertView.margin }
        set { malertView.margin = newValue }
    }
    
    public var cornerRadius: CGFloat {
        get { return malertView.cornerRadius }
        set { malertView.cornerRadius = newValue }
    }
    
    public var backgroundColor: UIColor? {
        get { return malertView.backgroundColor }
        set { malertView.backgroundColor = newValue }
    }
    
    /* Title config */
    public var textColor: UIColor {
        get { return malertView.textColor }
        set { malertView.textColor = newValue }
    }
    
    public var textAlign: NSTextAlignment {
        get { return malertView.textAlign }
        set { malertView.textAlign = newValue }
    }
    
    public var titleFont: UIFont {
        get { return malertView.titleFont }
        set { malertView.titleFont = newValue }
    }
    
    /* Buttons config */
    public var buttonsSpace: CGFloat {
        get { return malertView.buttonsSpace }
        set { malertView.buttonsSpace = newValue }
    }
    
    public var buttonsMargin: CGFloat {
        get { return malertView.buttonsMargin }
        set { malertView.buttonsMargin = newValue }
    }
    
    public var buttonsAxis: UILayoutConstraintAxis {
        get { return malertView.buttonsAxis }
        set { malertView.buttonsAxis = newValue }
    }
    
    public var animationType: MalertAnimationType  {
        get { return malertPresentationManager.animationType }
        set { malertPresentationManager.animationType = newValue }
    }
    
    public func addAction(_ malertButton: MalertAction) {
        malertView.addButton(malertButton, actionCallback: self)
    }
}