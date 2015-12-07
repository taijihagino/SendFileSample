//
//  ViewController.swift
//  saveCSVsample
//
//  Created by Taiji HAGINO on 10/28/15.
//  Copyright (c) 2015 Taiji HAGINO. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // 画面にメール送信ボタンを配置
    let startMailerBtn = UIButton(frame: CGRectMake(0,0,200,30))
    // CSVデータ用変数
    var csvData=[[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 日付フォーマットの指定
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        // CSVデータ作成
        self.csvData.append(
            [dateFormatter.stringFromDate(NSDate()),
            "aaaaa",
            "bbbbb",
            "ccccc"
            ])

        // ボタン生成
        startMailerBtn.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/2);
        startMailerBtn.setTitle("Send Data", forState: .Normal)
        startMailerBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        startMailerBtn.addTarget(self, action: "onClickStartMailerBtn:", forControlEvents: .TouchUpInside)
        self.view.addSubview(startMailerBtn)
        
    }
    
    /***********************************************
    * メール送信ボタン押下時のハンドラ
    ***********************************************/
    func onClickStartMailerBtn(sender: UIButton) {
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
            println("Email Send Failed")
            return
        }
        
        sendMailWithCSV("データの送付", message: "データメール送信アプリより自動送信されています。", csv: csvData)
        
    }
    
    /***********************************************
    * メール送信（CSVファイルを添付）
    ***********************************************/
    func sendMailWithCSV(subject: String, message: String, csv: [[String]]) {
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        var toRecipients = ["foo@bar.com"]  //送信したいメールアドレスを設定
        var CcRecipients = [""]  //CCしたいメールアドレスを設定
        var BccRecipients = ["",""]  //BCCしたいメールアドレスを設定
        
        mailViewController.setSubject(subject)
        mailViewController.setToRecipients(toRecipients)
        mailViewController.setCcRecipients(CcRecipients)
        mailViewController.setBccRecipients(BccRecipients)
        mailViewController.setMessageBody(message, isHTML: false)
        mailViewController.addAttachmentData(toCSV(csv).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), mimeType: "text/csv", fileName: "sample.csv")
        self.presentViewController(mailViewController, animated: true) {}

    }
    
    /***********************************************
    * CSVファイルへ変換
    ***********************************************/
    func toCSV(a: [[String]]) -> String {
        return join("\n", a.map { join(",", $0.map { e in
            contains(e) { contains("\n\",", $0) } ?
                "\"" + e.stringByReplacingOccurrencesOfString("\"", withString: "\"\"", options: nil, range: nil) + "\"" : e
            })}) + "\n"
    }
    
    /***********************************************
    * メール終了処理
    ***********************************************/
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Email Send Cancelled")
            break
        case MFMailComposeResultSaved.value:
            println("Email Saved as a Draft")
            break
        case MFMailComposeResultSent.value:
            println("Email Sent Successfully")
            break
        case MFMailComposeResultFailed.value:
            println("Email Send Failed")
            break
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
