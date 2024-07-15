//
//  AnimatedButton.swift
//  AnimatedButton
//
//  Created by Glocify technology on 04/07/24.
//

public typealias emptyClouser = () -> ()


//MARK: Enum for loading type values
public enum LoadingType :Int,CaseIterable {
    case indicator,progress
}

import UIKit

public class AnimatedButton : UIButton {
    
    //MARK: Varaibles
    private var activity = UIActivityIndicatorView()
    private var timer = Timer()
    private var count = 0
    private var view = UIView()
    private var lodingType : LoadingType = .indicator
    var loadingColor : UIColor = .darkGray //you can change loading according to your app theme
    var loadingText = "Please wait" //you can change loading text to your requirement
    var pressAction : emptyClouser!
    @IBInspectable var loading : Int {   //you can change loading type from storyboard
        get {
            return self.loading
        } set {
            for val in LoadingType.allCases {
                if val.rawValue == newValue {
                    lodingType = val
                    break
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButtonTarget()
    }
    
    deinit {
        self.timer.invalidate()
        if let vw = self.viewWithTag(10001) {
            vw.removeFromSuperview()
        }
        if let vw = self.viewWithTag(10002) {
            vw.removeFromSuperview()
        }
    }
    
    // Setup button action
    func setButtonTarget(){
        view.tag = 10001
        activity.tag = 10002
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
    }
    
    // Setup button loading type
    @objc func buttonTapped(){
        switch lodingType {
        case .progress:
            loadingTypeProgress()
        case .indicator:
            loadingTypeIndicator()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            guard (self.pressAction != nil) else {return}
            self.pressAction()
        }
    }
    
    
    func loadingTypeProgress(){
        view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
        view.backgroundColor = loadingColor
        self.addSubview(view)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = loadingText
        label.textColor = self.titleLabel?.textColor ?? .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.setTitle("", for: .normal)
            self.addSubview(label)
        }
        count = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showProgress), userInfo: nil, repeats: true)
        
    }
    // Setup activity indicator on button
    func loadingTypeIndicator(){
        self.setTitle(loadingText, for: .normal)
        activity = UIActivityIndicatorView(frame: CGRect(x: Int(self.frame.size.width - 40), y:( Int(self.frame.size.height) / 2) - 6 , width: 12, height: 12))
        activity.color = .white
        activity.style = .medium
        self.addSubview(activity)
        activity.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.activity.stopAnimating()
            if let vw = self.viewWithTag(10002) {
                vw.removeFromSuperview()
            }
        }
    }
    
    //MARK: Setup progress on button
    @objc func showProgress(){
        count += 1
        if count > 10 {
            timer.invalidate()
            if let vw = self.viewWithTag(10001) {
                vw.removeFromSuperview()
            }
        } else {
            let width = self.frame.size.width/10
            view.frame = CGRect(x: 0, y: 0, width:width*CGFloat(count), height: self.frame.size.height)
        }
    }
}
