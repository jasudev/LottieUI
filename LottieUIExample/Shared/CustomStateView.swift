//
//  CustomStateView.swift
//  LottieUIExample
//
//  Created by jasu on 2022/02/12.
//  Copyright (c) 2022 jasu All rights reserved.
//

import SwiftUI
import LottieUI

struct CustomStateView: View {
    
    @State private var value: CGFloat = 0
    let state: LUStateData
    
    @State private var completedText: String = ""
    @State private var downloadedText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Value : \(value)")
                Spacer()
                Text(downloadedText)
                Divider().frame(height: 16)
                Text(completedText)
            }
            .frame(height: 26)
            LottieView(state: state, value: value, onCompleted: { success in
                completedText = "Completed"
            }, onDownloaded: { success in
                downloadedText = "Downloaded"
            })
            Slider(value: $value, in: 0...1)
        }
        .font(.caption)
    }
}

struct CustomStateView_Previews: PreviewProvider {
    static var previews: some View {
        CustomStateView(state: LUStateData())
    }
}
