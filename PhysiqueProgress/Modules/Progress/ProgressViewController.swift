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
    
    private let chartView = LineChartView()
    private var isPremiumUser = false


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progress Analytics"
        view.backgroundColor = .systemBackground
        setupTable()
        setupChart()
        checkPremium()
        loadData()
    }

    private func loadData() {
        viewModel.load()
        tableView.reloadData()
        
        if isPremiumUser {
            chartView.values = viewModel.overallScores().reversed()
        }
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
    
    private func checkPremium() {
        Task {
            isPremiumUser = await SubscriptionManager.shared.hasPremiumAccess()
            updateUIForAccess()
        }
    }

    private func setupChart() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func updateUIForAccess() {
        if PremiumFeatureGate.canAccessPremiumFeatures(isPremium: isPremiumUser) {
            FirebaseAnalyticsService.shared.logPremiumAnalyticsViewed()
            chartView.isHidden = false
        } else {
            FirebaseAnalyticsService.shared
                .logFreeAnalyticsViewed()
            chartView.isHidden = true
            showUpgradeBanner()
        }
    }
    
    private func showUpgradeBanner() {
        let banner = UILabel()
        banner.text = "🔒 Upgrade to Premium to see progress charts"
        banner.textAlignment = .center
        banner.textColor = .systemRed
        banner.numberOfLines = 0
        banner.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }


}
