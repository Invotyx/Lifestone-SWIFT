//
//  AMPagerTabController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 21/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

var UserTapped = ""
enum UserRoleKey : String
{
    case Follow = "Follow"
    case Loved = "Loved"
    case User = "User"
}

import Foundation
import UIKit

open class AMPagerTabsViewController1: UIViewController {
    
    // MARK: - Properties
    
    /// The object that acts as the delegate of the `AMPagerTabsViewController`.
    public var delegate: AMPagerTabsViewControllerDelegate?
    /// The property that hold the style and settings for the `AMPagerTabsViewController`.
    public let settings = AMSettings()
    
    /// The `ViewContollers` you want to show in the tabs.
    public var viewControllers: [UIViewController] = [] {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You can't set the viewControllers twice")
        }
        didSet {
            addTabButtons()
            moveToViewContollerAt(index: firstSelectedTabIndex)
        }
    }
    
    /// The first selected item when the tabs loaded.
    public var firstSelectedTabIndex = 0 {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the first selected tab index before set the viewcontrollers")
        }
    }
    
    /// The custom font for the tab title.
    public var tabFont: UIFont = UIFont.systemFont(ofSize: 17) {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the font before set the viewcontrollers")
        }
    }
    
    /// A Boolean value that indicates if the tabs should fit in the screen
    /// or should go out of the screen. `true` is the default.
    public var isTabButtonShouldFit = false {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the isTabButtonShouldFit before set the viewcontrollers")
        }
    }
    
    /// A Boolean value that determines whether scrolling is enabled.
    public var isPagerScrollEnabled: Bool = true{
        didSet{
            containerScrollView.isScrollEnabled = isPagerScrollEnabled
        }
    }
    
    /// The color of the line in the tab.
    public var lineColor: UIColor? {
        get {
            return line.backgroundColor
        }
        set {
            line.backgroundColor = newValue
        }
    }
    
    // MARK: Private properties
    
    private var tabScrollView: UIScrollView!
    private var containerScrollView: UIScrollView!
    
    private var tabButtons: [AMTabButton1] = []
    private var line = AMLineView1()
    private var lastSelectedViewIndex = 0
    
    // MARK: - ViewController lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //    let vu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        //    self.view.addSubview(vu)
        //    let vu1 = UIView(frame: CGRect(x: 0, y: settings.tabHeight+1, width: self.view.frame.size.width, height: 1))
        //    self.view.addSubview(vu1)
        
        
        //    self.view.layer.borderColor = UIColor.white.cgColor
        //    self.view.layer.borderWidth = 0.8
        initScrollView()
        
        updateScrollViewsFrames()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        children.forEach { $0.beginAppearanceTransition(true, animated: animated) }
      
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateScrollViewsFrames()
        children.forEach { $0.endAppearanceTransition() }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        children.forEach { $0.beginAppearanceTransition(false, animated: animated) }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        children.forEach { $0.endAppearanceTransition() }
    }
    
    
    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let controller = self else{ return }
            controller.updateSizes()
        })
        
    }
    
    
    private func initScrollView() {
        //    let frm = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height)
        tabScrollView = UIScrollView(frame: CGRect.zero)//CGRect.zero
        tabScrollView.backgroundColor = AppDelegate.linecolor//settings.tabBackgroundColor
        tabScrollView.bounces = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        
        let frm1 = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height-300)
        containerScrollView = UIScrollView(frame: frm1)//view.frame
        containerScrollView.backgroundColor = AppDelegate.linecolor//settings.pagerBackgroundColor
        containerScrollView.delegate = self
        containerScrollView.bounces = false
        containerScrollView.scrollsToTop = false
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.isPagingEnabled = true
        containerScrollView.isScrollEnabled = isPagerScrollEnabled
        
        //    let vu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        //    self.containerScrollView.addSubview(vu)
        //    let vu1 = UIView(frame: CGRect(x: 0, y: settings.tabHeight+1, width: self.view.frame.size.width, height: 1))
        //    self.containerScrollView.addSubview(vu1)
        
        self.view.addSubview(containerScrollView)
        self.view.addSubview(tabScrollView)
    }
    
    private func addTabButtons() {
        
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        // Devide the width of the view between the tabs
        var width = viewWidth / viewControllerCount
        let widthOfAllTabs = (viewControllerCount * settings.initialTabWidth)
        if !isTabButtonShouldFit && viewWidth < widthOfAllTabs {
            width = settings.initialTabWidth
        }
        
        for i in 0..<viewControllers.count
        {
            let tabButton = AMTabButton1(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: settings.tabHeight))
            let title = viewControllers[i].title
            if title == nil
            {
                assertionFailure("You need to set a title for the view contoller \(String(describing: viewControllers[i])) , index: \(i)")
            }
            tabButton.setTitle(title , for: .normal)
            tabButton.backgroundColor = settings.tabButtonColor
            tabButton.setTitleColor(settings.tabButtonTitleColor, for: .normal)
            tabButton.titleLabel?.font = tabFont
            tabButton.index = i
            tabButton.addTarget(self, action: #selector(tabClicked(sender:)), for: .touchUpInside)
            tabScrollView.addSubview(tabButton)
            tabButtons.append(tabButton)
        }
        
        line.frame = tabButtons.first!.frame
        line.backgroundColor = lineColor ?? UIColor.white
        tabScrollView.addSubview(line)
    }
    
    // MARK: - Controlling tabs
    
    @objc private func tabClicked(sender: AMTabButton1){
        
        moveToViewContollerAt(index: sender.index!)
    }
    
    /// Move the view controller to the passed index
    ///
    /// - parameter index: The index of the view controller to show
    public func moveToViewContollerAt(index: Int) {
        
        lastSelectedViewIndex = index
        
        let barButton = tabButtons[index]
        animateLineTo(frame: barButton.frame)
        
        let contoller = viewControllers[index]
        if contoller.view?.superview == nil {
            addChild(contoller)
            containerScrollView.addSubview(contoller.view)
            contoller.didMove(toParent: self)
            updateSizes()
        }
        
        changeShowingControllerTo(index: index)
        
        delegate?.tabDidChangeTo(index)
    }
    
    private func changeShowingControllerTo(index: Int) {
        containerScrollView.setContentOffset(CGPoint(x: self.view.frame.size.width*(CGFloat(index)), y: 0), animated: true)
    }
    
    // MARK: - Animation
    
    private func animateLineTo(frame: CGRect) {
        
        UIView.animate(withDuration: 0.1) {
            self.line.frame = frame
            self.line.draw(frame)
            if frame.origin.x >= 300{
                let bottomOffset = CGPoint(x: self.tabScrollView.contentSize.width - self.tabScrollView.bounds.size.width, y: 0)
                self.tabScrollView.setContentOffset(bottomOffset, animated: true)
            }
            if frame.origin.x < 300{
                 let TopOffset = CGPoint(x: 0, y: 0)
                self.tabScrollView.setContentOffset(TopOffset, animated: true)
            }
        }
    }
    
    // MARK: - Setup Sizes
    
    private func updateScrollViewsFrames() {
        
        tabScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: settings.tabHeight)
        containerScrollView.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height - settings.tabHeight)
        
        //  settings.tabHeight
    }
    
    private func updateSizes() {
        
        updateScrollViewsFrames()
        
        let width = self.view.frame.size.width
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        var tabWidth = viewWidth / viewControllerCount
        if !isTabButtonShouldFit && viewWidth < (viewControllerCount * settings.initialTabWidth) {
            tabWidth = settings.initialTabWidth
        }
        
        for i in 0..<viewControllers.count {
            let view = viewControllers[i].view
            let tabButton = tabButtons[i]
            view?.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: containerScrollView.frame.size.height)
            tabButton.frame = CGRect(x: tabWidth*CGFloat(i), y: 0, width: tabWidth, height: settings.tabHeight)
        }
        
        containerScrollView.contentSize = CGSize(width: width*viewControllerCount, height: containerScrollView.frame.size.height)
        tabScrollView.contentSize = CGSize(width: tabWidth*viewControllerCount, height: settings.tabHeight)
        
        changeShowingControllerTo(index: lastSelectedViewIndex)
        
        animateLineTo(frame: tabButtons[lastSelectedViewIndex].frame)
        
    }
    
    private func checkIfCanChangeValue(withErrorMessage message:String) {
        if viewControllers.count != 0 {
            assertionFailure(message)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension AMPagerTabsViewController1:UIScrollViewDelegate {
    
    var currentPage: Int {
        
        return Int((containerScrollView.contentOffset.x + (0.5*containerScrollView.frame.size.width))/containerScrollView.frame.width)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false {
            moveToViewContollerAt(index: currentPage)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        moveToViewContollerAt(index: currentPage)
      
        if UserTapped == UserRoleKey.Follow.rawValue{
//             objdetailsFollow.changeImage(index: currentPage)
        }
        if UserTapped == UserRoleKey.Loved.rawValue{
//              objdetailsLoved.changeImage(index: currentPage)
        }
        if UserTapped == UserRoleKey.User.rawValue{
            
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
       
    }
}
//
//public class AMSettings{
//
//    public var tabBackgroundColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
//    public var tabButtonColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
//    public var tabButtonTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    public var pagerBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//    public var initialTabWidth:CGFloat = 100
//    public var tabHeight:CGFloat = 60
//}
//
//// MARK: - AMTabViewControllerDelegate
//
///// The delegate of the `AMPagerTabsViewController` contoller must
///// adopt the `AMPagerTabsViewControllerDelegate` protocol to get notfiy when tab change
//public protocol AMPagerTabsViewControllerDelegate {
//    /// Tells the delegate that the tab changed to `index`
//    ///
//    /// - parameter index: The index of the current view controller
//    func tabDidChangeTo(_ index:Int);
//}

