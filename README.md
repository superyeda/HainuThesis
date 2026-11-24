# HainuThesis（`hainanuthesis`）

> 海南大学研究生（硕士 / 博士）学位论文 LaTeX 模板（非官方开源项目）

本项目严格依据《**海南大学研究生学位论文撰写规范（修订）**》（海大党政办〔2023〕47 号，2023 年 9 月 1 日起施行）编写，面向 **XeLaTeX + BibTeX (`gbt7714`)** 工作流，支持 Windows、macOS、Linux 本地编译与 **Overleaf** 在线开箱即用。

---

## 核心特性

- **严格对齐 2023 修订版规范**：涵盖 A4 版心与页边距（上 2.5 / 下 2.5 / 左 3.0 / 右 2.5 cm）、中文封面、英文封面、原创性声明与授权页（含 CALIS 声明）、中英文摘要、目录、插图/附表清单、符号表、四级标题体系、三线表与跨页续表、参考文献、附录、成果页、致谢及书脊生成。
- **硕 / 博与盲审一键切换**：通过文档类选项 `degree=master|doctor`、`anonymous=true` 一键切换硕士/博士版式与双盲评审版本（自动隐去作者、导师、学号、声明页与致谢，且清除 PDF 作者元数据）。
- **内置附录 B 学院中英文自动映射**：完整收录规范附录 B 中全校 35 个学院的官方英文译名；在 `\hainanusetup` 中填写中文院系全称即可自动生成规范英文封面院系名（也支持手动填 `school*` 覆盖）。
- **跨平台字体零报错**：自动检测 `fonts/` 目录及系统字体；缺失商业字体（方正小标宋简体、楷体\_GB2312）时自动优雅回退，确保 Overleaf / Linux / macOS / Windows 均能零配置编译成功。
- **标准国标参考文献**：基于 `gbt7714`（`GB/T 7714-2015` 顺序编码制），同时提供上标引用 `\cite{...}` 与正文平齐引用 `\citeinline{...}`。
- **附录编号自动切换**：调用 `\appendix` 后，自动将附录编号与标题设为分行居中，并将图、表、公式切换为 `图 A1`、`表 A1`、`(A1)`。

---

## 快速开始

### 方式一：Overleaf 在线使用（最简单）

