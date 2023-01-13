//
//  DemoView.swift
//  
//
//  Created by Chiaote Ni on 2022/12/30.
//

import UIKit
import SwiftUI

class DemoView: UIView {

    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(updateBatteryLevel))
    private lazy var batteryView: BatteryView = {
        let view = BatteryView(frame: bounds)
        addSubview(view)
        return view
    }()

    private var currentProgress: Float = 0
    private var diffValue: Float = 0.01

    override init(frame: CGRect) {
        super.init(frame: frame)
        displayLink.add(to: .main, forMode: .common)
        displayLink.preferredFramesPerSecond = 60

//        Task { @MainActor in
//            await executeLongTimeJob()
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        displayLink.isPaused = true
        displayLink.invalidate()
    }

    func runLongTimeJob() {
        Task { @MainActor in
            Logger.logCurrentThread(withPrefix: "🛣🛣 0")
            await executeLongTimeJob()
            Logger.logCurrentThread(withPrefix: "🛣🛣 1")
        }
    }

    @objc
    private func updateBatteryLevel() {
        if currentProgress > 1 {
            diffValue = -0.01
        } else if currentProgress <= 0 {
            diffValue = 0.01
        }
        currentProgress += diffValue
        batteryView.updateBatteryLevel(
            color: diffValue > 0 ? .green : .red,
            value: Double(currentProgress)
        )
    }

    private func executeLongTimeJob() async {
        do {
            Logger.logCurrentThread(withPrefix: "🛣 0")
//            try await Task.sleep(nanoseconds: 10_000_000_000)
//            await withCheckedContinuation({ continuation in

                Logger.logCurrentThread(withPrefix: "🛣 1")
                for i in 0 ..< 10 {
                    print(i)
//                    usleep(10_000_000)
                    try await Task.sleep(nanoseconds: 10_000_000_000)
                }
//                continuation.resume()
//            })
            Logger.logCurrentThread(withPrefix: "🛣 2")
            print("👏👏👏👏👏👏👏")
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

struct DemoRepresentView: UIViewRepresentable {

    func makeUIView(context: Context) -> DemoView {
        let view = DemoView(frame: .zero)
//        view.runLongTimeJob()
        return view
    }

    func updateUIView(_ uiView: DemoView, context: Context) {
    }
}
