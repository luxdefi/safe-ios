//
//  LoadableView.swift
//  Multisig
//
//  Created by Andrey Scherbovich on 24.06.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

protocol LoadableViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
}

protocol LoadableView: View {
    associatedtype LoadableModel: LoadableViewModel
    var model: LoadableModel { get }
}

struct Loadable<V: LoadableView>: View {
    private let view: V

    @ObservedObject
    private var model: V.LoadableModel

    init(_ view: V) {
        self.view = view
        self.model = view.model
    }

    var body: some View {
        ZStack(alignment: .center) {
            if model.isLoading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else if model.errorMessage != nil {
                ErrorText(model.errorMessage!)
            } else {
                view
            }
        }
    }
}
