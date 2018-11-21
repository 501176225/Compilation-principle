//
//  ViewController.swift
//  LL(1)语法分析器
//
//  Created by 孙一鸣 on 2018/10/14.
//  Copyright © 2018 孙一鸣. All rights reserved.
//

import UIKit

class Stack {
    var stack: [String]
    init() {
        stack = [String]()
    }
    func push(object: String) {
        stack.append(object)
    }
    func pop() -> String? {
        if !isEmpty() {
            return stack.removeLast()
        } else {
            return nil
        }
    }
    func isEmpty() -> Bool {
        return stack.isEmpty
    }
    func peek() -> String? {
        return stack.last
    }
    func size() -> Int {
        return stack.count
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var SubButton: UIButton!
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var Text1: UITextView!
    @IBOutlet weak var Text2: UITextView!
    @IBOutlet weak var Text3: UITextView!
    @IBOutlet weak var Text4: UITextView!
    @IBOutlet weak var Text5: UITextView!
    @IBOutlet weak var Error: UITextView!
    @IBOutlet weak var Yufa: UITextView!
    
    var P = ["E->TG", "G->+TG|-TG", "G->ε", "T->FS",
                "S->*FS|/FS", "S->ε", "F->(E)", "F->i"]
    var VN = ["E", "T", "G", "S", "F"]
    var VT = ["+", "-", "*", "/", "i", "(", ")", "#"]
    var FIRST = [String](repeating: "", count: 10)
    var FOLLOW = [String](repeating: "", count: 10)
    var START = "E"
    
    var outtext = ""
    var outtext2 = ""
    var outtext3 = ""
    var outtext4 = ""
    var outtext5 = ""
    var errortext = ""
   
    //构造二维数组
    public struct Array2D<T> {
        public let columns: Int
        public let rows: Int
        fileprivate var array: [T]
        
        public init(columns: Int, rows: Int, initialValue: T) {
            self.columns = columns
            self.rows = rows
            array = .init(repeating: initialValue, count: rows*columns)
        }
        
        public subscript(column: Int, row: Int) -> T {
            get {
                precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
                precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
                return array[row*columns + column]
            }
            set {
                precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
                precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
                array[row*columns + column] = newValue
            }
        }
    }
    
    //初始化分析表
    var M = Array2D(columns: 5, rows: 8, initialValue: "Error")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //是否是终结符
    func isVT(ch:String) -> Bool {
        for m in (0...VT.endIndex-1) {
            if ch == VT[m] {
                return true
            }
        }
        return false
    }
    //是否是非终结符
    func isVN(ch:String) -> Bool {
        for m in (0...VN.endIndex-1) {
            if ch == VN[m] {
                return true
            }
        }
        return false
    }
    //返回终结符的序号
    func VNnum(ch:String) -> Int {
        for m in (0...VN.endIndex-1) {
            if(ch == VN[m]) {
                return m
            }
        }
        return -1
    }
    //返回非终结符的序号
    func VTnum(ch:String) -> Int {
        for m in (0...VT.endIndex-1) {
            if(ch == VT[m]) {
                return m
            }
        }
        return -1
        
    }
    //判断一个String是否在另一个String里
    func InString(ch:String, a:String) -> Bool {
        for m in ch {
            if String(m) == a {
                return true
            }
        }
        return false
    }
    
    //按钮触发事件
    @IBAction func Submmit(_ sender: Any) {
        
        var point = 0
        let stack = Stack()
        var i = P.endIndex-1
        var j = 0
        var flag = 0
        var sign = 0
        var yufastr = ""
        
        var Stack_i = [String](repeating: "", count: 50)
        var Input_i = [String](repeating: "", count: 50)
        var Text_i = [String](repeating: "", count: 50)
        var Act = [String](repeating: "", count:50)
        
        for a in (0...FIRST.endIndex-1) {
            FIRST[a] = ""
        }
        for a in (0...FOLLOW.endIndex-1) {
            FOLLOW[a] = ""
        }
        
        for f in P {
            yufastr += String(f) + "\n"
        }
        Yufa.text = yufastr
        
        
        //找FIRST集
        while i >= 0 {
            flag = 0
            for ch in P[i] {
                //判断是谁的FIRST集
                if flag==0 {
                    for m in (0...VN.endIndex-1) {
                        if String(ch)  == VN[m] {
                            sign = m
                            break
                        }
                    }
                    flag = 1
                }
                
                if flag == 2 && String(ch) == "ε" {
                    FIRST[sign] += String(ch)
                    flag = 1
                }
                if flag == 2 && isVT(ch: String(ch)) {
                    FIRST[sign] += String(ch)
                    flag = 1
                }
                
                if (flag==2 || flag==3) && isVN(ch: String(ch)) {
                    var tag = 0
                    for m in FIRST[VNnum(ch: String(ch))] {
                        if m != "ε" && !InString(ch: FIRST[sign], a: String(ch)) {
                            FIRST[sign] += String(m)
                        }
                        if m == "ε" {
                            tag = 1
                        }
                        
                    }
                    let index = P[i].index(P[i].endIndex, offsetBy:-1)
                    if tag==1 && String(ch)==P[i].substring(from: index) {
                        FIRST[sign] += "ε"
                    }
                    flag = 1
                    if tag == 1 {
                        flag = 3
                    }
                }
            
                if ch == "|" {
                    flag = 2
                }
                if ch == ">" {
                    flag = 2
                }
            }
            i -= 1
        }
        
        //找FOLLOW集
        FOLLOW[0] += "#"
        while j < VN.endIndex {
            var m = 0
            while m < P.endIndex {
                var f = 0 //标记已看到->
                flag = 0 //标记之前是否已找到此非终结符
                var shu = 0 //找到类似"B|"的结构
                var temp = ""
                for ch in P[m] {
                    //记录A->的A
                    if flag==0 {
                        for m in (0...VN.endIndex-1) {
                            if String(ch)  == VN[m] {
                                sign = m
                                break
                            }
                        }
                        flag = 1
                    }
                
                    if shu == 1 && String(ch) == "|" {
                        for i2 in FOLLOW[sign] {
                            if !InString(ch: FOLLOW[j], a: String(i2)) {
                                FOLLOW[j] += String(i2)
                            }
                            
                        }
                    
                    }
                    shu = 0
                    //判断是终结符还是非终结符
                    if flag == 2 {
                        if isVT(ch: String(ch)) && String(ch) != "ε" {
                            if !InString(ch: FOLLOW[j], a: String(ch)) {
                                FOLLOW[j] += String(ch);
                            }
                        }
                        if isVN(ch: String(ch)) && !InString(ch: FIRST[j], a: "ε") {
                            for i1 in FIRST[VNnum(ch: String(ch))] {
                                if String(i1) != "ε" && !InString(ch: FOLLOW[j], a: String(i1)){
                                    FOLLOW[j] += String(i1)
                                }
                                
                            }

                        }
                        //aBb,FIRST(b)有空
                        if isVN(ch: String(ch)) && InString(ch: FIRST[VNnum(ch: String(ch))], a: "ε") {
                            for i1 in FOLLOW[sign] {
                                if !InString(ch: FOLLOW[j], a: String(i1)){
                                    FOLLOW[j] += String(i1)
                                }
                                
                            }
                            
                        }
                        flag = 1
                    }
                    if String(ch) == ">" || String(ch) == "|" {
                        f = 1
                    }
                    //找到结尾的非终结符
                    if f==1 && String(ch) == VN[j] {
                        flag = 2
                        shu = 1
                        let index = P[m].index(P[m].endIndex, offsetBy:-1)
                        if String(ch)==P[m].substring(from: index) {
                            for i2 in FOLLOW[sign] {
                                if !InString(ch: FOLLOW[j], a: String(i2)) {
                                    FOLLOW[j] += String(i2)
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                m += 1
            }
            j += 1
        }
        
        
        //转换生成式的格式
        flag = 0
        var temp1 = ""
        var temp2 = ""
        var temp3 = ""
        var P_pi = [String](repeating: "", count: 20)
        var ff = 0
        for text in P {
            flag = 0
            i = 0
            while i < text.characters.count {
                var inde = text.index(text.startIndex, offsetBy: i)
                if i < text.characters.count && text[inde] == ">" {
                    flag = 1
                }
                
                if i < text.characters.count && text[inde] != "-" && flag == 0 {
                    temp1 += String(text[inde])
                }
               
                if i < text.characters.count && flag == 1 && text[inde] != "|" {
                    temp2 += String(text[inde])
                }
                if i < text.characters.count && flag == 2 {
                    temp3 += String(text[inde])
                }
                if i < text.characters.count && flag == 1 && text[inde] == "|" {
                    flag = 2
                }
                i += 1
                inde = text.index(text.startIndex, offsetBy: i)
                
            }
            if flag == 2 {
                P_pi[ff] += temp1 + "->" + temp3
                ff += 1
                P_pi[ff] += temp1 + "-" + temp2
                ff += 1
                temp1 = ""
                temp2 = ""
                temp3 = ""
                
            }
            else {
                P_pi[ff] += temp1 + "-" + temp2
                ff += 1
                temp1 = ""
                temp2 = ""
                temp3 = ""
                
            }
        }
        for text in P_pi {
            if(text == ""){
                break
            }
                
            flag = 0
            for ch in text {
                if flag==0 {
                    for m in (0...VN.endIndex-1) {
                        if String(ch)  == VN[m] {
                            sign = m
                            break
                        }
                    }
                    flag = 1
                }
                if flag == 2 {
                    if isVT(ch: String(ch)) {
                        M[sign, VTnum(ch: String(ch))] = text
                    }
                    else if ch == "ε" {
                        for b in FOLLOW[sign] {
                          
                            M[sign, VTnum(ch: String(b))] = text
                        }
                        
                    }
                    else {
                        
                        for a in FIRST[VNnum(ch: String(ch))] {
                            if a == "ε" {
                                continue;
                            }
                            M[sign, VTnum(ch: String(a))] = text
                        }
                        if InString(ch: FIRST[VNnum(ch: String(ch))], a: "ε") {
                            for b in FOLLOW[sign] {
                                M[sign, VTnum(ch: String(b))] = text
                            }
                            
                        }
                        
                    }
                    flag = 3
                }
                if ch == ">" || ch == "|" {
                    flag = 2
                }
            }
        }
        
        
        //构造分析表
        if let instring = input.text {
            Error.text = ""
            i = 0
            var ij = 0
            var tstring = [String](repeating: "", count: 50)
            while i < instring.characters.count {
                var index = instring.index(instring.startIndex, offsetBy: i)
                if instring[index] == " " || instring[index] == "\n" {
                    i += 1
                    index = instring.index(instring.startIndex, offsetBy: i)
                    continue
                }
               
                else {
                    var am = instring[index]
                    tstring[ij] += String(am)
                    ij += 1
                }
                i += 1
                index = instring.index(instring.startIndex, offsetBy: i)
                
            }
            
            //分析语法结构
            tstring[ij] = "#"
            var X = ""
            var tp = ""
            stack.push(object: "#")
            stack.push(object: "E")
            point = 0
            Act[point] = "初始化"
            i = 0
            flag = 1
            while flag==1 && i<=ij{
                for i in (0...stack.size()-1) {
                    Stack_i[point] += String(stack.stack[i])
                    //print(String(stack.stack[i]),terminator: "  ")
                }
                for x in (i...ij) {
                    Input_i[point] += String(tstring[x])
                    //print(tstring[x], terminator:"")
                
                }
                point += 1
                //print(" ", terminator:"")
                X = stack.peek()!
                stack.pop()
               
                if X != "#" && isVT(ch: X){
                    if X == String(tstring[i]) {
                        i += 1
                        Act[point] = "GETNEXT(I)"
                    }
                    else {
                        Error.text = "您的输入不符合语法规范!"
                        //print("error")
                        return
                    }
                }
                else if X == "#" {
                    if X == String(tstring[i]) {
                        flag = 0
                    }
                    else {
                        //print("error")
                        return
                    }
                }
                    
                else if isVT(ch:tstring[i]) && isVN(ch:X) && M[VNnum(ch: X), VTnum(ch: tstring[i])] != "Error" {
                  
                    tp = M[VNnum(ch: X), VTnum(ch: tstring[i])]
                    j = tp.characters.count-1
                    var ind = tp.index(tp.startIndex, offsetBy: j)
                    Text_i[point] += tp
                    
                    //print(tp)
                    var temp_p = ""
                    while(j >= 0) {
                            
                        if String(tp[ind]) == ">" ||  String(tp[ind]) == "|"{
                            break;
                        }
                        else if String(tp[ind]) != "ε" {
                            temp_p += String(tp[ind])
                            stack.push(object: String(tp[ind]))
                        }
                        j -= 1
                        ind = tp.index(tp.startIndex, offsetBy: j)
                    }
                    if temp_p == "" {
                        Act[point] += "POP"
                    }
                    else {
                        
                        Act[point] += "POP,PUSH(" + temp_p + ")"
                    }
                    
                }
                else {
                    if instring != "" {
                        Error.text = "您的输入不符合语法规范!"
                    }
                    
                    Text1.text = ""
                    Text2.text = ""
                    Text3.text = ""
                    Text4.text = ""
                    Text5.text = ""
                    return
                    
                }
            
            }
            
            //输出结果
            if point >= 0 {
                for i in (0...point-1) {
                    outtext += String(i) + "\n"
                    outtext2 += Stack_i[i] + "\n"
                    outtext3 += Input_i[i] + "\n"
                    outtext4 += Text_i[i] + "\n"
                    outtext5 += Act[i] + "\n"
                    Text1.text = outtext
                    Text2.text = outtext2
                    Text3.text = outtext3
                    Text4.text = outtext4
                    Text5.text = outtext5
                    
                    
                }
            }
            else {
                Text1.text = ""
                Text2.text = ""
                Text3.text = ""
                Text4.text = ""
                Text5.text = ""
                
                
            }
            print("success")
        }
        
                
            
            
        else {
            Text1.text = ""
            Text2.text = ""
            Text3.text = ""
            Text4.text = ""
            Text5.text = ""
        }
        
    
        outtext = ""
        outtext2 = ""
        outtext3 = ""
        outtext4 = ""
        outtext5 = ""
        
        print("FIRST")
        var a = 0
        for i in FIRST {
            if a < 5 {
                print(VN[a] + ":" + i)
                a += 1
            }
        }
        print("\n")
        print("FOLLOW")
        var b = 0
        for i in FOLLOW {
            if b < 5 {
                print(VN[b] + ":" + i)
                b += 1
            }
        }
        for i in (0...4) {
            for j in (0...7) {
                print(M[i,j], terminator: "  ")
            }
            print("")
        }
        
    }
}

 
