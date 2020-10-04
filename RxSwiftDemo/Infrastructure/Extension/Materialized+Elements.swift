//
//  Materialized+Elements.swift
//  RxSwiftDemo
//
//  Created by Bing Guo on 2020/9/16.
//  Copyright © 2020 Bing Guo. All rights reserved.
//  See: https://github.com/RxSwiftCommunity/RxSwiftExt/blob/master/Source/RxSwift/materialized+elements.swift

import Foundation
import RxSwift

extension ObservableType where Element: EventConvertible {

    /**
     Returns an observable sequence containing only next elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func elements() -> Observable<Element.Element> {
        return compactMap { $0.event.element }
    }

    /**
     Returns an observable sequence containing only error elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func errors() -> Observable<Swift.Error> {
        return compactMap { $0.event.error }
    }

}
