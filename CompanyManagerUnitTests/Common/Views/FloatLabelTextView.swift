//
//  FloatLabelTextView.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import UIKit

@IBDesignable class FloatLabelTextView: UITextView {
    
    @IBInspectable var maxCharactersCount: Int = 0
    @IBInspectable var titleColor: UIColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)
    @IBInspectable var errorColor: UIColor = #colorLiteral(red: 1, green: 0.200000003, blue: 0.4709999859, alpha: 1)
    @IBInspectable var successColor: UIColor = #colorLiteral(red: 0.2899999917, green: 0.949000001, blue: 0.6309999824, alpha: 1)
    @IBInspectable var underlineColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5) {
        didSet {
            bottomBorderView?.backgroundColor = underlineColor
        }
    }
    @IBInspectable open var contentInsets: UIEdgeInsets = .zero {
        didSet {
            adjustInsets()
        }
    }
    @IBInspectable var titleFontSize: CGFloat = 12 {
        didSet {
            adjustFontSizes()
            textContainerInset.top = UIFont.systemFont(ofSize: titleFontSize).lineHeight + 4
            textContainerInset.bottom = UIFont.systemFont(ofSize: titleFontSize).lineHeight + 3
        }
    }
    
    open override var placeholder: String? {
        didSet {
            titleLabel?.text = placeholder
        }
    }
    
    private var bottomBorderView: UIView?
    private var titleLabel: UILabel?
    private var errorLabel: UILabel?
    private let kFadeDuration = 0.2
    private let kDrawDuration = 0.1
    var errorMessage: String? {
        return errorLabel?.text
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //    setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Actions
    
    @objc private func didChangeText() {
        guard let text = text else {
            hideTitle()
            return
        }
        text.isEmpty ? hideTitle() : showTitle()
        guard maxCharactersCount != 0, text.composedCharacterCount > maxCharactersCount else {
            return
        }
        let endIndex = text.index(before: text.endIndex)
        self.text = String(text[..<endIndex])
    }
    
    @objc func clearText() {
        text = nil
        didChangeText()
    }
    
    // MARK: - Functions
    
    public func success() {
        bottomBorderView?.backgroundColor = successColor.withAlphaComponent(0.5)
        hideErrorLabel()
    }
    
    public func failure(error: String) {
        bottomBorderView?.backgroundColor = errorColor.withAlphaComponent(0.5)
        showErrorLabel(with: error)
    }
    
    // MARK: - Private Functions
    
    open func setup() {
        //    translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView = UIView()
        bottomBorderView!.backgroundColor = underlineColor
        addSubview(bottomBorderView!)
        //    bottomBorderView?.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView?.frame.origin.x = contentInsets.left
        bottomBorderView?.frame.size.width = bounds.width - 2*contentInsets.left
        bottomBorderView?.frame.size.height = 2
        bottomBorderView?.frame.origin.y = bounds.height - UIFont.systemFont(ofSize: titleFontSize).lineHeight
        //    bottomBorderView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        //    bottomBorderView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        //    bottomBorderView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant:
        //      -UIFont.systemFont(ofSize: titleFontSize).lineHeight).isActive = true
        //    bottomBorderView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
        textContainerInset.top = UIFont.systemFont(ofSize: titleFontSize).lineHeight + 4
        textContainerInset.bottom = UIFont.systemFont(ofSize: titleFontSize).lineHeight + 3
        resizePlaceholder()
        createTitle()
        //    createDeleteMark()
        createErrorLabel()
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeText),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func showTitle() {
        guard let title = titleLabel else {
            createTitle()
            return
        }
        guard title.alpha == 0 else { return }
        //    showDeleteMark()
        UIView.animate(withDuration: kFadeDuration) {
            title.alpha = 1
        }
    }
    
    private func hideTitle() {
        guard let title = titleLabel else {
            createTitle()
            return
        }
        guard title.alpha == 1 else { return }
        //    hideDeleteMark()
        hideErrorLabel()
        if (text ?? "").isEmpty {
            bottomBorderView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        UIView.animate(withDuration: kFadeDuration) {
            title.alpha = 0
        }
    }
    
    private func createTitle() {
        guard titleLabel == nil else {
            titleLabel?.frame.size.width = frame.width
            return
        }
        titleLabel = UILabel()
        titleLabel?.text = placeholder
        titleLabel?.font = titleLabel?.font.withSize(titleFontSize)
        titleLabel?.textColor = titleColor
        titleLabel?.alpha = 0
        titleLabel?.sizeToFit()
        titleLabel?.frame.size.width = frame.width
        addSubview(titleLabel!)
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top).isActive = true
        textContainerInset.top = titleLabel!.frame.height
        if !(text ?? "").isEmpty {
            showTitle()
        }
    }
    
    private func createErrorLabel() {
        guard errorLabel == nil else {
            errorLabel?.frame.size.width = frame.width
            return
        }
        errorLabel = UILabel()
        errorLabel?.font = errorLabel?.font.withSize(titleFontSize)
        errorLabel?.textColor = errorColor
        errorLabel?.alpha = 0
        errorLabel?.sizeToFit()
        errorLabel?.frame.size.width = frame.width
        errorLabel?.frame.origin.y = frame.height - errorLabel!.font.lineHeight
        addSubview(errorLabel!)
        errorLabel?.translatesAutoresizingMaskIntoConstraints = false
        errorLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
        errorLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
        errorLabel?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom).isActive = true
    }
    
    private func showErrorLabel(with error: String) {
        guard let errorLabel = errorLabel else {
            createErrorLabel()
            return
        }
        errorLabel.text = error
        errorLabel.sizeToFit()
        UIView.animate(withDuration: kFadeDuration) {
            errorLabel.alpha = 1
        }
    }
    
    private func hideErrorLabel() {
        guard let errorLabel = errorLabel else {
            createErrorLabel()
            return
        }
        UIView.animate(withDuration: kFadeDuration, animations: {
            errorLabel.alpha = 0
        }, completion: { _ in
            errorLabel.text = ""
        })
    }
    
    private func adjustInsets() {
        //    if let deleteMark = deleteMark {
        //      deleteMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
        //    }
        if let titleLabel = titleLabel {
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top).isActive = true
        }
        if let errorLabel = errorLabel {
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom).isActive = true
        }
        if let bottomBorderView = bottomBorderView {
            bottomBorderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
            bottomBorderView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -contentInsets.right).isActive = true
        }
    }
    
    private func adjustFontSizes() {
        titleLabel?.font = titleLabel?.font.withSize(titleFontSize)
        errorLabel?.font = errorLabel?.font.withSize(titleFontSize)
    }
    
}

