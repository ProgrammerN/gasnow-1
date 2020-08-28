//
//  CustomLayoutTextField.swift
//  TestViewDemo
//
//  Created by Hybrid Team on 12/24/18.
//  Copyright © 2018 demoapp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextFieldLayout: UITextField, UITextFieldDelegate{

    // MARK: - Property for textfiled label
    @IBInspectable var lableTextColor: UIColor = .clear{
        didSet{
                   lableTextColor = UIColor.clear
               }
    }
    @IBInspectable var lableBGColor: UIColor = .clear
    
    // MARK: - Property for textField layout
    @IBInspectable var placeHolderBorderColor:UIColor = .clear
    @IBInspectable var labelWithBorderColor:UIColor =  UIColor.clear {
        didSet{
            labelWithBorderColor = UIColor.clear
        }
    }
    @IBInspectable var textFieldBorderRadius:CGFloat = 4
    
     // MARK: - Property for textfield is required
    @IBInspectable var textfieldTextRequire:Bool = false
    @IBInspectable var isPlaceHolderOnTop : Bool = false
    @IBInspectable var textfieldErrorText:String = "Text is empty!"
    @IBInspectable var textfieldErrorColor:UIColor = UIColor.red
    @IBInspectable var textfieldErrorBorderColor:UIColor = UIColor.red
    @IBInspectable var textfieldTextRequireBorder:Bool = true
    @IBInspectable var isBottomLineRequired : Bool = false
    
    let scaleCoeff: CGFloat = 0.75
    var isLayoutSet: Bool = false
    var placeholderLabel = UILabel(frame: CGRect.zero)
    var errorPlaceholderLabel = UILabel(frame: CGRect.zero)
    var placeholderLabelMinCenter: CGFloat = 0.0
    var placeholdertext:String = ""
      @IBInspectable var leftPadding: CGFloat = 12
      private var leadingConstraint: NSLayoutConstraint?
      private var trailingConstraint: NSLayoutConstraint?
     var bottomLineLabel = UILabel(frame: CGRect.zero)
     
    
    // MARK: - Setup
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if (placeholder?.isEmpty == true) {
            placeholder = (placeholderLabel.text != nil) ?  placeholderLabel.text : ""
        }
        if isLayoutSet == false{
            if(textfieldTextRequire == true){
                addErrorLableOnTextField(rect:rect,font: self.font!)
            }
             addLabelTopLableView(rect: self.frame,font: self.font!)
             isLayoutSet = true
        }
        if isBottomLineRequired{
           addBottomLineOntextField()
        }
        setupObserver()
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
    }
    //layout setValue and Update
    func setTextValue(val:String) {
        self.text = val
        if text?.isEmpty == false {
            showLabelOnTextField()
        }
    }
    // MARK: Notification
       private func setupObserver() {

            NotificationCenter.default.addObserver(self, selector: #selector(didEndChangingText), name: UITextField.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndChangingText), name: UITextField.textDidEndEditingNotification, object: self)

        }
    
    // MARK: - Notification actions
    
    @objc func didBeginChangeText() {
        print("did Begin Change Text ")
          showLabelOnTextField()
    }
    
    @objc func didEndChangingText() {
        print("did End Changing Text ")
        if((text?.isEmpty) == true){
            if(textfieldTextRequire == true){
                 textFieldEmpty()
             }else{
                showPlaceHolder()
           }
         }else{
            placeholder = placeholdertext
            showLabelOnTextField()
        }
    }
    
    private func textFieldEmpty() {
        errorPlaceholderLabel.isHidden = false
        placeholderLabel.isHidden = true
        setColor(color: textfieldErrorBorderColor)
     }
    
    public func textFieldEmptyError() {
        text = ""
        placeholder = ""
        errorPlaceholderLabel.isHidden = false
        placeholderLabel.isHidden = true
        setColor(color: textfieldErrorBorderColor)
    }
    
    private func showPlaceHolder()  {
        setColor(color: placeHolderBorderColor)
        placeholder = placeholderLabel.text
        placeholderLabel.isHidden = true
    }
    
    private func showLabelOnTextField(){
        placeholderLabel.isHidden = false
        errorPlaceholderLabel.isHidden = true
        setColor(color: labelWithBorderColor)
        placeholder = nil
    }
    
    private func setColor(color:UIColor) {
        if textfieldTextRequireBorder {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = textFieldBorderRadius
        self.layer.borderColor = color.cgColor
        }
    }
    
    public func setBorderColor(color:UIColor) {
        self.labelWithBorderColor = color
        self.layer.borderColor = self.labelWithBorderColor.cgColor
    }
    public func setBorderColorWithPlaceHolder(color:UIColor) {
        self.labelWithBorderColor = color
        self.layer.borderColor = self.labelWithBorderColor.cgColor
        addLabelTopLableView(rect: self.frame,font: self.font!)
    }
    private func addLabelTopLableView(rect: CGRect,font: UIFont){
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 1
        placeholderLabel.text = placeholder
        var xCordinate : CGFloat = 0
        var yCordinate : CGFloat = 10
        if isPlaceHolderOnTop {
            xCordinate = 0
            yCordinate = 16
            self.backgroundColor = UIColor.white //appcustomcolor.creditviewtxt
        }
        placeholderLabel.frame = CGRect(x: rect.origin.x + xCordinate,
                                        y:rect.origin.y - yCordinate,
                                        width: placeholderLabel.intrinsicContentSize.width,
                                        height: font.pointSize)
        placeholderLabel.textAlignment = .center
       // placeholderLabel.font = UIFont.font(fontFamily: .notoSansHKRegular, size: UIFont.fontsize12)
        placeholderLabel.textColor = lableTextColor
        placeholderLabel.backgroundColor = lableBGColor
        placeholderLabelMinCenter = placeholderLabel.center.x * scaleCoeff
        if(text?.isEmpty == true){
            showPlaceHolder()
        }else{
            showLabelOnTextField()
        }
        if  isPlaceHolderOnTop {
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
        }
        self.tintColor = UIColor.blue
        self.superview?.addSubview(placeholderLabel)
       // bringSubview(toFront: placeholderLabel)
    }
    
    private func addErrorLableOnTextField(rect:CGRect,font: UIFont){
        errorPlaceholderLabel = UILabel()
        errorPlaceholderLabel.numberOfLines = 1
        errorPlaceholderLabel.text = textfieldErrorText
        errorPlaceholderLabel.frame = CGRect(x: rect.origin.x,
                                             y:rect.size.height/3 - font.pointSize,
                                             width: rect.size.width - 10,
                                             height: rect.size.height)
        errorPlaceholderLabel.textAlignment = .left
      //  errorPlaceholderLabel.font = UIFont.font(fontFamily: .notoSansHKRegular, size: UIFont.fontsize14)
        errorPlaceholderLabel.textColor = textfieldErrorColor
        errorPlaceholderLabel.backgroundColor = UIColor.clear
        errorPlaceholderLabel.isHidden = true
        self.addSubview(errorPlaceholderLabel)
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
  @IBInspectable var rightPadding: CGFloat = 5
    
    func updateRightView() {
        if let image = rightImage {
            rightPadding = 5
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: (rightImage?.size.width)! + rightPadding, height: (rightImage?.size.height)!) )
            let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: (rightImage?.size.width)!, height: (rightImage?.size.height)!))
            rightViewMode = .always
            iconView.image = image
            outerView.addSubview(iconView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnRightImage))
            iconView.addGestureRecognizer(tap)
            iconView.isUserInteractionEnabled = true
            rightView = outerView
            trailingConstraint?.constant = -1 * ((rightImage?.size.width)!)
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
  @objc private func tappedOnRightImage() {
    self.becomeFirstResponder()
  }
    
    func updateLeftView() {
        if let image = leftImage {
            leftPadding = 5
            leftViewMode = .always
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: (leftImage?.size.width)! + leftPadding, height: (leftImage?.size.height)!) )
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (leftImage?.size.width)! + leftPadding, height: (leftImage?.size.height)!))
            imageView.contentMode = .center
            imageView.image = image
            outerView.addSubview(imageView)
            leftView = outerView
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnRightImage))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
            leadingConstraint?.constant = (leftImage?.size.width)! + leftPadding
        }else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    func addBottomLineOntextField (){
        bottomLineLabel = UILabel()
        bottomLineLabel.numberOfLines = 1
        bottomLineLabel.frame = CGRect(x: 0,
                                       y:self.self.frame.size.height - 1,
                                       width: self.frame.size.width,
                                       height: 1)
        bottomLineLabel.textColor = .clear
        bottomLineLabel.backgroundColor = .darkGray
        bottomLineLabel.isHidden = false
        self.addSubview(bottomLineLabel)
    }
}
extension UITextField {
 
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
  
    
}
