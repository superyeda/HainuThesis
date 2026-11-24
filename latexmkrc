# latexmkrc - 默认使用 XeLaTeX + BibTeX 编译（兼容本地与 Overleaf）
$pdf_mode = 5;
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$bibtex_use = 2;
$clean_ext = 'aux bbl bcf blg fdb_latexmk fls idx ilg ind lof log lol lot nav out run.xml snm synctex.gz toc xdv thm';
@default_files = ('main.tex');
