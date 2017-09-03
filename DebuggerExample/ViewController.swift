//
//  ViewController.swift
//  DebuggerExample
//
//  Created by Joe-c on 2017/9/3.
//  Copyright © 2017年 Joe-c. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendRequestAction() {
        let urlStr = "https://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=swift&bk_length=600"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)   //请求
        request.httpMethod = "POST"   //修改http方法
        //request.httpBody = Data(bytes: <#T##Array<UInt8>#>)  //设置POST包体
        let session = URLSession.shared
        let date = Date()
        print("创建任务， 时间：\(date.timeIntervalSince1970)")
        //初始化请求
        let dataTask = session.dataTask(with: request,
                                        completionHandler: { (data, resp, err) in
                                            let comDate = Date()
                                            print("http返回， 时间：\(comDate.timeIntervalSince1970)")
                                            if err != nil {
                                                print(err.debugDescription)
                                            } else {
                                                let responseStr = String(data: data!,
                                                                         encoding: String.Encoding.utf8)
                                                print(responseStr!) //包体数据
                                                //print("mimeType: (resp?.mimeType) ")
                                                //URLResponse类里没有http返回值， 需要先强制转换！
                                                if let response = resp as? HTTPURLResponse {
                                                    print("code\(response.statusCode)")
                                                    for (tab, result) in response.allHeaderFields {
                                                        print("(tab.description) - (result)")
                                                    }
                                                    if response.statusCode == 200 {
                                                        //JSON解析， 做逻辑
                                                    } else {
                                                        //通知UI接口执行失败
                                                    }
                                                }
                                            }
        } ) as URLSessionTask
        let beginDate = Date()
        print("开始任务， 时间：\(beginDate.timeIntervalSince1970)")
        dataTask.resume()   //执行任务
        let endDate = Date()
        print("结束任务， 时间:\(endDate.timeIntervalSince1970)")
    }

}

