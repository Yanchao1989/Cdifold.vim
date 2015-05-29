if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif
if exists("b:did_cdiff_fold")
    finish
endif
let b:did_cdiff_fold = 1 

function! Cdifold()
python << EOF
import vim
cur_buf = vim.current.buffer

class diff_helper:

    def reset(self):
        self.data=""
        self.start_line=0
        self.next_line=0

    def __init__(self):
        self.reset()

    def __iadd__(self, data_tuple):
        line, line_num = data_tuple
        if line_num != self.next_line:
            self.data = ""
            self.start_line = line_num
        self.data += filter(lambda x:x!=" "and x!= "\t", line[1:])
        self.next_line = line_num + 1
        return self

    def __eq__(self, other):
        return len(self.data)!=0 and self.data == other.data \
                 and self.next_line == other.start_line

    def fold_with(self, end):
        vim.command("%d,%dfold"%(self.start_line, end.next_line-1))
        self.reset()
        end.reset()

plus = diff_helper()
minus = diff_helper()
line_index = 1;
last_start=""
vim.command("normal zE") #clear all folds
for line in cur_buf:
    if line.startswith("+"):
        if last_start == "-":
            if plus == minus:
                plus.fold_with(minus)
        plus += (line, line_index)
        last_start="+"
    elif line.startswith("-"):
        if last_start == "+":
            if minus == plus:
                minus.fold_with(plus)
        minus += (line, line_index)
        last_start="-"
    else:
        if last_start == "-":
            if plus == minus:
                plus.fold_with(minus)
        if last_start == "+":
            if minus == plus:
                minus.fold_with(plus)
        last_start=""
    line_index = line_index + 1
if minus == plus:
    minus.fold_with(plus)
if plus == minus:
    plus.fold_with(minus)
EOF
endfunction

command! -nargs=0 Cdifold call Cdifold()
"nmap    <SPACE> za
