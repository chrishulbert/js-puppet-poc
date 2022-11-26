//
//  ViewController.swift
//  JSPuppet
//
//  Created by Chris on 22/11/2022.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {

    let jsRunner = JSRunner()
    var jsVC: JSValue?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsRunner.delegate = self

        // Load Main.
        guard let mainUrl = Bundle.main.url(forResource: "Main", withExtension: "js") else { return }
        let mainO = try? String(contentsOf: mainUrl)
        guard let main = mainO else { return }
        jsRunner.context.evaluateScript(main)
                
        // Run viewDidLoad.
        let bridgeBlock: @convention(block) (JSValue?) -> Void = { [weak self] value in
            guard let self else { return }
            guard let value else { return }
            let message = value.toDictionary() as? [String: Any] ?? [:]
            self.didReceive(messageOverBridge: message, rawMessage: value)
        }
        guard let bridgeValue = JSValue(object: bridgeBlock, in: jsRunner.context) else { return }
//        guard let jsViewDidLoad = jsRunner.context.objectForKeyedSubscript("viewDidLoad") else { return }
//        jsViewDidLoad.call(withArguments: [bridgeValue])
                
        // Make a HomeVC.
        // guard let homeVCClass = jsRunner.context.objectForKeyedSubscript("HomeViewController") else { return }
        // objectForKeyedSubscript returns undefined for classes.
        guard let homeVCClass = jsRunner.context.evaluateScript("HomeViewController") else { return }
        guard let homeVC = homeVCClass.construct(withArguments: [bridgeValue, 1000]) else { return } // Equivalent to 'new HomeVC(...)'
        self.jsVC = homeVC
        homeVC.invokeMethod("viewDidLoad", withArguments: [])
        
        // Memory notes:
        // JSValue strongly references its JSContext.
        // JSMAnagedValue is like an arc weak ref, unless you call addManagedReference
        
        // todo get the button to call onclick or something.
    }
    
    // rawMessage is necessary because toDictionary throws out block properties, eg action handlers.
    private func didReceive(messageOverBridge message: [String: Any], rawMessage: JSValue) {
        guard let action = message["action"] as? String else { return }
        if action == "addSubview" {
            guard let type = message["type"] as? String else { return }
            let newView: UIView?
            
            // Apply the type-specific properties.
            if type == "button" {
                let button = Button(type: .system)
                newView = button
                button.backgroundColor = UIColor.systemPurple // Todo make this to be passed in.
                button.setTitleColor(UIColor.white, for: .normal) // Todo make this to be passed in.
                button.setTitle(message["title"] as? String, for: .normal)
                if let cornerRadius = message["cornerRadius"] as? CGFloat {
                    button.layer.cornerRadius = cornerRadius
                    button.clipsToBounds = true
                }
                if let onTapValue = rawMessage.forProperty("onTap")?.nilIfNillish {
                    button.onTap = {
                        onTapValue.call(withArguments: [])
                    }
                }
            } else { // else if type == view, table, etc.
                newView = nil
            }
            
            // Apply the non-specific properties.
            guard let newView = newView else { return }
            newView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(newView)
            if let anchor = message["leadingAnchor"] as? CGFloat {
                newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: anchor).isActive = true
            }
            if let anchor = message["trailingAnchor"] as? CGFloat {
                newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: anchor).isActive = true
            }
            if let anchor = message["topAnchor"] as? CGFloat {
                newView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: anchor).isActive = true
            }
            if let anchor = message["safeTopAnchor"] as? CGFloat {
                newView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: anchor).isActive = true
            }
        } else if action == "presentAlert" {
            let alert = UIAlertController(
                title: message["title"] as? String,
                message: message["message"] as? String,
                preferredStyle: (message["style"] as? String == "actionSheet") ? .actionSheet : .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default))
            present(alert, animated: true)
        }
    }

}

extension ViewController: JSRunnerDelegate {
    func javaScript(runner: JSRunner, didEncounterException exception: JSValue?) {
        if let exception {
            print("JS Exception: \(exception)")
        } else {
            print("JS exception without a value")
        }
    }
}

extension JSValue {
    var nilIfNillish: JSValue? {
        if self.isNull {
            return nil
        } else if self.isUndefined {
            return nil
        } else {
            return self
        }
    }
}
