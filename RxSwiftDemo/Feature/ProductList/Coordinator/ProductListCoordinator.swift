import Foundation
import RxCocoa
import RxSwift
import UIKit

class ProductListCoordinator: Coordinator<ProductListViewModel.FinishReason> {
    
    // MARK: - Private
    private let container: AppCoordinatorContainer
    
    // MARK: - Constructor
    
    init(container: AppCoordinatorContainer) {
        self.container = container
    }
    
    // MARK: - Override
    override func start() -> Observable<ProductListViewModel.FinishReason> {
        let viewModel = ProductListViewModel(apiService: ProductAPI())
        let viewController = ProductListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        container.add(navigationController)

        viewModel.showError
            .subscribe(onNext: {
                let alert = UIAlertController(title: "錯誤", message: $0.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                alert.addAction(okAction)

                viewController.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return viewModel.didClose.take(1).do(afterNext: { _ in viewController.dismiss(animated: true, completion: nil)})
        
    }
}
