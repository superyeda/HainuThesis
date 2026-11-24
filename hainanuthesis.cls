% !TeX encoding = UTF-8
% !TeX program = xelatex
%
% hainanuthesis.cls
% 海南大学研究生学位论文 LaTeX 模板（非官方开源项目）
% 依据：《海南大学研究生学位论文撰写规范（修订）》（海大党政办〔2023〕47号）
% License: MIT

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\RequirePackage{expl3}
\ProvidesExplClass{hainanuthesis}{2026/11/24}{1.0.0}
  {Hainan University Graduate Thesis LaTeX Template}

% ----------------------------------------------------------------------
% 1. 引擎检查（强制使用 XeLaTeX）
% ----------------------------------------------------------------------
\sys_if_engine_xetex:F
  {
    \msg_new:nnn { hainanuthesis } { engine-error }
      {
        hainanuthesis~requires~XeLaTeX!~
        Please~compile~your~document~with~`xelatex`~instead.
      }
    \msg_fatal:nn { hainanuthesis } { engine-error }
  }

% ----------------------------------------------------------------------
% 2. 文档类选项定义
% ----------------------------------------------------------------------
\bool_new:N \g__hainanu_doctor_bool
\bool_new:N \g__hainanu_anonymous_bool
\bool_new:N \g__hainanu_print_bool
\bool_new:N \g__hainanu_oneside_bool
\bool_new:N \g__hainanu_enabs_normal_bool
\tl_new:N   \g__hainanu_fontset_tl
\int_new:N  \g__hainanu_tocdepth_int

\tl_gset:Nn  \g__hainanu_fontset_tl { auto }
\int_gset:Nn \g__hainanu_tocdepth_int { 2 }

\keys_define:nn { hainanu/class }
  {
    degree .choices:nn = { master, doctor }
      {
        \str_if_eq:VnTF \l_keys_choice_tl { doctor }
          { \bool_gset_true:N  \g__hainanu_doctor_bool }
          { \bool_gset_false:N \g__hainanu_doctor_bool }
      },
    degree .initial:n = master,

    anonymous .bool_gset:N = \g__hainanu_anonymous_bool,
    anonymous .default:n   = true,

    print .bool_gset:N = \g__hainanu_print_bool,
    print .default:n   = true,

    oneside .bool_gset:N = \g__hainanu_oneside_bool,
    oneside .default:n   = true,
    twoside .code:n      = { \bool_gset_false:N \g__hainanu_oneside_bool },

    fontset .tl_gset:N = \g__hainanu_fontset_tl,

    enabstractsize .choices:nn = { spec, normal }
      {
        \str_if_eq:VnTF \l_keys_choice_tl { normal }
          { \bool_gset_true:N  \g__hainanu_enabs_normal_bool }
          { \bool_gset_false:N \g__hainanu_enabs_normal_bool }
      },
    enabstractsize .initial:n = spec,

    tocdepth .int_gset:N = \g__hainanu_tocdepth_int,

    unknown .code:n = { \PassOptionsToClass { \CurrentOption } { ctexbook } },
  }

\IfFormatAtLeastTF { 2022-06-01 }
  { \ProcessKeyOptions [ hainanu/class ] }
  {
    \RequirePackage{l3keys2e}
    \ProcessKeysOptions { hainanu/class }
  }

% ----------------------------------------------------------------------
% 3. 加载底层文档类 ctexbook
% ----------------------------------------------------------------------
\bool_if:NTF \g__hainanu_oneside_bool
  { \PassOptionsToClass { oneside, openany } { ctexbook } }
  { \PassOptionsToClass { twoside, openany } { ctexbook } }

\str_if_eq:VnF \g__hainanu_fontset_tl { auto }
  { \PassOptionsToClass { fontset = \g__hainanu_fontset_tl } { ctexbook } }

\LoadClass[
  a4paper,
  zihao=-4,
  UTF8,
  heading=true,
  scheme=chinese,
  punct=quanjiao
]{ctexbook}

% 加载附录 B 学院中英文映射表
\InputIfFileExists{hainanuthesis-schools.def}{}{}

% ----------------------------------------------------------------------
% 4. 基础宏包加载
% ----------------------------------------------------------------------
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{bm}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{makecell}
\RequirePackage{array}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{enumitem}
\RequirePackage{setspace}
\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage{chngcntr}
\RequirePackage[super, sort&compress]{gbt7714}
\RequirePackage[hidelinks, bookmarksnumbered=true, bookmarksopen=true, plainpages=false, pdfpagelabels=true]{hyperref}

% ----------------------------------------------------------------------
% 5. 页面几何设置（规范 3.1：A4，上2.5 下2.5 左3.0 右2.5，装订线0）
% ----------------------------------------------------------------------
\bool_if:NTF \g__hainanu_oneside_bool
  {
    \geometry{
      a4paper,
      top=2.50cm,
      bottom=2.50cm,
      left=3.00cm,
      right=2.50cm,
      bindingoffset=0cm,
      headheight=15pt,
      headsep=0.22cm,
      footskip=0.65cm,
    }
  }
  {
    \geometry{
      a4paper,
      top=2.50cm,
      bottom=2.50cm,
      inner=3.00cm,
      outer=2.50cm,
      bindingoffset=0cm,
      headheight=15pt,
      headsep=0.22cm,
      footskip=0.65cm,
    }
  }

