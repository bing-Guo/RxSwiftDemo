import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import RxSwiftDemo

class RxSwiftDemoTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()

        let apiService = TestAPI()
        viewModel = ProductListViewModel(apiService: apiService)
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init_load_data() {
        let disposeBag = DisposeBag()

        let expect = expectation(description: #function)

        var result: [Product]!

        viewModel.data.asObservable()
            .skip(1) // 1
            .subscribe(onNext: {
                // 2
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 5.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }

            XCTAssertEqual(20, result.count)
        }
    }

    func test_init_load_data_ver_blocking() throws {
        let disposeBag = DisposeBag()

        let observable = viewModel.data.skip(1).map { $0.count }

        viewModel.data.subscribe().disposed(by: disposeBag)

        XCTAssertEqual(try observable.toBlocking().first(), 20)
    }

    func test_pull_to_refresh() throws {
        let disposeBag = DisposeBag()

        let expect = expectation(description: #function)

        var result: [Product]!

        let afterFirstload = viewModel.data.skip(1).take(1)

        afterFirstload
            .subscribe(onNext: { _ in
                self.viewModel.triggerAPI.onNext(())
            })
            .disposed(by: disposeBag)

        viewModel.data
            .skip(2)
            .subscribe(onNext: {
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)

        scheduler.start()

        waitForExpectations(timeout: 10.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }

            XCTAssertEqual(20, result.count)
        }
    }

    func test_betch_reload() throws {
        let disposeBag = DisposeBag()

        viewModel.data.skip(1).take(1)
            .subscribe(onNext: { _ in
                self.viewModel.triggerNextPage.onNext(())
            })
            .disposed(by: disposeBag)

        let observable = viewModel.data.skip(2).map { $0.count }

        observable.subscribe().disposed(by: disposeBag)

        XCTAssertEqual(try observable.toBlocking().first(), 21)
    }
}
