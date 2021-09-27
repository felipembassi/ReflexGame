//
//  ReflexGameTests.swift
//  ReflexGameTests
//
//  Created by Felipe Moreira Tarrio Bassi on 23/09/21.
//

import FBSnapshotTestCase
import XCTest

class ReflexBaseTests: FBSnapshotTestCase {

    public func addControllerToWindow(_ controller: UIViewController) {
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    public func verifySnapshotView(delay: TimeInterval = 0, tolerance: CGFloat = 0.005, identifier: String = "", file: StaticString = #file, line: UInt = #line, framesToRemove: [CGRect] = [], forceHideKeyboard: Bool = true, view: @escaping () -> UIView?) {
        sleepTest(for: delay)
        
        guard let view = view() else {
            XCTFail("could not fetch view", file: file, line: line)
            return
        }
        
        if forceHideKeyboard {
            view.endEditing(true)
        }
        
        var image = view.asImage
        
        if !framesToRemove.isEmpty {
            image = image.addImageWithFrame(frames: framesToRemove) ?? UIImage()
        }
        
        folderName = customFolderName(file: file)
        let customIdentifier = "\(identifier)_\("iPhone8".replacingOccurrences(of: " ", with: ""))"
        FBSnapshotVerifyView(UIImageView(image: image), identifier: customIdentifier, suffixes: NSOrderedSet(array: ["_64"]), perPixelTolerance: 0.005, overallTolerance: tolerance, file: file, line: line)
    }
    
    public func sleepTest(for delay: TimeInterval, file: StaticString = #file, line: UInt = #line) {
        guard delay > 0 else { return }
        let delayExpectation = XCTestExpectation(description: "failed to wait for " + String(delay))
        delayExpectation.assertForOverFulfill = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            delayExpectation.fulfill()
        }
        wait(for: [delayExpectation], timeout: 1 + delay)
    }
    
    private func customFolderName(file: StaticString) -> String {
        let fileName = String(describing: type(of: self))
        let methodName: String = invocation?.selector.description ?? ""
        return "\(fileName)/\(methodName)"
    }
}

extension UIView {
    
    public var asImage: UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(frame.size)
            guard let contextImage = UIGraphicsGetCurrentContext() else { return UIImage() }
            layer.render(in: contextImage)
            guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return UIImage() }
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image)
        }
    }
}
extension UIImage {
    /// addImageWithFrame function
    /// - Parameter frames: Rect frame
    /// - Returns: UIImage with frame
    public func addImageWithFrame(frames: [CGRect]) -> UIImage? {
        let imageSize = size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        draw(at: .zero)
        context.setFillColor(UIColor.black.cgColor)
        context.addRects(frames)
        context.drawPath(using: .fill)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