% 正文 1.5 倍行距，首行缩进 2 字符，段前段后 0 行
\linespread{1.5}\selectfont
\setlength{\parindent}{2\ccwd}
\setlength{\parskip}{0pt}

% ----------------------------------------------------------------------
% 6. 字体配置与跨平台安全回退（零报错设计）
% ----------------------------------------------------------------------
% 西文字体：优先 Times New Roman，缺失时回退 TeX Gyre Termes
\IfFontExistsTF{Times~New~Roman}
  { \setmainfont{Times~New~Roman} }
  {
    \IfFontExistsTF{TeX~Gyre~Termes}
      { \setmainfont{TeX~Gyre~Termes} }
      { }
  }
\IfFontExistsTF{Arial}
  { \setsansfont{Arial} }
  {
    \IfFontExistsTF{TeX~Gyre~Heros}
      { \setsansfont{TeX~Gyre~Heros} }
      { }
  }
\IfFontExistsTF{Courier~New}
  { \setmonofont{Courier~New} }
  {
    \IfFontExistsTF{TeX~Gyre~Cursor}
      { \setmonofont{TeX~Gyre~Cursor} }
      { }
  }

% 封面专用：方正小标宋简体（FZXiaoBiaoSong-B05S / fonts/FZXBSJW.TTF）
\cs_new_protected:Npn \__hainanu_setup_special_fonts:
  {
    \file_if_exist:nTF { fonts/FZXBSJW.TTF }
      {
        \newCJKfontfamily\hainanu@xiaobiaosong{FZXBSJW.TTF}[
          Path = fonts/,
          AutoFakeBold = 2.5
        ]
      }
      {
        \file_if_exist:nTF { fonts/FZXBSJW.ttf }
          {
            \newCJKfontfamily\hainanu@xiaobiaosong{FZXBSJW.ttf}[
              Path = fonts/,
              AutoFakeBold = 2.5
            ]
          }
          {
            \IfFontExistsTF{FZXiaoBiaoSong-B05S}
              { \newCJKfontfamily\hainanu@xiaobiaosong{FZXiaoBiaoSong-B05S}[AutoFakeBold=2.5] }
              {
                \IfFontExistsTF{方正小标宋简体}
                  { \newCJKfontfamily\hainanu@xiaobiaosong{方正小标宋简体}[AutoFakeBold=2.5] }
                  {
                    \ClassWarningNoLine{hainanuthesis}{Font~'FZXiaoBiaoSong-B05S'~(方正小标宋简体)~not~found;~falling~back~to~bold~Songti.~See~fonts/README.md}
                    \cs_gset_protected:Npn \hainanu@xiaobiaosong { \songti\bfseries }
                  }
              }
          }
      }

    % 封面专用：楷体_GB2312（fonts/KaiTi_GB2312.ttf / KaiTi_GB2312 / 系统楷体）
    \file_if_exist:nTF { fonts/KaiTi_GB2312.ttf }
      {
        \newCJKfontfamily\hainanu@kaitigb{KaiTi_GB2312.ttf}[
          Path = fonts/,
          AutoFakeBold = 2.5
        ]
      }
      {
        \file_if_exist:nTF { fonts/simkai.ttf }
          {
            \newCJKfontfamily\hainanu@kaitigb{simkai.ttf}[
              Path = fonts/,
              AutoFakeBold = 2.5
            ]
          }
          {
            \IfFontExistsTF{KaiTi_GB2312}
              { \newCJKfontfamily\hainanu@kaitigb{KaiTi_GB2312}[AutoFakeBold=2.5] }
              {
                \IfFontExistsTF{楷体_GB2312}
                  { \newCJKfontfamily\hainanu@kaitigb{楷体_GB2312}[AutoFakeBold=2.5] }
                  {
                    \IfFontExistsTF{Kaiti~SC}
                      { \newCJKfontfamily\hainanu@kaitigb{Kaiti~SC}[AutoFakeBold=2.5] }
                      {
                        \ClassWarningNoLine{hainanuthesis}{Font~'KaiTi_GB2312'~(楷体_GB2312)~not~found;~falling~back~to~default~Kaishu.~See~fonts/README.md}
                        \cs_gset_protected:Npn \hainanu@kaitigb { \kaishu }
                      }
                  }
              }
          }
      }
  }
\__hainanu_setup_special_fonts:

