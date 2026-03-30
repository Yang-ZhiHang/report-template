= 前言

#h(2em)欢迎使用 SimpleReport 模板！这是一个基于 Typst 的简易报告模板，适用于本科实验报告的撰写。通过本模板，您可以轻松创建结构清晰、格式规范的文档。

= 使用示例

== 表格

#figure(
  table(
    columns: (1fr, 1fr, 1.5fr),
    align: left + horizon,
    table.header("OPCODE", "Instruction", "Description"),
    "50 + rd", "PUSH r64", "Push r64.",
    "REX.W + 33 /r", "XOR r64, r/m64", "r64 XOR r/m64.",
    "REX.W + 8B /r", "MOV r64, r/m64", "Move r/m64 to r64.",
    "REX.W + B8+ rd io", "MOV r64, imm64", "Move imm64 to r64.",
    "B0 + rb ib", "MOV r8, imm8", "Move imm8 to r8.",
    "0F 05", "SYSCALL", "Fast call to privilege level 0 system procedures.",
  ),
  caption: strong[
    x86_64 汇编指令操作码表
    #footnote[Table from #link("https://yang-zhihang.github.io/posts/xdu/computer-security/buffer_overflow_attack/#user-content-fnref-x86_reference")[缓冲区溢出攻击 - ZamYang's Blog]]
  ],
) <opcode>

表格引用方式为 `@opcode`：@opcode 或者 表@opcode[]

== 图片

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  box[#figure(
    image("../figures/placeholder.webp"),
    caption: "图片示例",
  ) <placeholder>],
  figure(
    image("../figures/placeholder.webp"),
    caption: "图片示例",
  ),
)

#h(2em)在 Typst 中，当你把 `figure` 放在 `grid` 里时，*必须先用 box 或 [] 把 figure 包起来*，才能给它加 `<label>` 并成功用 $@$ 引用 @placeholder。这是因为：`label` 只能贴在内容 `content` 上，而 `grid` 的单元格默认是 `code mode`，不是 `content mode`
#footnote[
  #link("https://stackoverflow.com/questions/78960640/how-do-i-reference-figures-in-agrid-with-typst")[How do i reference figures in agrid with Typst - Stack Overflow]
]
。

#pagebreak()

== 伪代码/算法展示

#import "@preview/algo:0.3.6": algo, code, comment, d, i

#table(
  columns: 1fr,
  align: left + horizon,
  table.header(strong[Algorithm 3]+" Big number Decimal to Binary Conversion"),
  strong[Required:]+" Big number, Binary array",
  algo(
    strong-keywords: true,
    comment-prefix: [#sym.triangle.stroked.r],
    row-gutter: 5pt,
    stroke: none,
    fill: none,
    inset: 0pt,
    block-align: left,
    breakable: true,
  )[
    #comment(inline: true)[ $N: "Big number string"$]\
    #comment(inline: true)[ $B: "Binary array"$]\
    #comment(inline: true)[ $T: "Temporary string"$]\
    #comment(inline: true)[ $l: "Length of T"$]\
    #comment(inline: true)[ $k: "Length of B"$]\
    #comment(inline: true)[ $r: "Remainder"$]\
    let $T <- N$\
    let $k <- 0$\
    while $l > 0$:#i #comment[ Divide until length of T is 0]\
      $r <- 0$\
      $l_"tmp" <- 0$\
      \
      for $i$ in $0$ to $l-1$:#i #comment[ Simulate big number divide by 2]\
        $"current" <- r dot 10 + T[i]$\
        $r <- "current" | 2$ #comment[ Divide current and take the remainder]\
        $T[l_"tmp"] <- "current" div 2$#d\
      end for\
      \
      while $l_"tmp" > 0$ and $T[l_"tmp"-1] = 0$:#i #comment[ Remove leading zeros]\
        $T <- (T + 1)[0:l_"tmp" - 1]$ #comment[ Move string of length $l_"tmp"$-1 at T+1 to T]\
        $l_"tmp" <- l_"tmp" - 1$#d\
      end while\
      \
      $l <- l_"tmp"$\
      $B[k] <- r + '0'$ #comment[ Store the binary digit]\
      $k <- k + 1$#d\
    end while\
    \
    for $i$ in $0$ to $k div 2 - 1$:#i #comment[ Reverse the binary array]\
      $"swap"(B[i],B[k-i-1])$#d\
    end for\
  ]
)

