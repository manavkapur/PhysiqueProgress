//
//  SettingsViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 23/01/26.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {

    private let deletionService = AccountDeletionService()

    private enum Section: Int, CaseIterable {
        case account
        case app
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        setupTable()
    }

    // MARK: - Table setup

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - DataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == Section.account.rawValue ? 3 : 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == Section.account.rawValue ? "Account" : "App"
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .label
        cell.accessoryType = .disclosureIndicator

        if indexPath.section == Section.account.rawValue {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Change password"
            case 1:
                cell.textLabel?.text = "Logout"
            case 2:
                cell.textLabel?.text = "Delete account"
                cell.textLabel?.textColor = .systemRed
                cell.accessoryType = .none
            default: break
            }
        } else {
            cell.textLabel?.text = indexPath.row == 0 ? "Privacy Policy" : "Terms & Conditions"
        }

        return cell
    }
}

// MARK: - Delegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == Section.account.rawValue {
            switch indexPath.row {
            case 0: openChangePassword()
            case 1: confirmLogout()
            case 2: confirmDeleteAccount()
            default: break
            }
        } else {
            openWeb(indexPath.row == 0
                ? "https://manavkapur.github.io/physiqueprogress-legal/privacy"
                : "https://manavkapur.github.io/physiqueprogress-legal/terms")
        }
    }
}

// MARK: - Account actions

private extension SettingsViewController {

    func openChangePassword() {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }

    func confirmLogout() {
        let alert = UIAlertController(title: "Logout?",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.logout()
        })

        present(alert, animated: true)
    }

    func logout() {
        PushManager.shared.clearTokenOnLogout()
        try? Auth.auth().signOut()
        switchToAuth()
    }

    func confirmDeleteAccount() {
        let alert = UIAlertController(
            title: "Delete account",
            message: "This will permanently delete your account and all progress data. This action cannot be undone.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.performAccountDeletion()
        })

        present(alert, animated: true)
    }

    func performAccountDeletion() {

        let loader = UIAlertController(title: nil, message: "Deleting account...", preferredStyle: .alert)
        present(loader, animated: true)

        deletionService.deleteAccount { [weak self] result in
            DispatchQueue.main.async {
                loader.dismiss(animated: true)

                switch result {
                case .success:
                    LocalFileManager.shared.deleteAllImages()
                    ProgressRepository().deleteLocalUserFile()
                    try? Auth.auth().signOut()
                    self?.switchToAuth()

                case .failure(let error as NSError):
                    if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                        self?.showError("For security reasons, please logout and login again, then retry deleting your account.")
                    } else {
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

private extension SettingsViewController {

    func openWeb(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }

    func switchToAuth() {
        guard let scene = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        scene.switchToAuth()
    }

    func showError(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