% ----------------------------------------------------------------------
% 7. 论文元信息配置接口 \hainanusetup{...}
% ----------------------------------------------------------------------
\tl_new:N \g__hainanu_title_tl
\tl_new:N \g__hainanu_subtitle_tl
\tl_new:N \g__hainanu_title_en_tl
\tl_new:N \g__hainanu_author_tl
\tl_new:N \g__hainanu_author_en_tl
\tl_new:N \g__hainanu_supervisor_tl
\tl_new:N \g__hainanu_supervisor_en_tl
\tl_new:N \g__hainanu_student_id_tl
\tl_new:N \g__hainanu_clc_tl
\tl_new:N \g__hainanu_secret_level_tl
\tl_new:N \g__hainanu_school_code_tl
\tl_new:N \g__hainanu_major_tl
\tl_new:N \g__hainanu_major_en_tl
\tl_new:N \g__hainanu_school_tl
\tl_new:N \g__hainanu_school_en_tl
\tl_new:N \g__hainanu_date_tl
\tl_new:N \g__hainanu_date_en_tl
\tl_new:N \g__hainanu_calis_delay_tl
\tl_new:N \g__hainanu_emblem_tl
\tl_new:N \g__hainanu_name_img_tl
\clist_new:N \g__hainanu_keywords_clist
\clist_new:N \g__hainanu_keywords_en_clist

\tl_gset:Nn \g__hainanu_school_code_tl { 10589 }
\tl_gset:Nn \g__hainanu_calis_delay_tl { none }
\tl_gset:Nn \g__hainanu_emblem_tl      { assets/hainanu-emblem.png }
\tl_gset:Nn \g__hainanu_name_img_tl    { assets/hainanu-name.png }

\keys_define:nn { hainanu/meta }
  {
    title         .tl_gset:N    = \g__hainanu_title_tl,
    subtitle      .tl_gset:N    = \g__hainanu_subtitle_tl,
    title*        .tl_gset:N    = \g__hainanu_title_en_tl,
    author        .tl_gset:N    = \g__hainanu_author_tl,
    author*       .tl_gset:N    = \g__hainanu_author_en_tl,
    supervisor    .tl_gset:N    = \g__hainanu_supervisor_tl,
    supervisor*   .tl_gset:N    = \g__hainanu_supervisor_en_tl,
    student-id    .tl_gset:N    = \g__hainanu_student_id_tl,
    clc           .tl_gset:N    = \g__hainanu_clc_tl,
    secret-level  .tl_gset:N    = \g__hainanu_secret_level_tl,
    school-code   .tl_gset:N    = \g__hainanu_school_code_tl,
    major         .tl_gset:N    = \g__hainanu_major_tl,
    major*        .tl_gset:N    = \g__hainanu_major_en_tl,
    school        .tl_gset:N    = \g__hainanu_school_tl,
    school*       .tl_gset:N    = \g__hainanu_school_en_tl,
    date          .tl_gset:N    = \g__hainanu_date_tl,
    date*         .tl_gset:N    = \g__hainanu_date_en_tl,
    calis-delay   .tl_gset:N    = \g__hainanu_calis_delay_tl,
    emblem        .tl_gset:N    = \g__hainanu_emblem_tl,
    name-image    .tl_gset:N    = \g__hainanu_name_img_tl,
    keywords      .clist_gset:N = \g__hainanu_keywords_clist,
    keywords*     .clist_gset:N = \g__hainanu_keywords_en_clist,
  }

\NewDocumentCommand{\hainanusetup}{ m }
  {
    \keys_set:nn { hainanu/meta } { #1 }
    % 若未手填英文学院名，则根据规范附录 B 自动映射
    \tl_if_empty:NT \g__hainanu_school_en_tl
      {
        \tl_if_empty:NF \g__hainanu_school_tl
          {
            \cs_if_exist:NT \__hainanu_lookup_school_en:nN
              {
                \exp_args:NV \__hainanu_lookup_school_en:nN
                  \g__hainanu_school_tl \g__hainanu_school_en_tl
              }
          }
      }
    % 写入 PDF 元数据（盲审模式下不写入个人身份信息）
    \bool_if:NTF \g__hainanu_anonymous_bool
      {
        \hypersetup{
          pdftitle  = { \g__hainanu_title_tl },
          pdfauthor = { Anonymous },
        }
      }
      {
        \hypersetup{
          pdftitle  = { \g__hainanu_title_tl },
          pdfauthor = { \g__hainanu_author_tl },
        }
      }
  }

% ----------------------------------------------------------------------
% 8. 页眉与页码样式（规范 2.3 & 3.1）
% ----------------------------------------------------------------------
\cs_new:Npn \__hainanu_degree_header_zh:
  {
    \bool_if:NTF \g__hainanu_doctor_bool
      { 海南大学博士学位论文 }
      { 海南大学硕士学位论文 }
  }

\cs_new:Npn \__hainanu_degree_title_zh:
  {
    \bool_if:NTF \g__hainanu_doctor_bool
      { 博\hspace{0.45em}士\hspace{0.45em}学\hspace{0.45em}位\hspace{0.45em}论\hspace{0.45em}文 }
      { 硕\hspace{0.45em}士\hspace{0.45em}学\hspace{0.45em}位\hspace{0.45em}论\hspace{0.45em}文 }
  }

\cs_new:Npn \__hainanu_degree_title_en:
  {
    \bool_if:NTF \g__hainanu_doctor_bool
      { A~Dissertation~Submitted~to~Hainan~University\\ for~the~Degree~of~Doctor }
      { A~Thesis~Submitted~to~Hainan~University\\ for~the~Degree~of~Master }
  }

% 前置部分页样式：无页眉，大写罗马数字居中
\fancypagestyle{hainanu@front}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyfoot[C]{\zihao{5}\rmfamily\thepage}
}

