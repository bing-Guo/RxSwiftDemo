import UIKit
import RxSwift
import SnapKit

class ProductListViewController: UIViewController {
    
    // MARK: - Private
    private let viewModel: ProductListViewModel
    private let disposeBag = DisposeBag()

    private let refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero)

        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 44
        tv.rowHeight = UITableView.automaticDimension

        tv.register(ProductListCell.self, forCellReuseIdentifier: String(describing: ProductListCell.self))

        return tv
    }()

    // MARK: - Constructor
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        bindViewModel()
    }
}

extension ProductListViewController {

    func setupTableView() {
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.addSubview(refreshControl)
    }

    func setupNavigation() {
        navigationItem.title = "範例一"
    }

    func bindViewModel() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.data
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductListCell.self)) as? ProductListCell else { return UITableViewCell() }

                cell.config(item: element)

                return cell
        }
        .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.triggerAPI).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
    }
    
}

extension ProductListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1

        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            viewModel.triggerNextPage.onNext(())
        }
    }

}
