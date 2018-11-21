# -*- coding: UTF-8 -*-
from Stack import *
from tkinter import *
from LR_Class import *
from LR_support import *


#按下按钮，进行分析
def LR_analyze():
    #刷新页面
    text1.delete('1.0','end')
    text2.delete('1.0','end')
    text3.delete('1.0','end')
    text4.delete('1.0','end')
    text5.delete('1.0','end')
    Errortext.delete('1.0', 'end')
    itemtext.delete('1.0', 'end')
    tabletext.delete('1.0', 'end')
    gototext.delete('1.0', 'end')
    text1.insert(INSERT, "步骤" + '\n')
    text2.insert(INSERT, "状态栈" + '\n')
    text3.insert(INSERT, "符号栈" + '\n')
    text4.insert(INSERT, " 输入串" + '\n')
    text5.insert(INSERT, "动作说明" + '\n')

    temp = ""
    temp1 = ""
    act = ""
    con = 0 #记录输入串读入数量
    time = 1 #记录步骤说

    #获取输入
    Str=Input.get()
    # Str += "#"
    state = []
    Graph_C = creatC(state)
    Action, Goto = createTable(Graph_C, state, len(Graph_C.graph))
    state_stack = Stack()
    sign_stack = Stack()
    state_stack.push(0)
    sign_stack.push("#")
    flag = 0
   
    if Str[-1] != "#":
        Errortext.insert(INSERT, "  输入不合法，请在结尾处加 #" + '\n')

    #查表，分析
    for item in Str:
        if isVT(item):
            act = Action[state_stack.peek()][getNum(item)]
            #print(state_stack.items + sign_stack.items)
            if act == "Error":
                Errortext.insert(INSERT, "  警告，这是错误的句型" + '\n')
                break
            #移进
            elif act[0] == "S":
                text1.insert(INSERT, str(time) + '\n')
                for i in state_stack.items:
                    temp1 += str(i)
                text2.insert(INSERT, temp1 + '\n')
                temp1 = ""
                for i in sign_stack.items:
                    temp1 += i
                text3.insert(INSERT, temp1 + '\n')
                temp1 = ""
                
                for m in range(0, con):
                    temp1 += " "
                temp1 += Str[con:]
                text4.insert(INSERT, temp1 + '\n')
                text5.insert(INSERT, "ACTION"+"["+str(state_stack.peek())+","+item+"]"+"=S"+
                str(act[1])+","+"状态"+str(act[1])+"入栈"+'\n')
                time += 1 
                con += 1
                temp1 = ""

                #入栈
                state_stack.push(int(act[1:]))
                sign_stack.push(item)
                
                #text2.insert(INSERT, 'I LJ\n')
                #state_stack.items + sign_stack.items
            
            #归约
            elif act[0] == "r":
                while Action[state_stack.peek()][getNum(item)][0] == "r":
                    text1.insert(INSERT, str(time) + '\n')
                    for i in state_stack.items:
                        temp1 += str(i)
                    text2.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for i in sign_stack.items:
                        temp1 += i
                    text3.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for m in range(0, con):
                        temp1 += " "
                    temp1 += Str[con:]
                    text4.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    text5.insert(INSERT,"r"+str(int(Action[state_stack.peek()][getNum(item)][1])+1)+":"+P[int(Action[state_stack.peek()][getNum(item)][1])]+","+"归约")
                    time += 1

                    #比对可归约串和文法，准备归约
                    p = P[int(Action[state_stack.peek()][getNum(item)][1])]
                    flag = 0
                    for i in p:
                        if flag == 1:
                            temp += i
                        if i == ">":
                            flag = 1
                    #归约项目出栈
                    for i in temp:
                        a = state_stack.pop()
                        b = sign_stack.pop()
                    #归约结果入栈
                    sign_stack.push(p[0])
                    #求Goto集
                    act = Goto[state_stack.peek()][getNum(p[0])]
                    if act == "Error":
                        Errortext.insert(INSERT, "  警告，这是错误的句型" + '\n')
                        break
                    #Goto结果入状态栈
                    else:
                        text5.insert(INSERT, ","+"GOTO"+"("+str(state_stack.peek())+","+p[0]+")="+act+"入栈"+'\n')
                        state_stack.push(int(act))
                        temp = ""
                #连续归约后移进
                if Action[state_stack.peek()][getNum(item)][0] == "S":
                    text1.insert(INSERT, str(time) + '\n')
                    for i in state_stack.items:
                        temp1 += str(i)
                    text2.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for i in sign_stack.items:
                        temp1 += i
                    text3.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for m in range(0, con):
                        temp1 += " "
                    temp1 += Str[con:]
                    text4.insert(INSERT, temp1 + '\n')
                    text5.insert(INSERT, "ACTION"+"["+str(state_stack.peek())+","+item+"]"+"=S"+
                    str(Action[state_stack.peek()][getNum(item)][1])+","+"状态"+Action[state_stack.peek()][getNum(item)][1]+"入栈"+'\n')
                    temp1 = ""
                    time += 1

                    #入栈
                    state_stack.push(int(Action[state_stack.peek()][getNum(item)][1:]))
                    sign_stack.push(item)
                    con += 1
                #连续归约后接受
                elif Action[state_stack.peek()][getNum(item)] == "acc":
                    text1.insert(INSERT, str(time) + '\n')
                    for i in state_stack.items:
                        temp1 += str(i)
                    text2.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for i in sign_stack.items:
                        temp1 += i
                    text3.insert(INSERT, temp1 + '\n')
                    temp1 = ""
                    for m in range(0, con):
                        temp1 += " "
                    temp1 += Str[con:]
                    text4.insert(INSERT, temp1 + '\n')
                    text5.insert(INSERT, "Acc:分析成功" + '\n')
                    temp1 = ""
                    time += 1
                    Errortext.insert(INSERT, "      分析成功" + '\n')
                #连续归约后出错
                elif Action[state_stack.peek()][getNum(item)] == "Error":
                    Errortext.insert(INSERT, "  警告，这是错误的句型" + '\n')
                    break
            #接受
            elif act == "acc":
                text1.insert(INSERT, str(time) + '\n')
                for i in state_stack.items:
                    temp1 += str(i)
                text2.insert(INSERT, temp1 + '\n')
                temp1 = ""
                for i in sign_stack.items:
                    temp1 += i
                text3.insert(INSERT, temp1 + '\n')
                temp1 = ""
                for m in range(0, con):
                    temp1 += " "
                temp1 += Str[con:]
                text4.insert(INSERT, temp1 + '\n')
                text5.insert(INSERT, "Acc:分析成功" + '\n')
                temp1 = ""
                time += 1
                Errortext.insert(INSERT, "      分析成功" + '\n')

            act = ""

    #输出项目集族
    itemtext.insert(INSERT, "项目集族" + '\n')
    for i in Graph_C.graph:
        itemtext.insert(INSERT, "I" + str(i.num) + '\n')
        for im in i.text:
            itemtext.insert(INSERT, im.left + "->" + im.right_first + "." + im.right_second + "," + im.forward+'\n')
        
        itemtext.insert(INSERT, "\n")

    #output Action/Goto
    tabletext.insert(INSERT, "ACTION" + '\n')
    tabletext.insert(INSERT, "状态" + '\t')
    flag1 = 0
    for item in VT:
        tabletext.insert(INSERT, item + '\t')
    tabletext.insert(INSERT, "\n")
    for item in Action:
        tabletext.insert(INSERT, str(flag1) + '\t')
        for t in item:
            if t[0] == "r":
                tabletext.insert(INSERT, t[0] + str(int(t[1])+1) + '\t')
            else:
                tabletext.insert(INSERT, t + '\t')
        tabletext.insert(INSERT, "\n")
        flag1 += 1

    gototext.insert(INSERT, "GOTO" + '\n')
    for item in VN:
        gototext.insert(INSERT, item + '\t')
    gototext.insert(INSERT, "\n")
    for item in Goto:
        for t in item:
            gototext.insert(INSERT, t + '\t')
        gototext.insert(INSERT, "\n")
    


