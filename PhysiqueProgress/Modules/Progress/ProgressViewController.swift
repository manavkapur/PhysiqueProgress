//
//  ProgressViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import UIKit

final class ProgressViewController: UIViewController {

    private let viewModel = ProgressViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progress Analytics"
        view.backgroundColor = .systemBackground
        setupTable()
        loadData()
    }

    private func loadData() {
        viewModel.load()
        tableView.reloadData()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ProgressViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )

        guard let entry = viewModel.entry(at: indexPath.row) else {
            cell.textLabel?.text = "Invalid entry"
            return cell
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(formatter.string(from: entry.date))
        Overall Score: \(Int(entry.overallScore))
        """

        return cell
    }
}
