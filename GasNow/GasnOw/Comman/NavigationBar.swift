import Foundation
import UIKit

@objc protocol NavigationBarAction : class {
  func backToview()
 @objc optional func openProfileScreen()
 @objc optional func openSettingScreen()
 @objc optional func openNotificationScreen()
 @objc optional func openCartScreen()
}


class NavigationBar: UIView {
    
    @IBOutlet weak var rightView: UIStackView!
    weak var navigationBarDelegate : NavigationBarAction!
    private static let NIB_NAME = "NavigationBar"
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var bell_button: UIButton!
    @IBOutlet private weak var menu_button: UIButton!
    @IBOutlet weak var user_button: UIButton!
    @IBOutlet private weak var btn_add_to_cart: UIButton!
    @IBOutlet private weak var lbl_title: UILabel!
    @IBOutlet weak var leftView: UIView!
    
    
    var title: String {
        set{
            lbl_title.text = newValue
        }
        get
        {
            return lbl_title.text ?? ""
        }
    }
    
    var isLeftButtonHidden: Bool {
        set {
            bell_button.isHidden = newValue
        }
        get {
            return bell_button.isHidden
        }
    }
    
    var isRightFirstButtonEnabled: Bool {
        set {
            menu_button.isEnabled = newValue
        }
        get {
            return menu_button.isEnabled
        }
    }
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(NavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    @IBAction func tap_bell_icon(_ sender: Any) {
        print("tap_bell_icon")
        navigationBarDelegate.openNotificationScreen!()
    }
    
    @IBAction func tap_cart_icon(_ sender: Any) {
        print("tap_cart_icon")
        navigationBarDelegate.openCartScreen!()
    }
    @IBAction func tap_user_icon(_ sender: Any) {
        print("tap_user_icon")
        navigationBarDelegate?.openProfileScreen!()
    }
    @IBAction func tap_menu_button(_ sender: UIButton) {
         print("tap_menu_button")
        navigationBarDelegate.openSettingScreen!()
    }
    @IBAction func backToView(_ sender: UIButton) {
        navigationBarDelegate?.backToview()
       }
}

extension UINavigationController {
    func hideNavigationLine(){
        //navigationBar.\
        setNavigationBarHidden(true, animated: true)
        //navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage(named: "")
    }
    //Remove the navigation bar bottom separator line
       func removeBottomNavigationbarSeparator() {
           navigationBar.shadowImage = UIImage()
       }
       
}
