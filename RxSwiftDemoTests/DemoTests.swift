import XCTest
import RxTest
import RxSwift
import RxBlocking

class DemoTests: XCTestCase {

    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()

        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRxTestExample() {
        let disposeBag = DisposeBag()

        let observer = scheduler.createObserver(Int.self)

        let observable = scheduler.createHotObservable([
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 2),
            Recorded.next(500, 1)
        ])

        let filterObservable = observable.filter { $0 < 3 }

        filterObservable.subscribe(observer).disposed(by: disposeBag)

        scheduler.start()

        let results = observer.events.compactMap { $0.value.element }

        XCTAssertEqual(results, [1, 2, 2, 1])
    }

    func testRxBlockingExample() throws {
        let observable = Observable.of(1, 2, 3, 2, 5).filter { $0 < 3 }

        let result = observable.toBlocking()

        XCTAssertEqual(try result.first(), 1)
        XCTAssertEqual(try result.last(), 2)
        XCTAssertEqual(try result.toArray(), [1, 2, 2])
    }

}
