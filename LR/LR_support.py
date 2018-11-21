from LR_Class import *

'''
P = ['S->BB', 'B->aB', 'B->b']
START = 'S'
P_pi = {'E': ['S'], 'S': ['BB'], 'B': ['aB', 'b']}
FIRST = {'S': ['a', 'b'], 'F': ['a', 'b'], 'B': ['a', 'b'],  'a': ['a'], 'b': ['b'], '#': ['#']}
VN = ['S', 'B']
VT = ['a', 'b', '#']

'''


P = ['E->E+T', 'E->T', 'T->T*F', 'T->F', 'F->(E)', 'F->i']
START = 'E'
P_pi = {'S': ['E'], 'F': ['(E)', 'i'], 'T': ['T*F', 'F'], 'E': ['E+T', 'T']}
FIRST = {'S': ['(', 'i'], 'F': ['(', 'i'], 'T': ['(', 'i'], 'E': ['(', 'i'],
        '+': ['+'], '*': ['*'], '(': ['('], ')': [')'], 'i': ['i'], '#': {'#'}}
VN = ['E', 'T', 'F']
VT = ['i', '+', '*', '(', ')', '#']

#获得终结符的序号
def getNum(str):
    if isVT(str):
        for i in range(len(VT)):
            if str == VT[i]:
                return i
    else:
        for i in range(len(VN)):
            if str == VN[i]:
                return i
    return -1

#获得语法规则的序号
def getReducenum(text):
    for i in range(len(P)):
        if text.left + "->" + text.right_first == P[i]:
            return i
    return -1
        
#判断终结符
def isVT(str):
    for i in VT:
        if str == i: 
            return True
    return False

#判断非终结符
def isVN(str):
    for i in VN:
        if str == i:
            return True
    return False

#判断是否为空
def inNull(str):
    for i in str:
        if i == 'ε':
            return True
    return False

#判断是否已经存在在闭包里
def inClosure(closure, i):
    for c in closure:
        if c.left == i.left and c.right_first == i.right_first and c.right_second == i.right_second and c.forward == i.forward:
            return True
    return False

#判断是否为已有的状态
def inState(state, i):
    for c in state:
        if c.start == i.start and c.see == i.see and c.end == i.end:
            return True
    return False

#判断是否为重复的项目C
def inItem(item, i):
    f = -1
    for c in item.graph:
        if len(c.text) == len(i):
            f = 1
            for m in i:
                if inClosure(c.text, m) == False:
                    f = -1
        if f == 1:
            f = c.num
            break;
    return f



def instr(str, i):
    if str == []:
        return False
    for m in str:
        if i == m:
            return True
    return False



#获得FIRST集
def getFIRST(str):
    i = 0
    thisFIRST = ""
    if str != "":
        for c in FIRST[str[i]]:
            if c != 'ε':
                thisFIRST += c
        while inNull(FIRST[str[i]]):
            i += 1
            for c in FIRST[str[i]]:
                if c != 'ε':
                    thisFIRST += c
            if i == str.length():
                thisFIRST += 'ε'
    return thisFIRST

def firstForward(str):
    return str

#判断两个状态是否为同心项目集
def itemcenter_equal(a, b):
    temp_a = []
    temp_b = []
    for i in a:
        temp = i.left + i.right_first
        if instr(temp_a, temp) == False:
            temp_a.append(temp)
    for i in b:
        temp = i.left + i.right_first
        if instr(temp_b, temp) == False:
            temp_b.append(temp)

    if temp_a == temp_b:
        return True
    else:
        return False

#判断是否可以进行合并操作
def canCombine(graph, item):
    for i in graph.graph:
        if itemcenter_equal(i.text, item):
            return i.num
    return -1

#合并同心项目集
def itemCombine(num, Gra, item):
    for i in range(len(Gra.graph)):
        if Gra.graph[i].num == num:
            temp = i
            break
    for im in item:
        #不在闭包里，合并
        if inClosure(Gra.graph[temp].text, im) == False:
            Gra.graph[i].text.append(im)
    
    
#生成闭包
def closure(init_J):
    #print("1")
    closure = []
    length = -1
    for item in init_J:
        closure.append(item)
    #长度不再改变，退出循环
    while True:
        for item in closure:
            if item.right_second != "":
                if isVN(item.right_second[0]):
                    #找到可以展开的项目
                    for c in P_pi[item.right_second[0]]:
                        #加入新的项目
                        if getFIRST(item.right_second[1:]) != "":
                            temp = proj(item.right_second[0], "", c, getFIRST(item.right_second[1:]))
                        else:
                            temp = proj(item.right_second[0], "", c, firstForward(item.forward))
                        if inClosure(closure, temp) != True:
                            closure.append(temp)
        if len(closure) == length:
            break;
        length = len(closure)


    return closure

#构造GO(I, X)
def GO(I, X):
    GO = []
    J = []
    #找到J
    for item in I:
        if item.right_second != "" and item.right_second[0] == X:
            temp = proj(item.left, item.right_first + item.right_second[0], item.right_second[1:], item.forward)
            J.append(temp)
   
    GO = closure(J)
    
    return GO


#构造项目集族C
def creatC(state):
    count = 0
    flag = 0
    start = closure([proj("S", "", "E", "#")])
    Gra = State_Graph()
    state1 = State_Graph_item(count, start)
    state_num = 0
    
    Gra.add_state(state1)
    count += 1
    length = -1

    #不在增大，停止循环
    while True:
        for item in Gra.graph:
            for X in VN+VT:
                if GO(item.text, X) != []:
                    #非空
                    if inItem(Gra, GO(item.text, X)) == -1:
                        #不属于C
                        if canCombine(Gra, GO(item.text, X)) == -1:
                            #不可以合并
                            newstate = State_Graph_item(count, GO(item.text, X))
                            temp = State(str(item.num), X, str(newstate.num))
                            Gra.add_state(newstate)
                            count += 1
                        else:
                            #可以合并，进行合并
                            temp = State(str(item.num), X, str(canCombine(Gra, GO(item.text, X))))
                            itemCombine(canCombine(Gra, GO(item.text, X)), Gra, GO(item.text, X))

                        #保存状态转换
                        if inState(state, temp) == False:
                            state.append(temp)
                            state_num += 1   
                        #item.add_next_state(X, count)
                    else:
                        #不更改项目集族，保存状态转换
                        temp = State(str(item.num), X, str(inItem(Gra, GO(item.text, X))))
                        if inState(state, temp) == False:
                            state.append(temp)
                            state_num += 1

        if Gra.get_count() == length:
            break;
        length = Gra.get_count()
    
    
    #print(count)
    return Gra
    

#创建Action和Goto
def createTable(Gra, state, count):
    Action = [['Error' for i in range(len(VT))] for i in range(count)]
    #前进项目
    for item in state:
        if isVT(item.see):
            Action[int(item.start)][getNum(item.see)] = "S" + item.end
    #规约项目
    for item in Gra.graph:
        for text in item.text:
            #找到可归态
            if text.right_second == "":
                #遍历展望符
                for i in text.forward:
                    if text.right_first != START:
                        Action[item.num][getNum(i)] = "r" + str(getReducenum(text))
                    else:
                        Action[item.num][getNum(i)] = "acc"


    Goto = [['Error' for i in range(len(VN))] for i in range(count)]
    for item in state:
        if isVN(item.see):
            Goto[int(item.start)][getNum(item.see)] = item.end

    return Action, Goto