1. 将本仓库打包下载为 `.zip` 并上传至 [Overleaf](https://www.overleaf.com/) 新建项目。
2. 点击左上角 **Menu** → **Compiler**，将编译器切换为 **`XeLaTeX`**。
3. （可选）如需在封面严格使用「方正小标宋简体」与「楷体\_GB2312」，可将字体文件上传至项目的 `fonts/` 目录（详见 [`fonts/README.md`](fonts/README.md)）。
4. 修改 [`main.tex`](main.tex) 中的论文元信息，并在 `chapters/` 目录下撰写各章节内容，点击 **Recompile** 即可。

### 方式二：本地编译（TeX Live / MacTeX / TinyTeX）

推荐使用 `latexmk` 或 `make`（默认调用 `xelatex` + `bibtex`）：

```bash
# 编译硕士论文（默认，输出 main.pdf）
latexmk -xelatex main.tex
# 或
make master

# 编译博士论文（输出 main-doctor.pdf）
make doctor

# 编译盲审版本（输出 main-anonymous.pdf）
make anonymous

# 清理中间临时文件
make clean
```

---

## 文档类选项说明

在 `main.tex` 第一行 `\documentclass[...]{hainanuthesis}` 中可组合配置以下选项：

| 选项 | 可选值 | 默认值 | 说明 |
| :--- | :--- | :--- | :--- |
| `degree` | `master` / `doctor` | `master` | 切换硕士 / 博士封面、页眉及成果页标题 |
| `anonymous` | `false` / `true` | `false` | 盲审模式：隐去姓名/导师/学号、跳过声明与致谢、清除 PDF 作者元数据 |
| `print` | `false` / `true` | `false` | 设为 `true` 时，在中文封面/英文封面/声明页后自动插空白页，便于整本双面装订打印（符合规范 3.10） |
| `twoside` / `oneside` | — | `twoside` | `twoside` 启用双面奇偶页眉与奇右偶左页码；`oneside` 适合电子审阅 |
| `enabstractsize` | `spec` / `normal` | `spec` | `spec` 严格按规范 3.6 使用 16pt / 固定行距 20pt；`normal` 切换为小四 12pt / 1.5 倍行距 |
| `tocdepth` | `2` / `3` | `2` | 目录显示层级：二级（符合规范 3.7 表格）或三级（符合规范 1.6 说明） |
| `fontset` | `auto` / `windows` / `mac` / `fandol` | `auto` | 指定 `ctex` 字体集，通常保持 `auto` 自动识别即可 |

---

## 元信息配置（`\hainanusetup`）

```latex
\hainanusetup{
  title        = {中文论文题目},
  subtitle     = {},                        % 可选副标题
  title*       = {English Thesis Title},
  author       = {作者姓名},
  author*      = {ZHANG San},
  supervisor   = {导师姓名~教授},
  supervisor*  = {LI Si},
  student-id   = {202400000001},
  clc          = {TP391},                   % 中图分类号 / UDC
  secret-level = {},                        % 公开论文留空；涉密标注密级与年限
  major        = {计算机科学与技术},
  major*       = {Computer Science and Technology},
  school       = {计算机科学与技术学院（国际数字影视学院）}, % 自动映射附录 B 英文院系名
  % school*    = {Custom School Name},      % 如需自定义英文院系名可取消注释
  date         = {2026 年 5 月 20 日},
  date*        = {May, 2026},
  calis-delay  = {none},                    % CALIS 滞后发布：none | half | one | two
  keywords     = {关键词一, 关键词二, 关键词三},
  keywords*    = {Keyword 1, Keyword 2, Keyword 3},
}
```

---

## 目录结构

```text
HainuThesis/
├── hainanuthesis.cls          # 核心文档类
├── hainanuthesis-schools.def  # 附录 B：全校 35 个学院中英文官方映射表
├── main.tex                   # 论文主入口示例
├── latexmkrc                  # latexmk / Overleaf 自动编译配置
├── Makefile                   # 快捷编译（master / doctor / anonymous）
├── assets/                    # 校徽与书法校名透明底图
├── bib/references.bib         # GB/T 7714-2015 各类参考文献示例
├── chapters/                  # 摘要、符号表、正文各章、附录、成果、致谢
├── figures/                   # 论文插图目录
└── fonts/                     # 可选自定义字体目录（详见 fonts/README.md）
```

---

## 规范细节与注意事项

1. **封面专用字体**：正式打印提交前，建议参照 [`fonts/README.md`](fonts/README.md) 放入合法获取的「方正小标宋简体」与「楷体\_GB2312」，以与学校官方 Word 样张字形保持完全一致。
2. **关于各学院差异**：本模板默认遵循海南大学研究生院全校通用标准（海大党政办〔2023〕47 号，阿拉伯数字分级 `1 / 1.1 / 1.1.1 / 1.1.1.1` + `GB/T 7714-2015` 顺序编码参考文献）。部分人文社科/法学院系如要求中文序号（如“一、（一）、1.”）或页下注引用体系，请在提交前核对本学院补充细则。
3. **书脊生成**：如需打印论文书脊，取消 `main.tex` 末尾 `\makespine` 的注释即可独立生成距上下边界 3 cm 的竖排书脊页。
4. **印刷装订提示（规范 3.10）**：中文摘要之前单面印刷，自中文摘要起双面印刷；硕士封面封底为 180g 浅蓝色羊皮纸，博士为 180g 浅红色羊皮纸，热胶装订。

---

## 版权与免责声明

- 本模板代码采用 [MIT License](LICENSE) 开源发布，为民间维护的非官方模板，**最终提交前请务必对照海南大学研究生院及所在学院当年最新格式要求进行逐页核查**。
- `assets/` 目录下的海南大学校徽与校名书法标识版权归**海南大学**所有，仅供海南大学师生撰写学位论文排版使用，请勿用于任何商业用途。