#pagebreak()

== 数学公式

#h(2em)对于两个不同角度的图像，理想情况下它们之间具有唯一的映射关系，所以有：

$
mat(x_i, y_i, 1)^T = H dot mat(x_j, y_j, 1)^T
$

#h(2em)这里我们使用的坐标是齐次坐标，图像坐标除了 $x, y$ 还有 $1$。而齐次坐标之所以还多一个 1，是因为这样能够在空间中一次性容纳旋转、缩放、平移、透视等所有变换。比如想要实现平移矩阵，那么这个 1 就必须参与进来，否则无法实现平移变换。

#h(2em)这里我们通过 SVD 方法求解单应性矩阵 $H$。展开上式可得方程式：

$
cases(
  h_11 x_j + h_12 y_j + h_13 &= x_i,
  h_21 x_j + h_22 y_j + h_23 &= y_j,
  h_31 x_j + h_32 y_j + h_33 &= 1,
)
$ <H>

#h(2em)@eqt:H 第三行分别乘以 $x_i, y_i$ 与前两行相减，得到方程式：

$
cases(
  x_j h_11 & + y_j h_12 & + h_13 & -x_i x_j h_31 & -x_i y_j h_32 & -x_i h_33 &= 0,
  x_j h_21 & + y_j h_22 & + h_23 & -y_i x_j h_31 & -y_i y_j h_32 & -y_i h_33 &= 0
)
$

$
A h = 0
$ <Ah>

#h(2em)将该方程组写为行列式 @eqt:Ah[]，我们就能够得到该方程的系数 $A$ 和未知数 $h$：

$
A &= mat(
  x_j, y_j, 1, 0, 0, 0, -x_i x_j, -x_i y_j, -x_i; 
  0, 0, 0, x_j, y_j, 1, -y_i x_j, -y_i y_j, -y_i
)\
h &= mat(h_11, h_12, h_13, h_21, h_22, h_23, h_31, h_32, h_33)^T
$

#h(2em)最后通过 SVD 方法分解 $A$ 矩阵，得到 $A = U S V^T$。$V$ 的最后一列即为未知数 $h$ 的解，将其转为 $3 times 3$ 矩阵即可作为我们的 $H$ 变换矩阵。

== 列表样式

=== 无序列表

- 第一项
- 第二项

#h(2em)👈列表缩进与正文相同。

=== 有序列表

1. 第一项
2. 第二项

#h(2em)👈列表缩进与正文相同。

#pagebreak()

== 引用

#quote(h(2em) + lorem(40), attribution: lorem(2))

== 代码块

#import "../../modules/term.typ": term

#term[
```
(client) PS D:\c\c\d\a\client> just run 
uv run ./src/main.py
Connected to gRPC server at: 127.0.0.1:8080

--- Meeting Management System ---
1. Book a meeting
2. Query by ID
3. Query by Organizer
4. Cancel a meeting
q. Quit

Select an option: 1
Title: Test-one
...
Success: Meeting booked. ID: c9828f68-0098-4b12-9ec6-994e2b23d892
```
]

#h(2em)自定义模块 `term`
#footnote[改自 https://github.com/qo/term/blob/main/term.typ]
提供了一个专门用于展示多行代码在终端的样式，不影响后续 `codly` 多行代码的默认样式：

```rust
pub mod meeting {
    tonic::include_proto!("meeting");
}
use meeting::meeting_server::{Meeting, MeetingServer};
use meeting::*;
```