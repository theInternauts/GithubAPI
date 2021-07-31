//
//  Dispatcher+Ext.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 8/1/21.
//


import Dispatch

fileprivate var throttleWorkItems = [AnyHashable: DispatchWorkItem]()
fileprivate var lastDebounceCallTimes = [AnyHashable: DispatchTime]()
fileprivate let nilContext: AnyHashable = arc4random()


extension DispatchQueue {
    func ext_Throttle(deadline: DispatchTime, context: AnyHashable? = nil, action: @escaping () -> Void) {
        let worker = DispatchWorkItem {
            defer { throttleWorkItems.removeValue(forKey: context ?? nilContext) }
            action()
        }

        asyncAfter(deadline: deadline, execute: worker)

        throttleWorkItems[context ?? nilContext]?.cancel()
        throttleWorkItems[context ?? nilContext] = worker
    }

    func ext_Debounce(interval: Double, context: AnyHashable? = nil, action: @escaping () -> Void) {
        if let last = lastDebounceCallTimes[context ?? nilContext], last + interval > .now() {
            return
        }

        lastDebounceCallTimes[context ?? nilContext] = .now()
        async(execute: action)

        // Cleanup & release context
        ext_Throttle(deadline: .now() + interval) {
            lastDebounceCallTimes.removeValue(forKey: context ?? nilContext)
        }
    }
}
