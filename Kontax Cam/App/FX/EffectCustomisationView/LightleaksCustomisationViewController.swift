//
//  LightleaksCustomisationViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

class LightleaksCustomisationViewController: UIViewController {

    private let step: Float = 1

    private let slider: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.minimumValue = 1
        v.maximumValue = 10
        v.isContinuous = true
        v.tintColor = .label
        return v
    }()
    private let containerView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let controlView = CustomisationControlHeaderView()
    weak var delegate: FXCollectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("Light leaks".localized)
        self.addCloseButton()
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        // Overwrite the strengthLabel and slider
        let strLoc = "Strength".localized
        controlView.controlTitleLabel.text = "\(strLoc): +\(FilterValue.Grain.strength)"
        slider.setValue(Float(FilterValue.Lightleaks.strength), animated: true)
        
        // Add event listener for the slider
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        
        // Setup delegate
        controlView.delegate = self
    }
    
    private func setupView() {
        view.addSubview(containerView)
        view.addSubview(controlView)
        
        containerView.addSubview(slider)
    }
    
    private func setupConstraint() {
        controlView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
            make.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(115)
            make.centerX.equalToSuperview()
            make.top.equalTo(controlView.snp.bottom)
        }
        
        slider.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
        }
    }
    
    @objc private func sliderValueDidChange(_ sender: UISlider!) {
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        let strLoc = "Strength".localized
        DispatchQueue.main.async {
            self.controlView.controlTitleLabel.text = "\(strLoc): +\(roundedStepValue)"
        }
    }

}

extension LightleaksCustomisationViewController: CustomisationControlProtocol {
    func didTapDone() {
        FilterValue.Lightleaks.strength = CGFloat(slider.value)
        print("Lightleaks strength new value: \(FilterValue.Dust.strength)")
        TapticHelper.shared.successTaptic()
        delegate?.didTapDone()
        dismiss(animated: true, completion: nil)
    }
}
