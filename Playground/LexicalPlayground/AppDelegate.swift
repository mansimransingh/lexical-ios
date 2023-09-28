/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

class ParentViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func centerButtonIn(view: UIView, button: UIButton) {
    // Ensure the button is a subview
    if button.superview != view {
      view.addSubview(button)
    }

    // Turn off autoresizing masks for Auto Layout
    button.translatesAutoresizingMaskIntoConstraints = false

    // Center the button in the view
    let centerXConstraint = NSLayoutConstraint(item: button,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .centerX,
                                               multiplier: 1,
                                               constant: 0)

    let centerYConstraint = NSLayoutConstraint(item: button,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0)

    // Activate the constraints
    NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
  }

  private func setup() {

    view.backgroundColor = .white


    let button = UIButton(type: .system)
    button.setTitle("Click Me", for: .normal)
    centerButtonIn(view: view, button: button)

    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
  }

  @objc
  private func onTap() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    guard let window else { return false }
    window.makeKeyAndVisible()
    let viewController = ParentViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    window.rootViewController = navigationController
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    persistEditorState()
  }

  func persistEditorState() {
    guard let viewController = window?.rootViewController as? ViewController else {
      return
    }

    viewController.persistEditorState()
  }
}
