//
//  SetupViewController.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    // The View Model for this VC
    let viewModel = SetupViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        performAnimations()
        textInput.text = viewModel.username
        textInput.delegate = self
        checkInput()
        
         textInput.addTarget(self, action: #selector(textInputDidChange(_:)), for: .editingChanged)
    }
    
    // A little bit of eye candy to welcome the user
    func performAnimations() {
        // Make the background darker
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.backgroundImageView.alpha = 0.5
        }
        
        subtitleLabel.isHidden = true
        textInput.isHidden = true
        doneButton.isHidden = true

        // Bounce the title around
        titleLabel.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 40, options: .curveEaseIn, animations: { [weak self] in
            self?.titleLabel.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            }, completion: { [weak self] done in
                guard let weakSelf = self else { return }
                weakSelf.textInput.becomeFirstResponder()
                weakSelf.subtitleLabel.isHidden = false
                weakSelf.textInput.isHidden = false
                weakSelf.doneButton.isHidden = false
        })
    }

    @IBAction func donePressed(_ sender: Any) {
        editingFinished()
    }
    
    func editingFinished() {
        guard let username = textInput.text else { return }
        let mapCoordinator = MapCoordinator(parentViewController: self, username: username)
        mapCoordinator.start()
    }
    
    // Check if the input is valid - turn buttons on/off
    func checkInput() {
        let text = self.textInput.text
        doneButton.isEnabled = viewModel.validUsername(username: text)
    }
    
    // If the input changed, we need to refresh the UI state
    @objc func textInputDidChange(_ textField: UITextField) {
        checkInput()
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkInput()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard viewModel.validUsername(username: textField.text) else {
            return false
        }
        editingFinished()
        return true
    }
}
