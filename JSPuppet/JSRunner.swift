//
//  JSRunner.swift
//  JSPuppet
//
//  Created by Chris on 22/11/2022.
//

import Foundation
import JavaScriptCore

class JSRunner {
    let vm: JSVirtualMachine
    let context: JSContext
    weak var delegate: JSRunnerDelegate?
    init() {
        vm = JSVirtualMachine()
        context = JSContext(virtualMachine: vm)
        context.name = "JSPuppet Runner"
        context.exceptionHandler = { [weak self] context, value in
            guard let self = self else { return }
            self.delegate?.javaScript(runner: self, didEncounterException: value)
        }
    }
}

protocol JSRunnerDelegate: AnyObject {
    func javaScript(runner: JSRunner, didEncounterException exception: JSValue?)
}
