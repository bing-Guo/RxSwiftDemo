import Foundation
import RxSwift
import RxCocoa

extension ProductListViewModel {
    
    enum FinishReason {
        case cancel
    }
    
}

class ProductListViewModel {
    
    // MARK: - Input
    let apiService: ProductAPIProtocol
    let triggerAPI: AnyObserver<Void>
    let triggerNextPage: AnyObserver<Void>
    
    // MARK: - Output
    let didClose: Observable<FinishReason>
    let isLoading: Observable<Bool>
    let data: Observable<[Product]>
    let page: Observable<Int>
    let showError: Observable<Error>
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    // MARK: - Constructor
    init(apiService: ProductAPIProtocol) {
        self.apiService = apiService
        didClose = .never()

        let pageRelay = BehaviorRelay<Int>(value: 1)
        page = pageRelay.asObservable()

        let productListRelay = BehaviorRelay<[Product]>(value: [])
        data = productListRelay.asObservable()

        let indicator = ActivityIndicator()
        isLoading = indicator.asObservable()

        let triggerAPISubject = PublishSubject<Void>()
        triggerAPI = triggerAPISubject.asObserver()

        let triggerNextPageSubject = PublishSubject<Void>()
        triggerNextPage = triggerNextPageSubject.asObserver()

        let fetchProductListResult = triggerAPISubject.asObservable().startWith(())
            .flatMapLatest { _ in apiService.request(page: 1).trackActivity(indicator).materialize() }
            .share()

        fetchProductListResult.elements()
            .bind { products -> Void in
                pageRelay.accept(1)
                productListRelay.accept(products)
            }
            .disposed(by: disposeBag)

        let nextProductListResult = triggerNextPageSubject.asObservable()
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest { _ in apiService.request(page: pageRelay.value+1).trackActivity(indicator).materialize() }
            .share()

        nextProductListResult.elements()
            .bind { products -> Void in
                let newPage = pageRelay.value + 1
                let newData = productListRelay.value + products

                pageRelay.accept(newPage)
                productListRelay.accept(newData)
            }
            .disposed(by: disposeBag)

        showError = Observable.merge(fetchProductListResult.errors(),
                                     nextProductListResult.errors())
    }
}

