#import "../template.typ": *

#show: cover.with(
  title: "SimpleReport 模板",
  subtitle: "使用说明",
  student_no: "2023114514",
  author: "张三",
  class: "计算机科学与技术",
  teacher: "李四",
  logo: image("figures/xdu_lab.webp"),
  only-logo: true,
)

#include "chapter/main.typ"
