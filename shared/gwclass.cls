\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gwclass}[2024-01-02 George Willingham's LaTeX Class]




% use sans serif font
\renewcommand{\familydefault}{\sfdefault}
\renewcommand{\normalsize}{\fontsize{9}{10}\selectfont}


\RequirePackage[dvipsnames]{xcolor}
\def\stylecolor{MidnightBlue} % color of all the lines

% Options
\DeclareOption{twocolumn}{\newcommand{\columns}{twocolumn} \newcommand{\IsTwoCols}{true}}
\DeclareOption{onecolumn}{\newcommand{\columns}{onecolumn}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[\columns]{article}



\RequirePackage[height=9in,a4paper,hmargin={2.5cm,2.5cm}]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage{physics}
\RequirePackage{amsmath}
\RequirePackage{mathrsfs}
\RequirePackage{amssymb}
\RequirePackage{bbm}
\RequirePackage{tcolorbox}
\RequirePackage{titlesec}
\RequirePackage{hyperref}
\RequirePackage{multicol}

\hypersetup{
	colorlinks,
	linkcolor=\stylecolor
}


\titleformat{\section}
{\Large\bfseries\color{\stylecolor}}{\thesection}{1em}{}[{\color{Black}\titlerule[0.8pt]}]



\renewcommand{\subsection}{%
	\@startsection
	{subsection}{2}{0pt}{-4ex}%
	{1ex plus .2ex}{\normalsize\color{\stylecolor}}%
}

\renewcommand{\thesubsection}{\roman{subsection}}


\let\tableofcontentsORIG\tableofcontents
\ifx\IsTwoCols\undefined
	\renewcommand{\tableofcontents}{
		\begin{multicols*}{2}
			\small{\tableofcontentsORIG}
		\end{multicols*}
	}
\fi



\newcommand{\boxdefinition}[2]{
	\begin{center}
		\begin{tcolorbox}[colframe=\stylecolor, colback=black!3, arc=2mm, outer arc=0.5mm, width=\linewidth, left=2mm, right=2mm]
			\textbf{#1:} \emph{\small#2}	
		\end{tcolorbox}
	\end{center}\noindent\hspace{-1.5ex}
}

\setlength{\marginparwidth}{1.9cm}
\newcommand{\sidenote}[1]{
	\marginpar{\raggedright\scriptsize\textcolor{Bittersweet}{#1}}
}


\def \*#1{\boldsymbol{#1}}
\renewcommand{\t}[1]{\text{\normalfont{#1}}}