% 主体及结尾页样式：
% 奇数页页眉：海南大学博士/硕士学位论文；偶数页页眉：当前一级标题
% 阿拉伯数字页码：奇数页居右、偶数页居左（oneside 模式下居右）
\fancypagestyle{hainanu@main}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0.5pt}
  \renewcommand{\footrulewidth}{0pt}
  \bool_if:NTF \g__hainanu_oneside_bool
    {
      \fancyhead[C]{\zihao{5}\songti \__hainanu_degree_header_zh:}
      \fancyfoot[R]{\zihao{5}\rmfamily\thepage}
    }
    {
      \fancyhead[CO]{\zihao{5}\songti \__hainanu_degree_header_zh:}
      \fancyhead[CE]{\zihao{5}\songti \leftmark}
      \fancyfoot[RO,LE]{\zihao{5}\rmfamily\thepage}
    }
}

% 控制 frontmatter / mainmatter / backmatter 行为
\renewcommand{\frontmatter}{
  \clearpage
  \@mainmatterfalse
  \pagenumbering{Roman}
  \pagestyle{hainanu@front}
  \fancypagestyle{plain}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[C]{\zihao{5}\rmfamily\thepage}
  }
}

\renewcommand{\mainmatter}{
  \bool_if:NTF \g__hainanu_print_bool
    { \cleardoublepage }
    { \clearpage }
  \@mainmattertrue
  \pagenumbering{arabic}
  \pagestyle{hainanu@main}
  \fancypagestyle{plain}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.5pt}
    \bool_if:NTF \g__hainanu_oneside_bool
      {
        \fancyhead[C]{\zihao{5}\songti \__hainanu_degree_header_zh:}
        \fancyfoot[R]{\zihao{5}\rmfamily\thepage}
      }
      {
        \fancyhead[CO]{\zihao{5}\songti \__hainanu_degree_header_zh:}
        \fancyhead[CE]{\zihao{5}\songti \leftmark}
        \fancyfoot[RO,LE]{\zihao{5}\rmfamily\thepage}
      }
  }
}

\renewcommand{\backmatter}{
  \clearpage
  \@mainmatterfalse
}

% 单面打印辅助分页（print=true 时插入空白背面页，符合规范 3.10）
\cs_new_protected:Npn \__hainanu_single_sided_break:
  {
    \clearpage
    \bool_if:NT \g__hainanu_print_bool
      {
        \ifodd\c@page\else
          \null\thispagestyle{empty}\clearpage
        \fi
      }
  }

