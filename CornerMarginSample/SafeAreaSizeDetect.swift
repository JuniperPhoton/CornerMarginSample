//
//  SafeAreaSizeDetect.swift
//  CornerMarginSample
//
//  Created by juniperphoton on 9/28/25.
//
import SwiftUI
import OSLog

let logger = Logger(subsystem: "com.juniperphoton.cornermargin", category: "default")

extension View {
    func injectSafeAreaInsetsDetector() -> some View {
        self.modifier(SafeAreaInsetsProviderViewModifier())
    }
}

extension EnvironmentValues {
    @Entry var safeAreaInsets: EdgeInsets = .init()
    @Entry var cornerAdaptationMargin: EdgeInsets = .init()
}

private struct SafeAreaInsetsProviderViewModifier: ViewModifier {
    @State private var detector = SafeAreaSizeDetector()
    
    func body(content: Content) -> some View {
        ZStack {
            SafeAreaSizeDetectView(detector: detector).zIndex(0)
            content.zIndex(1)
        }
        .environment(\.safeAreaInsets, detector.safeAreaInsets)
        .environment(\.cornerAdaptationMargin, detector.cornerAdaptationMargin)
        .onChange(of: detector.safeAreaInsets) {
            detector.printInsets()
        }
    }
}

private struct SafeAreaSizeDetectView: UIViewRepresentable {
    var detector: SafeAreaSizeDetector
    
    func makeUIView(context: Context) -> some UIView {
        return SafeAreaSizeDetectUIView { value in
            detector.onSafeAreaInsetsChanged(value)
        } onCornerAdaptationMarginChanged: { value in
            detector.onCornerAdaptationMarginChanged(value)
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // ignored
    }
}

@Observable
private class SafeAreaSizeDetector {
    private(set) var safeAreaInsets: EdgeInsets = .init()
    private(set) var cornerAdaptationMargin: EdgeInsets = .init()
    
    @MainActor
    func onSafeAreaInsetsChanged(_ newValue: EdgeInsets) {
        self.safeAreaInsets = newValue
    }
    
    @MainActor
    func onCornerAdaptationMarginChanged(_ newValue: EdgeInsets) {
        self.cornerAdaptationMargin = newValue
    }
    
    func printInsets() {
        print("safeAreaInsets: \(safeAreaInsets)")
        print("cornerAdaptationMargin: \(cornerAdaptationMargin)")
    }
}

extension EdgeInsets: @retroactive CustomStringConvertible {
    public var description: String {
        "leading: \(leading), top: \(top), trailing: \(trailing), bottom: \(bottom)"
    }
}

extension UIEdgeInsets: @retroactive CustomStringConvertible {
    public var description: String {
        "left: \(left), top: \(top), right: \(right), bottom: \(bottom)"
    }
}

public class SafeAreaSizeDetectUIView: UIView {
    var onSafeAreaInsetsChanged: (EdgeInsets) -> Void
    var onCornerAdaptationMarginChanged: (EdgeInsets) -> Void
    
    public init(
        onSafeAreaInsetsChanged: @escaping (EdgeInsets) -> Void,
        onCornerAdaptationMarginChanged: @escaping (EdgeInsets) -> Void,
    ) {
        self.onSafeAreaInsetsChanged = onSafeAreaInsetsChanged
        self.onCornerAdaptationMarginChanged = onCornerAdaptationMarginChanged
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        triggerUpdate()
        logger.log("safeAreaInsetsDidChange")
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        logger.log("triggerUpdate")
        triggerUpdate()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        triggerUpdate()
    }
    
    private func triggerUpdate() {
        guard let window = self.window else {
            logger.log("window is nil")
            return
        }
        
        let safeAreaInsets: UIEdgeInsets
        let cornerAdaptationMargin: UIEdgeInsets?
        if #available(iOS 26.0, *) {
            safeAreaInsets = window.edgeInsets(for: .safeArea())
            cornerAdaptationMargin = window.edgeInsets(for: .margins(cornerAdaptation: .horizontal))
        } else {
            safeAreaInsets = window.safeAreaInsets
            cornerAdaptationMargin = nil
        }
        
        //logger.info("safeAreaInsets: \(safeAreaInsets), cornerAdaptationMargin: \(String(describing: cornerAdaptationMargin))")
        
        DispatchQueue.main.async {
            self.onSafeAreaInsetsChanged(
                EdgeInsets(
                    top: safeAreaInsets.top,
                    leading: safeAreaInsets.left,
                    bottom: safeAreaInsets.bottom,
                    trailing: safeAreaInsets.right
                )
            )
            
            if let cornerAdaptationMargin {
                self.onCornerAdaptationMarginChanged(
                    EdgeInsets(
                        top: cornerAdaptationMargin.top,
                        leading: cornerAdaptationMargin.left,
                        bottom: cornerAdaptationMargin.bottom,
                        trailing: cornerAdaptationMargin.right
                    )
                )
            }
        }
    }
}
