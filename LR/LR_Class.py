#项目类
class proj:
    def __init__(self, left, rt_f, rt_s, forward):
        self.left = left
        self.right_first = rt_f
        self.right_second = rt_s
        self.forward = forward

#状态转换图
class State:
    def __init__(self, start, see, end):
        self.start = start
        self.see = see
        self.end = end

#每一个闭包
class State_Graph_item:
    text = []
    num = 0
    def __init__(self, num, text):
        self.num = num
        self.text = text

#项目集
class State_Graph:
    graph = []
    def __init__(self):
        self.graph = []

    def add_state(self, element):
        self.graph.append(element)

    def get_count(self):
        return len(self.graph)