% ----------------------------------------------------------------------
% 9. 中文封面、英文封面、原创性声明及版权授权页（规范 3.2、3.4、3.5）
% ----------------------------------------------------------------------
% 封面下划线填表项：纯原生实现（零外部宏包依赖），4 条下划线严格等长 8.2cm，超长学院名自动居中换行
\box_new:N \l__hainanu_tmp_box
\cs_new_protected:Npn \__hainanu_cover_line:nn #1#2
  {
    \makebox[4.2\ccwd][l]{#1}： & #2 \\ \cline{2-2}
  }

\NewDocumentCommand{\makecover}{}
  {
    % 前置无页码部分使用独立 Alph 内部编号，避免与正文阿拉伯页码产生 hyperref 锚点冲突
    \clearpage
    \pagenumbering{Alph}

    % === 1. 中文封面 ===
    \thispagestyle{empty}
    \begingroup
    \linespread{1.5}\selectfont

    % 顶部：左侧四项元数据 + 右侧校徽（3.4cm × 2.8cm 靠右）
    \noindent
    \begin{minipage}[t]{0.66\textwidth}
      \vspace{0pt}
      \zihao{3}\hainanu@kaitigb
      \begin{tabular}{@{}l@{\,}l@{}}
        \makebox[4\ccwd][l]{学\hfill 校\hfill 代\hfill 码}： & \g__hainanu_school_code_tl \\
        \makebox[4\ccwd][l]{分\hfill 类\hfill 号}： & \g__hainanu_clc_tl \\
        \makebox[4\ccwd][l]{学\hfill 号}： &
          \bool_if:NTF \g__hainanu_anonymous_bool { （盲审隐去） } { \g__hainanu_student_id_tl } \\
        \makebox[4\ccwd][l]{密\hfill 级}： & \g__hainanu_secret_level_tl \\
      \end{tabular}
    \end{minipage}
    \hfill
    \begin{minipage}[t]{0.30\textwidth}
      \vspace{0pt}
      \raggedleft
      \file_if_exist:VTF \g__hainanu_emblem_tl
        { \includegraphics[height=3.4cm, width=2.8cm, keepaspectratio]{\g__hainanu_emblem_tl} }
        { \fbox{\parbox[c][3.4cm][c]{2.6cm}{\centering\zihao{5}海南大学\\校徽占位}} }
    \end{minipage}

    \vspace{1.0cm}

    % 居中书法校名（2.0cm × 7.7cm）
    \begin{center}
      \file_if_exist:VTF \g__hainanu_name_img_tl
        { \includegraphics[height=2.0cm, width=7.7cm, keepaspectratio]{\g__hainanu_name_img_tl} }
        { {\zihao{0}\hainanu@xiaobiaosong 海~南~大~学} }
    \end{center}

    % 硕士/博士学位论文：方正小标宋简体，初号加粗，居中，单倍行距，段前段后 1.5 行
    \begin{center}
      \vspace{0.35cm}
      {\linespread{1.0}\selectfont\zihao{0}\hainanu@xiaobiaosong\bfseries
        \__hainanu_degree_title_zh:\par}
      \vspace{1.1cm}
    \end{center}

    % 中文论文题目：楷体_GB2312 一号加粗，居中，1.5 倍行距
    \begin{center}
      \begin{minipage}{0.90\textwidth}
        \centering
        \linespread{1.5}\selectfont
        {\zihao{1}\hainanu@kaitigb\bfseries \g__hainanu_title_tl \par}
        \tl_if_empty:NF \g__hainanu_subtitle_tl
          {
            \vspace{0.25cm}
            {\zihao{2}\hainanu@kaitigb\bfseries ——\g__hainanu_subtitle_tl \par}
          }
      \end{minipage}
    \end{center}

    \vfill

    % 下方作者信息块：楷体_GB2312 三号，1.5 倍行距，4 条等长 8.2cm 底线
    \begin{center}
      \zihao{3}\hainanu@kaitigb
      \renewcommand{\arraystretch}{1.45}
      \begin{tabular}{@{}l@{\hspace{0.2em}}>{\centering\arraybackslash}m{8.2cm}@{}}
        \__hainanu_cover_line:nn { 作\hfill 者\hfill 姓\hfill 名 }
          { \bool_if:NTF \g__hainanu_anonymous_bool { （盲审隐去） } { \g__hainanu_author_tl } }
        \__hainanu_cover_line:nn { 导\hfill 师\hfill 姓\hfill 名 }
          { \bool_if:NTF \g__hainanu_anonymous_bool { （盲审隐去） } { \g__hainanu_supervisor_tl } }
        \__hainanu_cover_line:nn { 学\hfill 科\hfill 专\hfill 业 } { \g__hainanu_major_tl }
        \__hainanu_cover_line:nn { 培\hfill 养\hfill 院\hfill 系 } { \g__hainanu_school_tl }
      \end{tabular}
    \end{center}

    \vspace{1.0cm}

    % 底部日期：楷体_GB2312 三号，居中
    \begin{center}
      {\zihao{3}\hainanu@kaitigb \g__hainanu_date_tl \par}
    \end{center}
    \vspace{0.4cm}

    \endgroup
    \__hainanu_single_sided_break:

    % === 2. 英文封面（规范 3.4） ===
    \thispagestyle{empty}
    \begingroup
    \rmfamily\centering
    \vspace*{1.2cm}

    % 申请学位语句：Times New Roman 22pt 加粗，居中，1.5 倍行距
    {\fontsize{22pt}{33pt}\selectfont\bfseries
      \__hainanu_degree_title_en: \par}

    \vspace{2.6cm}

    % 英文题目：Times New Roman 20pt 加粗，居中，1.5 倍行距
    \begin{minipage}{0.90\textwidth}
      \centering
      {\fontsize{20pt}{30pt}\selectfont\bfseries \g__hainanu_title_en_tl \par}
    \end{minipage}

    \vfill

    % 申请人/导师/学科专业/学院/日期：Times New Roman 16pt 居中，1.5 倍行距
    {\fontsize{16pt}{28pt}\selectfont
      By~\bool_if:NTF \g__hainanu_anonymous_bool { Anonymous } { \g__hainanu_author_en_tl } \par
      \vspace{0.35cm}
      Supervisor:~\bool_if:NTF \g__hainanu_anonymous_bool { Anonymous } { \g__hainanu_supervisor_en_tl } \par
      \vspace{0.35cm}
      \g__hainanu_major_en_tl \par
      \vspace{0.35cm}
      \g__hainanu_school_en_tl \par
      \vspace{0.35cm}
      \g__hainanu_date_en_tl \par
    }
    \vspace{1.5cm}

    \endgroup
    \__hainanu_single_sided_break:
  }

% 复选框绘制辅助（CALIS 滞后发布选项）
\cs_new_protected:Npn \__hainanu_calis_box:n #1
  {
    \str_if_eq:VnTF \g__hainanu_calis_delay_tl { #1 }
      { $\boxtimes$ }
      { $\square$ }
  }

% === 3. 原创性声明和使用授权说明（规范 3.5，盲审模式自动跳过） ===
\NewDocumentCommand{\makedeclaration}{}
  {
    \bool_if:NF \g__hainanu_anonymous_bool
      {
        \clearpage
        \thispagestyle{empty}
        \begingroup
        \linespread{1.5}\selectfont

        \begin{center}
          \hbox_set:Nn \l__hainanu_tmp_box { \zihao{2}\hainanu@xiaobiaosong 海南大学学位论文原创性声明和使用授权说明 }
          \dim_compare:nNnTF { \box_wd:N \l__hainanu_tmp_box } > { \textwidth }
            { \resizebox{\textwidth}{!}{\box_use:N \l__hainanu_tmp_box} }
            { \box_use:N \l__hainanu_tmp_box }
          \par
        \end{center}
        \vspace{0.4cm}

        \begin{center}
          {\zihao{-4}\songti\bfseries 原创性声明 \par}
        \end{center}
        \vspace{0.1cm}
        {\zihao{-4}\songti
          本人郑重声明：所呈交的学位论文，是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不含任何其他个人或集体已经发表或撰写过的作品或成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本声明的法律结果由本人承担。\par
          \vspace{0.35cm}
          \noindent\hspace{2\ccwd}论文作者签名：\hspace{5.2cm}日期：\hspace{1.2cm}年\hspace{0.8cm}月\hspace{0.8cm}日\par
        }

        \vspace{0.9cm}

        \begin{center}
          {\zihao{-4}\songti\bfseries 学位论文版权使用授权说明 \par}
        \end{center}
        \vspace{0.1cm}
        {\zihao{-4}\songti
          本人完全了解海南大学关于收集、保存、使用学位论文的规定，即：学校有权保留并向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅。学校可以为存在馆际合作关系兄弟高校用户提供文献传递服务和交换服务。本人授权海南大学可以将本学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。\par
          保密论文在解密后遵守此规定。\par
          \vspace{0.35cm}
          \noindent\hspace{2\ccwd}论文作者签名：\hspace{5.2cm}导师签名：\par
          \vspace{0.25cm}
          \noindent\hspace{2\ccwd}日期：\hspace{0.9cm}年\hspace{0.7cm}月\hspace{0.7cm}日\hspace{2.7cm}日期：\hspace{0.9cm}年\hspace{0.7cm}月\hspace{0.7cm}日\par
        }

        \vspace{0.7cm}
        \noindent\makebox[\textwidth][s]{\dotfill}\par
        \vspace{0.5cm}

        {\zihao{-4}\songti
          本人已经认真阅读“CALIS~高校学位论文全文数据库发布章程”，同意将本人的学位论文提交“CALIS~高校学位论文全文数据库”中全文发布，并可按“章程”中规定享受相关权益。\par
          同意论文提交后滞后：\__hainanu_calis_box:n{half}半年、\__hainanu_calis_box:n{one}一年、\__hainanu_calis_box:n{two}二年发布。\par
          \vspace{0.35cm}
          \noindent\hspace{2\ccwd}论文作者签名：\hspace{5.2cm}导师签名：\par
          \vspace{0.25cm}
          \noindent\hspace{2\ccwd}日期：\hspace{0.9cm}年\hspace{0.7cm}月\hspace{0.7cm}日\hspace{2.7cm}日期：\hspace{0.9cm}年\hspace{0.7cm}月\hspace{0.7cm}日\par
        }

        \endgroup
        \__hainanu_single_sided_break:
      }
  }

% ----------------------------------------------------------------------
% 10. 中、英文摘要环境（规范 1.4、1.5、3.6）
% ----------------------------------------------------------------------
\NewDocumentEnvironment{cnabstract}{}
  {
    \clearpage
    \pagestyle{hainanu@front}
    \phantomsection
    \addcontentsline{toc}{chapter}{摘要}
    \begin{center}
      \vspace*{0.5\baselineskip}
      {\zihao{3}\heiti 摘要 \par}
      \vspace{1.2\baselineskip}
    \end{center}
    \zihao{-4}\songti\linespread{1.5}\selectfont
  }
  {
    \par\vspace{0.8\baselineskip}
    \noindent\hspace{2\ccwd}{\bfseries 关键词：}
    \clist_use:Nn \g__hainanu_keywords_clist { ； }
    \par
    \clearpage
  }

\NewDocumentEnvironment{enabstract}{}
  {
    \clearpage
    \pagestyle{hainanu@front}
    \phantomsection
    \addcontentsline{toc}{chapter}{ABSTRACT}
    \begin{center}
      \vspace*{0.5\baselineskip}
      {\rmfamily\fontsize{20pt}{30pt}\selectfont\bfseries ABSTRACT \par}
      \vspace{1.2\baselineskip}
    \end{center}
    \rmfamily
    \bool_if:NTF \g__hainanu_enabs_normal_bool
      { \fontsize{12pt}{18pt}\selectfont }
      { \fontsize{16pt}{20pt}\selectfont }
    \setlength{\parindent}{2\ccwd}
    \emergencystretch=2.5em\relax
  }
  {
    \par\vspace{0.8\baselineskip}
    \noindent\hspace{2\ccwd}{\bfseries Key~Words:~}
    \clist_use:Nn \g__hainanu_keywords_en_clist { ;~ }
    \par
    \clearpage
  }

% ----------------------------------------------------------------------
% 11. 章节标题层次设置（规范 2.2 & 3.8）
% ----------------------------------------------------------------------
\setcounter{secnumdepth}{3}
% 用户级 tocdepth=2 对应章+节（LaTeX tocdepth=1）；tocdepth=3 对应章+节+条（LaTeX tocdepth=2）
\setcounter{tocdepth}{\int_eval:n { \g__hainanu_tocdepth_int - 1 }}
\renewcommand{\@pnumwidth}{2.4em}
\renewcommand{\@tocrmarg}{3.2em}

\ctexset{
  chapter = {
    name        = {},
    number      = \arabic{chapter},
    aftername   = \hspace{1\ccwd},
    format      = \zihao{3}\heiti\centering,
    beforeskip  = 1.5\baselineskip,
    afterskip   = 1.5\baselineskip,
    fixskip     = true,
    break       = \clearpage,
    pagestyle   = plain,
  },
  section = {
    aftername   = \hspace{1\ccwd},
    format      = \zihao{4}\heiti\raggedright,
    beforeskip  = 1.0\baselineskip,
    afterskip   = 1.0\baselineskip,
    fixskip     = true,
  },
  subsection = {
    aftername   = \hspace{1\ccwd},
    format      = \zihao{-4}\heiti\raggedright,
    beforeskip  = 1.0\baselineskip,
    afterskip   = 1.0\baselineskip,
    fixskip     = true,
  },
  subsubsection = {
    aftername   = \hspace{1\ccwd},
    format      = \zihao{-4}\songti\raggedright,
    beforeskip  = 1.0\baselineskip,
    afterskip   = 1.0\baselineskip,
    fixskip     = true,
  },
}

% 偶数页页眉标记：显示“章号 章名”（无“第X章”）
\renewcommand{\chaptermark}[1]{
  \if@mainmatter
    \markboth{\thechapter\hspace{0.5\ccwd}#1}{}
  \else
    \markboth{#1}{}
  \fi
}
\renewcommand{\sectionmark}[1]{}

% ----------------------------------------------------------------------
% 12. 目录、图表清单、主要符号表（规范 1.6、1.7、3.7、3.9）
% ----------------------------------------------------------------------
\renewcommand{\contentsname}{目录}
\renewcommand{\listfigurename}{插图清单}
\renewcommand{\listtablename}{附表清单}

% 目录条目样式（规范 3.7）
% 前置、一级标题、参考文献/附录/成果/致谢：黑体四号；二级标题：宋体四号
\titlecontents{chapter}[0em]
  {\linespread{1.5}\selectfont\zihao{4}\heiti}
  {\thecontentslabel\hspace{1\ccwd}}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\titlecontents{section}[1.5\ccwd]
  {\linespread{1.5}\selectfont\zihao{4}\songti}
  {\thecontentslabel\hspace{1\ccwd}}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\titlecontents{subsection}[3.0\ccwd]
  {\linespread{1.5}\selectfont\zihao{-4}\songti}
  {\thecontentslabel\hspace{1\ccwd}}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\titlecontents{figure}[0em]
  {\linespread{1.5}\selectfont\zihao{5}\songti}
  {图~\thecontentslabel\hspace{1\ccwd}}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\titlecontents{table}[0em]
  {\linespread{1.5}\selectfont\zihao{5}\songti}
  {表~\thecontentslabel\hspace{1\ccwd}}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\NewDocumentCommand{\maketoc}{}
  {
    \clearpage
    \pagestyle{hainanu@front}
    \begingroup
      \ctexset{chapter/format = \zihao{3}\heiti\bfseries\centering}
      \tableofcontents
    \endgroup
    \clearpage
  }

\NewDocumentCommand{\makelistoffigures}{}
  {
    \clearpage
    \pagestyle{hainanu@front}
    \phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}
    \listoffigures
    \clearpage
  }

\NewDocumentCommand{\makelistoftables}{}
  {
    \clearpage
    \pagestyle{hainanu@front}
    \phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}
    \listoftables
    \clearpage
  }

% 主要符号表环境（规范 1.7 & 3.9：正文宋体五号 1.5 倍行距）
\NewDocumentEnvironment{denotation}{ O{主要符号表} }
  {
    \clearpage
    \pagestyle{hainanu@front}
    \phantomsection
    \addcontentsline{toc}{chapter}{#1}
    \chapter*{#1}
    \zihao{5}\songti\linespread{1.5}\selectfont
  }
  {
    \clearpage
  }

% ----------------------------------------------------------------------
% 13. 图、表、公式编号与标题规范（规范 2.4 & 3.8）
% ----------------------------------------------------------------------
\counterwithin{figure}{chapter}
\counterwithin{table}{chapter}
\counterwithin{equation}{chapter}

\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}

\DeclareCaptionFont{hainanu@capfont}{\zihao{5}\songti\linespread{1.5}\selectfont}
\captionsetup{
  font=hainanu@capfont,
  labelsep=quad,
  justification=centering,
  skip=6pt,
}
\captionsetup[figure]{position=bottom}
\captionsetup[table]{position=top}
\captionsetup[sub]{font=hainanu@capfont}

% 表格正文默认宋体五号（10.5pt），仅作用于 table 与 longtable，避免影响封面排版
\AtBeginEnvironment{table}{\zihao{5}\songti}
\AtBeginEnvironment{longtable}{\zihao{5}\songti}

% 定理类中文环境
\newtheorem{theorem}{定理}[chapter]
\newtheorem{lemma}{引理}[chapter]
\newtheorem{proposition}{命题}[chapter]
\newtheorem{corollary}{推论}[chapter]
\newtheorem{definition}{定义}[chapter]
\newtheorem{assumption}{假设}[chapter]
\newtheorem{remark}{注}[chapter]
\renewcommand{\proofname}{证明}

% ----------------------------------------------------------------------
% 14. 参考文献设置（规范 2.5 & 3.9：GB/T 7714-2015）
% ----------------------------------------------------------------------
\bibliographystyle{gbt7714-numeric}
% 提供正文平齐引用命令（如“由文献[8, 10-14]可知：”）
\NewDocumentCommand{\citeinline}{ m }{[\citenum{#1}]}

\renewcommand{\bibname}{参考文献}
\setlength{\bibsep}{0pt}

\NewDocumentCommand{\makebibliography}{ m }
  {
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{参考文献}
    \markboth{参考文献}{}
    \begingroup
      \zihao{5}\songti\linespread{1.5}\selectfont
      \bibliography{#1}
    \endgroup
  }

% ----------------------------------------------------------------------
% 15. 附录设置（规范 1.11：附录编号与标题各占一行居中；图A1/表A1/(A1)）
% ----------------------------------------------------------------------
\let\__hainanu_orig_appendix\appendix
\renewcommand{\appendix}{
  \__hainanu_orig_appendix
  \setcounter{chapter}{0}
  \ctexset{
    chapter = {
      name      = {附录\hspace{0.5\ccwd}},
      number    = \Alph{chapter},
      aftername = {\par\nobreak\vskip 4pt},
      format    = \zihao{3}\heiti\centering,
    },
  }
  \renewcommand{\thefigure}{\Alph{chapter}\arabic{figure}}
  \renewcommand{\thetable}{\Alph{chapter}\arabic{table}}
  \renewcommand{\theequation}{\Alph{chapter}\arabic{equation}}
  \renewcommand{\chaptermark}[1]{\markboth{附录\hspace{0.5\ccwd}\Alph{chapter}\hspace{0.5\ccwd}##1}{}}
  % ctexbook 已将“附录 A”作为 \thecontentslabel 写入 .toc，此处不再重复拼接前缀
}

% ----------------------------------------------------------------------
% 16. 攻读学位期间取得的成果与致谢（规范 1.12、1.13、3.9）
% ----------------------------------------------------------------------
\cs_new_protected:Npn \__hainanu_unnumbered_chapter:n #1
  {
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{#1}
    \chapter*{#1}
    \markboth{#1}{}
  }

\NewDocumentEnvironment{achievements}{}
  {
    \tl_set:Nx \l_tmpa_tl
      {
        \bool_if:NTF \g__hainanu_doctor_bool
          { 攻读博士学位期间取得的成果 }
          { 攻读硕士学位期间取得的成果 }
      }
    \exp_args:NV \__hainanu_unnumbered_chapter:n \l_tmpa_tl
    \zihao{-4}\songti\linespread{1.5}\selectfont
    \bool_if:NT \g__hainanu_anonymous_bool
      {
        \noindent{\bfseries （盲审提示：请将以下成果中的本人及导师姓名以“本人”“导师”或“第一作者”等匿名方式替换。）}\par\vspace{0.5\baselineskip}
      }
  }
  {
    \clearpage
  }

\NewDocumentEnvironment{acknowledgements}{}
  {
    \bool_if:NTF \g__hainanu_anonymous_bool
      {
        % 盲审模式下自动隐藏致谢内容
        \setbox0=\vbox\bgroup
      }
      {
        \clearpage
        \phantomsection
        \addcontentsline{toc}{chapter}{致谢}
        \chapter*{致谢}
        \markboth{致谢}{}
        \zihao{-4}\songti\linespread{1.5}\selectfont
      }
  }
  {
    \bool_if:NTF \g__hainanu_anonymous_bool
      { \egroup }
      { \clearpage }
  }

% ----------------------------------------------------------------------
% 17. 书脊生成命令（规范 3.3：上方题目、中间姓名、下方“海南大学”，距上下边界 3cm）
% ----------------------------------------------------------------------
\NewDocumentCommand{\makespine}{}
  {
    \clearpage
    \thispagestyle{empty}
    \begingroup
    \centering
    \vspace*{1.5cm}
    \fboxsep=0pt
    \begin{minipage}[c][24.7cm][c]{2.2cm}
      \centering
      \vspace*{0.5cm}
      % 上方：论文题目（竖排）
      \parbox[t][11cm][t]{1.2em}{
        \centering\zihao{4}\heiti\linespread{1.15}\selectfont
        \g__hainanu_title_tl
      }
      \vfill
      % 中间：研究生姓名（竖排）
      \parbox[c][4cm][c]{1.2em}{
        \centering\zihao{4}\heiti\linespread{1.15}\selectfont
        \bool_if:NTF \g__hainanu_anonymous_bool { 盲审论文 } { \g__hainanu_author_tl }
      }
      \vfill
      % 下方：“海南大学”（竖排）
      \parbox[b][4cm][b]{1.2em}{
        \centering\zihao{4}\heiti\linespread{1.15}\selectfont
        海南大学
      }
      \vspace*{0.5cm}
    \end{minipage}
    \endgroup
    \clearpage
  }

\endinput
