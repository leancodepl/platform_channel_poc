import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let json = """
              {
                "glossary": {
                    "title": "example glossary",
                "GlossDiv": {
                        "title": "S",
                  "GlossList": {
                            "GlossEntry": {
                                "ID": "SGML",
                      "SortAs": "SGML",
                      "GlossTerm": "Standard Generalized Markup Language",
                      "Acronym": "SGML",
                      "Abbrev": "ISO 8879:1986",
                      "GlossDef": {
                                    "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                                },
                      "GlossSee": "markup"
                            }
                        }
                    }
                }
            }
            """;
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "DataChannel", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if (call.method == "getData") {
            let data = stride(from: 0, to: 1000, by: 1).map { ("key\($0)", self.json) }
            
            result(data.reduce(into: [:]) { $0[$1.0] = $1.1 })
          } else if (call.method == "getImage") {
            guard let image = UIImage(named: "image"),
                  let data = image.jpegData(compressionQuality: 1.0) else { return }
            result(FlutterStandardTypedData(bytes: data))
          }
        })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
