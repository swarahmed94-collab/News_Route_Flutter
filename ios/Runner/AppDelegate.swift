import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Flutter initializes the implicit engine after the process starts.
  // Register the existing News article channel against that engine.
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "news_route/article",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "openUrl" || call.method == "shareUrl" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard let args = call.arguments as? [String: Any],
            let value = args["url"] as? String,
            let url = URL(string: value),
            let scheme = url.scheme?.lowercased(),
            (scheme == "https" || scheme == "http"),
            url.host != nil else {
        result(FlutterError(code: "parameterInvalid", message: "parameterInvalid", details: nil))
        return
      }

      if call.method == "shareUrl" {
        DispatchQueue.main.async { [weak self] in
          guard let presenter = self?.topViewController() else {
            result(FlutterError(code: "unexpectedError", message: "unexpectedError", details: nil))
            return
          }

          let share = UIActivityViewController(activityItems: [value], applicationActivities: nil)
          if let popover = share.popoverPresentationController {
            popover.sourceView = presenter.view
            popover.sourceRect = CGRect(
              x: presenter.view.bounds.midX,
              y: presenter.view.bounds.midY,
              width: 0,
              height: 0
            )
          }
          presenter.present(share, animated: true)
          result(nil)
        }
      } else {
        UIApplication.shared.open(url, options: [:]) { success in
          if success {
            result(nil)
          } else {
            result(FlutterError(code: "unexpectedError", message: "unexpectedError", details: nil))
          }
        }
      }
    }
  }

  private func topViewController() -> UIViewController? {
    let activeScenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
    let activeWindows = activeScenes.flatMap { $0.windows }

    guard let root = (activeWindows.first { $0.isKeyWindow } ?? activeWindows.first)?.rootViewController else {
      return nil
    }

    var current = root
    while let presented = current.presentedViewController {
      current = presented
    }
    return current
  }
}
