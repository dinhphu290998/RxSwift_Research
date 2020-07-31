//
//  SchedulerViewController.swift
//  ResearchRxSwift
//
//  Created by NDPhu on 7/31/20.
//  Copyright © 2020 IOS_Team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SchedulerViewController: UIViewController {
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fruit = Observable<String>.create { observer in
            observer.onNext("[apple]")
            sleep(2)
            observer.onNext("[pineapple]")
            sleep(2)
            observer.onNext("[strawberry]")
            return Disposables.create()
        }
        
        let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

    }

    private func getThreadName() -> String {
      if Thread.current.isMainThread {
        return "Main Thread"
      } else if let name = Thread.current.name {
        if name == "" {
          return "Anonymous Thread"
        }
        return name
      } else {
        return "Unknown Thread"
      }
    }

}
