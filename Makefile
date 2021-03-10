# Goal: Makefile write \\bfseries, so gnuplot can escape baskslash and latex
# can interpret \bfseries
OBJECTS = exp.tex

# What I have tried:
# Make variable name for a slash(blank), and to avoid \\ translation to
# newline?

BLANK :=
SLASH = \$(BLANK)
HEADER = $(SLASH)$(SLASH)bfseries
LATEXTERMINAL = cairolatex pdf standalone blacktext# header "$(HEADER)"


# This is only for building elsewhere. Locally use latexmk
exp.pdf: exp.tex
	pdflatex $<
	gv $@

# generate plot. usage: \insert{exp.txt} in main tex document
exp.tex: output.txt Makefile
	echo '\
	set terminal $(LATEXTERMINAL);\
	set output "$@";\
	set title "Comparison of exponential functions";\
	set xlabel "x"; set ylabel "y";\
	f(x) = exp(x);\
	plot \
	  "$<" u "x":"myexp" w l lt 1 lw 7 dt 1 lc "black" t "self-implemented"\
	, "$<" u "x":"exp"   w l lt 2 lw 7 dt 2 lc "red" t "math.h"\
	, f(x) w l lt 2 lw 7 dt 3 lc "yellow" t "gnuplot"\
	' | gnuplot

clean:
	$(RM) *.gpi *.aux *.log *.pdf *.fls *.dvi *.fdb_latexmk *.synctex.gz *.bcf *.eps *.out *.run.xml
	$(RM) $(OBJECTS)
	find ./ -type f -executable -delete

