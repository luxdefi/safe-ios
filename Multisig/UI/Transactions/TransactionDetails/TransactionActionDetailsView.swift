//
//  ActionDetailsView.swift
//  Multisig
//
//  Created by Moaaz on 8/20/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct TransactionActionDetailsView: View {
    var dataDecoded: DataDecoded
    var data: DataWithLength
    var body: some View {
        List {
            HexDataCellView(data: data)

            if hasParamters {
                ForEach(dataDecoded.parameters!) { paramter in
                    ParameterView(parameter: paramter)
                }
            } else {
                Text("No parameters").body()
            }
        }
        .navigationBarTitle(dataDecoded.method)
        .onAppear {
            self.trackEvent(.transactionsDetailsAction)
        }
    }

    var hasParamters: Bool {
        !(dataDecoded.parameters ?? []).isEmpty
    }
}
