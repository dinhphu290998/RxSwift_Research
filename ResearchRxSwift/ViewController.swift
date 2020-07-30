//
//  ViewController.swift
//  ResearchRxSwift
//
//  Created by NDPhu on 7/30/20.
//  Copyright © 2020 IOS_Team. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// TÌM HIỂU VỀ SUBJECT TRONG RXSWIFT

class ViewController: UIViewController {

    //Quản lí bộ nhớ trong RxSwift
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.demoVariable()
    }
    
    //Được sử dụng khi chỉ muốn thông báo những sự kiện mới từ khi subcribe cho đến complete hoặc error
    func demoPublishSubject() {
        //khởi tạo một PublishSubject kiểu String
        //Khởi đầu với empty
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("PublishSubject 1") //Phát ra một sự kiện với chuỗi String "PublishSubject 1"
        
        // TH1 tạo ra một Subscriber để lắng nghe sự kiện từ subject
        let subscriberOne = publishSubject.subscribe { element in
            print("subscriber1: \(element.element ?? "")")
            //TH1 PublishSubject chỉ trả về sự kiện sau khi PublishSubject subscribe
            //TH3 do publishSubject đã kết thúc mà vẫn có sự kiện lắng nghe nên là nhận được thông báo completed
        }
        subscriberOne.disposed(by: bag)
                
        publishSubject.onNext("PublishSubject 2") //Phát ra một sự kiện với chuỗi String "PublishSubject 2"
        publishSubject.onNext("PublishSubject 3") //Phát ra một sự kiện với chuỗi String "PublishSubject 3"
        //TH3 kết thúc lắng nghe sự kiện
        publishSubject.onCompleted() // kết thúc lắng nghe
        
        //TH2 tạo thêm 1 Subscriber
        let subscriberTwo = publishSubject.subscribe { element in
            print("subscriber2: \(element.element ?? "")")
            //TH2 Không có sự kiện mới sau khi subscriberTwo subscribe thì sẽ không nhận được thông báo mới
            //TH3 do publishSubject đã kết thúc lắng nghe nên là nhận được thông báo completed
        }
        subscriberTwo.disposed(by: bag)
    }
    
    //Hoạt động tương tư PublishSubject nhưng khác là lấy được 1 sự kiện trước gần nhất khi subscribe
    func demoBehaviorSubject() {
        //Khởi tạo một BehaviorSubject kiểu String
        //Khởi tạo với giá trị ban đầu là "Initial Value"
        let behaviorSubject = BehaviorSubject<String>(value: "Initial Value")
                
        behaviorSubject.onNext("BehaviorSubject 1") //Phát ra một sự kiện với giá trị "BehaviorSubject 1"
        // TH1 tạo ra một Subscriber để lắng nghe sự kiện từ subject
        let subscriber = behaviorSubject.subscribe { element in
            print("Subscriber1: \(element)")
            //TH1 Nhận được sự kiện BehaviorSubject 1 là sự kiện trước đó gần nhất và các sự kiện phía sau
            //TH3 Nhận được complete
        }
        subscriber.disposed(by: bag)
                
        behaviorSubject.onNext("BehaviorSubject 2") //Phát ra một sự kiện với giá trị "BehaviorSubject 2"
        behaviorSubject.onNext("BehaviorSubject 3") //Phát ra một sự kiện với giá trị "BehaviorSubject 3"
        
        //TH3 kết thúc lắng nghe sự kiện
        behaviorSubject.onCompleted() // kết thúc lắng nghe
        
        //TH2 tạo thêm 1 Subscriber
        let subscriberTwo = behaviorSubject.subscribe { element in
            print("subscriber2: \(element)")
            //TH2 Nhận được sự kiện BehaviorSubject 3 là sự kiện gần nhất và các sự kiện phía sau
            //TH3 Nhận được complete
        }
        subscriberTwo.disposed(by: bag)
        behaviorSubject.onNext("BehaviorSubject 4")
    }
    
    //Hoạt động tương tư BehaviorSubject nhưng khác là lấy được số sự kiện bằng với bufferSize khai báo gần nhất trước khi subscribe
    func demoReplaySubject() {
        //khởi tạo một ReplaySubject kiểu String
        //khởi tạo với size của buffer là bufferSize
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

        replaySubject.onNext("ReplaySubject 1") //Phát ra một sự kiện với String "ReplaySubject 1"
        replaySubject.onNext("ReplaySubject 2") //Phát ra một sự kiện với String "ReplaySubject 2"
        replaySubject.onNext("ReplaySubject 3") //Phát ra một sự kiện với String "ReplaySubject 3"
                
        print("- Before subscribe -")
        let subscriber = replaySubject.subscribe { element in //tạo ra một Subscriber để lắng nghe sự kiện từ replaySubject
            print("Subscriber: \(element)")
            // có 3 sự kiện trước khi subcriber nhưng chỉ lấy được số sự kiện bằng bufferSize , vẫn lấy được tất cả sự kiện sau khi subcriber
        }
        subscriber.disposed(by: bag)
        print("- After subscribe -")
                
        replaySubject.onNext("ReplaySubject 4")
        replaySubject.onNext("ReplaySubject 5")
        replaySubject.onNext("ReplaySubject 6")
        replaySubject.onNext("ReplaySubject 7")
    }
    
    //Tương tự BehaviorSubject
    func demoVariable() {
        let bag = DisposeBag()
        let behaviorRelay = BehaviorRelay<Bool>(value: false)
        behaviorRelay.accept(false)
        behaviorRelay.accept(true)
        let subscriber = behaviorRelay.asObservable()
            .subscribe { element in
                print("Subscriber: \(element)")
            }
        subscriber.disposed(by: bag)
        
        behaviorRelay.accept(false)
        behaviorRelay.accept(true)
    }
    
    
    // Khác nhau giữa BehaviorRelay và BehaviorSubject đó là BehaviorRelay thì replay giá trị khởi tạo hoặc là giá trị cuối cùng chuỗi trước khi subscribe còn BehaviorSubject thì chỉ relay giá trị khởi tạo còn những giá trị sau thì .next chứ không phải là replay
}

