//
//  ViewController.swift
//  词法分析器
//
//  Created by 孙一鸣 on 2018/10/13.
//  Copyright © 2018 孙一鸣. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var myOutput: UITextView!
    
    @IBOutlet weak var myOutput2: UITextView!
    
    @IBOutlet weak var myOutput3: UITextView!
    @IBOutlet weak var myOutput4: UITextView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var solution: UITableView!
    var word_class:[String] = ["关键字", "分界符", "算数运算符", "关系运算符", "常数", "标识符", "Error"]
    var k:[String] = ["do", "end", "for", "if",
                    "printf", "scanf", "then", "while"]
    var s:[String] = [",", ";", "(", ")", "[", "]",
                      "+", "-", "*", "/",
                      "<", "<=", "=", ">", ">=", "<>"]
    var point = 0
    var row = 1
    var col = 0
    var fenjie = 6
    var suanshu = 4
    var guanxi = 6
    var outtext = ""
    var outtext2 = ""
    var outtext3 = ""
    var outtext4 = ""
    var jj = "("
    var dd = ")"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Ins(a:String) -> Bool {
        for m in (6...9) {
            if s[m] == a {
                return true
            }
        }
        return false
    }
    
    @IBAction func Submmit(_ sender: Any) {
        var id = [Int](repeating: 0, count: 99)
        var ci = [String](repeating: "", count: 99)
        var row_id = [Int](repeating: 0, count: 99)
        var col_id = [Int](repeating: 0, count: 99)
        point = 0
        row = 1
        col = 0
        if let instring = inputText.text {
            var f = 1
            var ex = 1
            var temp = ""
            var flag1 = 0
            var flag = 0
            var i = 0
            var key_count = 8
            var sym_count = 16
            
            
            while i < instring.characters.count {
                var index = instring.index(instring.startIndex, offsetBy: i)
                
                
                    //print(instring[index])
                    if instring[index] == " " {
                        i += 1;
                        index = instring.index(instring.startIndex, offsetBy: i)
                    }
                    else if (instring[index]>="A" && instring[index]<="Z") || (instring[index]>="a" && instring[index]<="z") {
                        temp = temp + String(instring[index])
                        i += 1
                        index = instring.index(instring.startIndex, offsetBy: i)
                        
                        while(i < instring.characters.count && ((instring[index]>="0" && instring[index]<="9")||(instring[index]>="A" && instring[index]<="z"))) {
                            temp = temp + String(instring[index]);
                            i += 1
                            index = instring.index(instring.startIndex, offsetBy: i)
                        }
                        for m in (0...key_count-1) {
                            if temp == k[m] {
                                f = 3
                                row_id[point] = row
                                col += 1
                                col_id[point] = col
                                id[point] = 1;
                                ci[point] = temp
                                point += 1
                            }
                        }
                        if f != 3 {
                            row_id[point] = row
                            col += 1
                            col_id[point] = col
                            id[point] = 6;
                            ci[point] = temp
                            point += 1
                        }
                        f = 1
                        temp = ""
                    }
                        
                    else if (instring[index] >= "0" && instring[index] <= "9") {
                        
                        temp = temp + String(instring[index])
                        i += 1
                        index = instring.index(instring.startIndex, offsetBy: i)
                        while(i < instring.characters.count && instring[index]>="0" && instring[index] <= "9" ) {
                            temp = temp + String(instring[index])
                            i += 1
                            index = instring.index(instring.startIndex, offsetBy: i)
                        }
                        if i < instring.characters.count {
                            flag1 = 1
                        }
                        if i == instring.characters.count {
                            flag = 2
                        }
                        if flag1 == 1 {
                           
                            if i < instring.characters.count && (instring[index]>="A" && instring[index]<="Z") || (instring[index]>="a" && instring[index]<="z") {
                                
                                temp += String(instring[index])
                                row_id[point] = row
                                col += 1
                                col_id[point] = col
                                id[point] = 7
                                ci[point] = temp
                                point += 1
                                f = 1
                               
                                if i < instring.characters.count {
                                    i += 1
                                    index = instring.index(instring.startIndex, offsetBy: i)
                                }
                                
                                temp = ""
                                
                            }
                            else {
                                row_id[point] = row
                                col += 1
                                col_id[point] = col
                                id[point] = 5;
                                ci[point] = temp
                                point += 1
                                temp = ""
                               
                            }
                            
                           
                            flag1 = 0
                        }
                        else if flag == 2 {
                            row_id[point] = row
                            col += 1
                            col_id[point] = col
                            id[point] = 5;
                            ci[point] = temp
                            point += 1
                            temp = ""
                            
                        }
                        
                    }
                    else if instring[index] == "\n" {
                        row += 1
                        col = 0
                        i += 1
                        index = instring.index(instring.startIndex, offsetBy: i)
                    }
                    else {
                        f = 0
                        temp = temp + String(instring[index])
                        i += 1
                        index = instring.index(instring.startIndex, offsetBy: i)
                        
                        for m in (0...sym_count-1) {
                            f = 1
                            ex = 1
                            for n in (9...sym_count-1) {
                                if i < instring.characters.count {
                                    if temp+String(instring[index]) == s[n] {
                                        ex = 0
                                        f = 2
                                        row_id[point] = row
                                        col += 1
                                        col_id[point] = col
                                        if n < fenjie {
                                            id[point] = 2;
                                        }
                                        else if n < fenjie+suanshu {
                                            id[point] = 3;
                                        }
                                        else {
                                            id[point] = 4;
                                        }
                                        
                                        ci[point] = temp + String(instring[index])
                                        point += 1
                                        i += 1
                                        index = instring.index(instring.startIndex, offsetBy: i)
                                        temp = ""
                                    }
                                    else if Ins(a: String(instring[index])) {
                                        row_id[point] = row
                                        col += 1
                                        col_id[point] = col
                                        id[point] = 7
                                        ci[point] = temp + String(instring[index])
                                        point += 1
                                       
                                        i += 1
                                        index = instring.index(instring.startIndex, offsetBy: i)
                                        temp = ""
                                        
                                    }
                                }
                            }
                            if temp == s[m] {
                                if f == 1 {
                                    ex = 0
                                    row_id[point] = row
                                    col += 1
                                    col_id[point] = col
                                    if m < fenjie {
                                        id[point] = 2;
                                    }
                                    else if m < fenjie+suanshu {
                                        id[point] = 3;
                                    }
                                    else {
                                        id[point] = 4;
                                    }
                                        
                                    ci[point] = temp
                                    point += 1
                                    temp = ""
                                }
                            }
                        }
                            
                        if(String(temp) != "" && ex == 1){
                            row_id[point] = row
                            col += 1
                            col_id[point] = col
                            id[point] = 7
                            ci[point] = temp
                            point += 1
                            f = 1
                            temp = ""
                        }
                            
                    }
                
            }
        }
    
        else {
            
        }
        if point >= 1 {
            for i in (0...point-1) {
                if id[i] == 7 {
                    outtext += ci[i] + "\n"
                    outtext2 += "Error" + "\n"
                    outtext3 += word_class[id[i]-1] + "\n"
                    outtext4 += jj + String(row_id[i]) + "," + String(col_id[i]) + dd + "\n"
                    myOutput.text = outtext
                    myOutput2.text = outtext2
                    myOutput3.text = outtext3
                    myOutput4.text = outtext4
                }
                else {
                    outtext += ci[i] + "\n"
                    outtext2 += jj + String(id[i]) + "," + String(ci[i]) + dd + "\n"
                    outtext3 += word_class[id[i]-1] + "\n"
                    outtext4 += jj + String(row_id[i]) + "," + String(col_id[i]) + dd + "\n"
                    myOutput.text = outtext
                    myOutput2.text = outtext2
                    myOutput3.text = outtext3
                    myOutput4.text = outtext4
                    
                }
               
            }
        }
        else {
            myOutput.text = ""
            myOutput2.text = ""
            myOutput3.text = ""
            myOutput4.text = ""
            
        }
        outtext = ""
        outtext2 = ""
        outtext3 = ""
        outtext4 = ""
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.solution.dequeueReusableCell(withIdentifier: "ansCell") as! UITableViewCell
        
        
        
        let title = cell.viewWithTag(100) as! UILabel
        
        
        //image.image = UIImage(named: item.avatar)
        //title.text = String(id[1])
        //message.text = Chats[-1]
        
        return cell
    }
}

