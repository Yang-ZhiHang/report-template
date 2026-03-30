
#let cover(
  title: "",
  subtitle: none,
  student_no: none,
  author: "",
  class: "",
  teacher: "",
  date: datetime.today().display(),
  affiliation: none,
  year: none,
  logo: none,
  only-logo: false,
  catalogue: true,
  body,
) = {
  // 设置需要嵌入到文档的元数据
  set document(author: author, title: title)

  // 字体：确保系统已安装这些字体
  let zh-font = "Noto Serif CJK SC"
  let en-font = "Times New Roman"
  let global-font = (en-font, zh-font)

  // 颜色
  let black = rgb("000000")
  let blue = rgb("#5179f3")

  // ===================================================
  // 标题设置
  // ===================================================
  // 标题编号设置
  set heading(numbering: (..n) => {
    let num_str = numbering("1.1", ..n)
    if num_str.len() > 2 {
      num_str.slice(2, none)
    }
  })

  // 一级标题
  show heading.where(level: 1): set text(size: 24pt)
  show heading.where(level: 1): it => it + v(0.5em)

  // 二级标题
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 2): it => it + v(0.4em)

  // 三级标题
  show heading.where(level: 3): set text(size: 16pt)
  show heading.where(level: 3): it => it + v(0.4em)

  // 四级标题
  show heading.where(level: 4): set text(size: 14pt)
  show heading.where(level: 4): it => it + v(0.4em)

  // 设置链接样式
  // show link: it => underline(text(fill: blue, it))
  show link: it => text(fill: blue, it)

  // ===================================================
  // 列表样式
  // ===================================================
  // 有序列表
  set enum(indent: 2em)

  // 无序列表
  set list(indent: 2em)

  // ===================================================
  // 数学公式
  // ===================================================
  import "@preview/i-figured:0.2.4"
  show math.equation: i-figured.show-equation.with(
    level: 1,
    numbering: "(1-1)",
  )
  set math.equation(
    supplement: "公式",
  )

  // ==================================================
  // 代码块
  // ==================================================
  import "@preview/codly:1.3.0": *
  show: codly-init.with()

  // ==================================================
  // 内联代码
  // ==================================================
  show raw.where(block: false): it => {
    (
      h(0.5em)
        + box(
          fill: black.lighten(95%),
          outset: 0.2em,
          radius: 0.3em,
          height: 1em,
          baseline: 10%,
          it,
        )
        + h(0.5em)
    )
  }

  // ===================================================
  // 图表
  // ===================================================
  // show figure: i-figured.show-figure.with(
  //   level: 0,
  //   numbering: "1",
  // )
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(
    supplement: strong[表],
  )
  show figure.where(kind: image): set figure(
    supplement: strong[图],
  )
  show figure.caption: strong
  
  // 三线表
  set table(
    stroke: (_, y) => (
      top: {
        if y <= 1 { 1pt } else { 0pt }
      },
      bottom: 1pt,
    ),
    align: (x, y) => (
      if x > 0 { center } else { left }
    ),
  )

  // ===================================================
  // 引用
  // ===================================================
  set quote(block: true)
  show quote: it => block(
    fill: rgb("#f5f5f5"),
    inset: (top: 0em, bottom: 1em),
    outset: (top: 1em),
    radius: 3pt,
    width: 100%,
    it,
  )

  // ===================================================
  // 封面页
  // ===================================================
  if only-logo {
    set page(
      margin: 0pt,
    )
    // 大图标
    if logo != none {
      set image(width: 100%)
      set align(center + top)
      block(logo)
    }
  } else {
    if logo != none {
      // 报告封面
      set image(width: 90%)
      set align(center + top)
      block(logo)
    }
    v(4em)
  }

  if not only-logo {
    // 标题
    align(center, text(3em, font: zh-font, weight: 700, title))

    // 副标题
    if subtitle != none {
      align(center, text(2.0em, font: zh-font, weight: 700, subtitle))
    }
    v(24em)

    // 添加作者和其它信息
    set text(size: 1.5em, font: zh-font)
    align(left, grid(
      columns: (200pt, 180pt),
      align: (right + horizon, left),
      gutter: 9pt,
      if student_no != none { [学号：] }, if student_no != none { [#box(student_no)\ ] },
      if author != "" { [姓名：] }, if author != "" { [#box(author)\ ] },
      if class != "" { [班级：] }, if class != "" { [#box(class)\ ] },
      if teacher != "" { [教师：] }, if teacher != "" { [#box(teacher)\ ] },
      if date != none { [日期：] }, if date != none { [#box(date)\ ] },
    ))
  }

  // 正文字体
  set text(font: global-font, 12pt)

  // 底部空白
  v(2em)

  // 分页
  if not only-logo {
    pagebreak()
  }

  // 目录
  if catalogue {
    align(center, outline(title: "目录", depth: 4))
    pagebreak()
  }

  // ===================================================
  // 页眉页脚
  // ==================================================
  set page(
    header: context [
      #box(title) - #box(if subtitle != none { subtitle } else { "" })
      #h(1fr)
      #counter(page).display(
        "1 / 1",
        both: true,
      )
      // 添加贯穿页眉的下划线（在内容下方）
      #line(length: 100%, stroke: 0.8pt)
    ],
    footer: none,
    numbering: "1 of 1",
    number-align: right,
    margin: (top: 5.5em, bottom: 5.5em, left: 5.5em, right: 5.5em),
  )

  // ===================================================
  // 脚注设置
  // ===================================================
  set footnote(
    numbering: "[1]",
  )

  // ===================================================
  // 正文内容
  // ===================================================
  body
}