#设定图形界面
root = Tk()
root.title("LR(1)语法分析器")
root.geometry('1000x1080')                 
root.resizable(width=False, height=True) #宽不可变, 高可变,默认为True
frm = Frame(root)
frm_T = Frame(frm)
Label(frm_T,text = '',bg = 'white').pack() 
Label(frm_T,text = '',bg = 'white').pack() 
Input = Entry(frm_T)
frm_B = Frame(frm)
Input.pack(side=TOP)
frm.pack(side=TOP)
frm_T.pack(side=TOP)
frm_B.pack(side=BOTTOM)


Label(frm_T,text = '',bg = 'white').pack() 
Button(frm_T, text = "开始分析", width=10, height=2, command=LR_analyze).pack()
Label(frm_T,text = '',bg = 'white').pack() 
Label(frm_T,text = '',bg = 'white').pack() 

#设定分析结果输出  
text1 = Text(frm, width=20, height=20)
text2 = Text(frm, width=20, height=20)
text3 = Text(frm, width=20, height=20)
text4 = Text(frm, width=20, height=20)
text5 = Text(frm, width=30, height=20)

Errortext = Text(frm_T, width = 30, height=3)
Errortext.tag_add('tag1','1.7','1.12','1.14')
Label(frm_B,text = '',bg = 'white').pack() 
itemtext = Text(frm, width=20, height=20)
scroll = Scrollbar(frm)
tabletext = Text(frm_B, width=58, height=10)
gototext = Text(frm_B, width=65, height=10)


#排版
text1.pack(side=LEFT)
text2.pack(side=LEFT, anchor="e")
text3.pack(side=LEFT)
text4.pack(side=LEFT)
text5.pack(side=LEFT)
Errortext.pack(side=LEFT)
scroll.pack(side=RIGHT, fill=Y)
itemtext.pack(side=BOTTOM, fill=Y)
scroll.config(command=itemtext.yview)
itemtext.config(yscrollcommand=scroll.set)
tabletext.pack(side=LEFT)
gototext.pack(side=LEFT)

root.mainloop()


