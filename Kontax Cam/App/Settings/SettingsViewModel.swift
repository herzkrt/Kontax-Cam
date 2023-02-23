//
//  SettingsViewModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

protocol SettingsViewModelDelegate: AnyObject {
    func appearanceTapped()
    func apppIconsTapped()
    func restorePurchaseTapped()
    
    func twitterTapped()
    func instagramTapped()
    func websiteTapped()
    func emailTapped()
    func changelogTapped()
    
    func surveyFormTapped()
    func privacyTapped()
    func deleteAllTapped()
}

class SettingsViewModel: NSObject {
    
    static let ReuseIdentifier = "SettingsCell"
    private weak var delegate: SettingsViewModelDelegate?
    private var tableviewSections = [SettingsSection]()
    
    init(delegate: SettingsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        configureDatasource()
    }
    
    private func configureDatasource() {
        let generalSection = SettingsSection(
            title: "General".localized,
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Appearance".localized) },
                    action: { [weak self] _ in self?.delegate?.appearanceTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Alternate app icons".localized) },
                    action: { [weak self] _ in self?.delegate?.apppIconsTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Restore purchase".localized, accessoryType: .none) },
                    action: { [weak self] _ in self?.delegate?.restorePurchaseTapped() }
                )
            ])
        
        let informationSection = SettingsSection(
            title: "Information".localized,
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Twitter".localized) },
                    action: { [weak self] _ in self?.delegate?.twitterTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Instagram".localized) },
                    action: { [weak self] _ in self?.delegate?.instagramTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Website".localized) },
                    action: { [weak self] _ in self?.delegate?.websiteTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Email".localized) },
                    action: { [weak self] _ in self?.delegate?.emailTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Change log".localized) },
                    action: { [weak self] _ in self?.delegate?.changelogTapped() }
                )
            ])
        
        let otherStuffSection = SettingsSection(
            title: "Others".localized,
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Feedback".localized) },
                    action: { [weak self] _ in self?.delegate?.surveyFormTapped() }
                ),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Privacy policy".localized) },
                    action: { [weak self] _ in self?.delegate?.privacyTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.ReuseIdentifier)
                        cell.textLabel?.text = "Delete lab images".localized
                        cell.textLabel?.textColor = .systemRed
                        cell.accessoryType = .none
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.deleteAllTapped() })
            ])
        
        self.tableviewSections = [generalSection, informationSection, otherStuffSection]
    }
    
    /// Helper to create a cell with a title
    private func createNormalCell(withTitle title: String, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.ReuseIdentifier)
        cell.textLabel?.text = title
        cell.accessoryType = accessoryType
        return cell
    }
}

extension SettingsViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewSections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableviewSections[indexPath.section].cells[indexPath.row].createdCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableviewSections[indexPath.section].cells[indexPath.row]
        cell.action?(cell)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableviewSections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = tableviewSections[section].title
        }
    }
}
