import UIKit

final class ProgressViewController: UIViewController {

    private let viewModel = ProgressViewModel()

    private let tableView = UITableView()
    private let chartView = LineChartView()
    private let upgradeBanner = UILabel()

    private var isPremiumUser = false

    private var tableTopToBanner: NSLayoutConstraint!
    private var tableTopToChart: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progress Analytics"
        view.backgroundColor = .systemBackground

        setupViews()
        setupLayout()
        setupTable()

        checkPremium()
        loadData()
    }

    private func setupViews() {

        // Banner
        upgradeBanner.text = "🔒 Upgrade to Premium to see progress charts"
        upgradeBanner.textAlignment = .center
        upgradeBanner.textColor = .systemRed
        upgradeBanner.numberOfLines = 0
        upgradeBanner.translatesAutoresizingMaskIntoConstraints = false

        // Chart
        chartView.translatesAutoresizingMaskIntoConstraints = false

        // Table
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(upgradeBanner)
        view.addSubview(chartView)
        view.addSubview(tableView)
    }

    private func setupLayout() {

        tableTopToBanner = tableView.topAnchor.constraint(equalTo: upgradeBanner.bottomAnchor, constant: 12)
        tableTopToChart = tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 12)

        NSLayoutConstraint.activate([

            // Banner
            upgradeBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            upgradeBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            upgradeBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Chart
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 200),

            // Table (bottom always fixed)
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTable() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func loadData() {
        viewModel.load()
        tableView.reloadData()
    }

    private func checkPremium() {
        Task {
            isPremiumUser = await SubscriptionManager.shared.hasPremiumAccess()
            updateUIForAccess()
        }
    }

    private func updateUIForAccess() {
        if PremiumFeatureGate.canAccessPremiumFeatures(isPremium: isPremiumUser) {
            FirebaseAnalyticsService.shared.logPremiumAnalyticsViewed()
            chartView.isHidden = false
            tableTopToChart.isActive = true
            chartView.values = viewModel.bodyOverallScores().reversed()
        } else {
            FirebaseAnalyticsService.shared
                .logFreeAnalyticsViewed()
            chartView.isHidden = true
            tableTopToBanner.isActive = true
        }

        view.layoutIfNeeded()
    }
}

extension ProgressViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        guard let entry = viewModel.entry(at: indexPath.row) else {
            cell.textLabel?.text = "Invalid entry"
            return cell
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(formatter.string(from: entry.date))

        Overall: \(Int(entry.overallScore))
        Physique: \(Int(entry.physiqueScore))
        FatIndex: \(String(format: "%.2f", entry.fatIndex))
        V-taper: \(String(format: "%.2f", entry.vTaper))
        """

        return cell
    }
}
