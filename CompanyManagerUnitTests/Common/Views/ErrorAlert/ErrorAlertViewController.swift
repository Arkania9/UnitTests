//
//    ErrorAlertViewController.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

typealias ErrorAlertViewModel = ErrorAlertViewController.ViewModel
typealias ErrorAlertButton = (title: String, completionHandler: (() -> Void)?)

protocol ErrorProtocol {
  var title: String { get set }
  var message: String { get set }
  var buttons: [ErrorAlertButton] { get set }
}

protocol ErrorAlertRouter: class {
  func showErrorAlert(with: ErrorAlertViewModel)
}

extension ErrorAlertRouter where Self: UIViewController {
  
  func showErrorAlert(with viewModel: ErrorAlertViewModel) {
    let controller = ErrorAlertViewController(nibName: ErrorAlertViewController.reuseIdentifier, bundle: nil)
    controller.assign(viewModel: viewModel)
    controller.modalPresentationStyle = .overFullScreen
    DispatchQueue.main.async {
      self.present(controller, animated: true, completion: nil)
    }
  }
  
}

class ErrorAlertViewController: UIViewController {
  
  // MARK: - Structures
  
  struct ViewModel {
    var title: String
    var message: String
    var buttons: [ErrorAlertButton]
    var displayCompletion: (() -> Void)?
    
    init(from viewModel: ErrorProtocol, displayCompletion: (() -> Void)?) {
      title = viewModel.title
      message = viewModel.message
      buttons = viewModel.buttons
      self.displayCompletion = displayCompletion
    }
    
    init(title: String, message: String, buttons: [ErrorAlertButton], displayCompletion: (() -> Void)?) {
      self.title = title
      self.message = message
      self.buttons = buttons
      self.displayCompletion = displayCompletion
    }
  }
  
  // MARK: - Outlets
  
  @IBOutlet weak var alertView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var buttonsStackView: UIStackView!
  
  // MARK: - Properties
  
  private var viewModel: ViewModel?
  private static let fadeDuration = 0.2
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.alpha = 0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupView(with: viewModel)
  }
  
  // MARK: - Actions
  
  @IBAction func buttonAction(_ sender: RoundedButton) {
    guard let buttons = viewModel?.buttons, buttons.indices.contains(sender.tag) else {
      dismissView()
      return
    }
    buttons[sender.tag].completionHandler?()
    dismissView()
  }
  
  @IBAction func backgroundTapGestureAction(_ sender: UITapGestureRecognizer) {
    dismissView()
  }
  // MARK: - Functions
  
  func assign(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupView(with viewModel: ViewModel?) {
    guard let viewModel = viewModel else {
      Log.e("There is no viewModel to display in \(ErrorAlertViewController.reuseIdentifier)")
      return
    }
    titleLabel.text = viewModel.title
    messageLabel.text = viewModel.message
    viewModel.buttons.enumerated().forEach { [weak self] (offset: Int, element: ErrorAlertButton) in
      self?.addButton(title: element.title, isLast: offset == viewModel.buttons.count - 1)
    }
    animateView()
  }
  
  private func animateView() {
    UIView.animate(withDuration: ErrorAlertViewController.fadeDuration, animations: { [weak self] in
      self?.view.alpha = 1
      }, completion: { [weak self] isCompleted in
        if isCompleted {
          self?.viewModel?.displayCompletion?()
        }
    })
  }
  
  private func dismissView() {
    UIView.animate(withDuration: ErrorAlertViewController.fadeDuration, animations: { [weak self] in
      self?.view.alpha = 0
      }, completion: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    })
  }
  
  private func addButton(title: String, isLast: Bool) {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.tag = buttonsStackView.arrangedSubviews.count
    button.setTitleColor(#colorLiteral(red: 0.2612428069, green: 0.3115406632, blue: 0.395151794, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1), for: .highlighted)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    button.backgroundColor = UIColor(red: 242/255, green: 246/255, blue: 248/255, alpha: 1)
    if !isLast {
      let separatorView = UIView()
      separatorView.frame.size = CGSize(width: 1, height: 29)
      separatorView.backgroundColor = UIColor(red: 226/255, green: 232/255, blue: 237/255, alpha: 1)
      separatorView.translatesAutoresizingMaskIntoConstraints = false
      button.addSubview(separatorView)
      separatorView.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
      separatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
      separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
      separatorView.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
    buttonsStackView.addArrangedSubview(button)
  }
  
}
