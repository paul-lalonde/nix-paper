% The figures are produced from a small number of primitives:
%	- cores : a small disk (its center in figures is the origin
%		(0,0)); 4 flavours:
%		- gcore: general purpose indistinct: grey;
%		- kcore ALU (possibly without even integer multiple/divide;
%			think RISC-V RV{32,64}I); green; kernel core;
%		- vcore say vectorial: red;
%		- score specialized: blue;
%		(red+green+blue just to cover everything...);
%	- a full user proc: a cyan disk centered at the core;
%	- a full kernel proc: an orange disk centered at the core;
%	- a half user proc: a cyan semi-disk with an indentation for a
%		core, unfilled;
%	- a half kernel proc: as user proc but filled in orange;
%
% The costly switch of processing between kernel and userland will be
% symbolized by two curved arrows on the side between the two halves.
%	- sarrow (switch arrow);
%
% The switch of processes (scheduling) will be symbolized by a 
% surrounding chronometer, with just a sector (between start of time
% to a few units) with normal color, the complementary being faded.
%

%
% The 0 (origin) is the center of the (whatever)core.
%

% We want the *.[0-9]+ figures to be standalone PostScript.
prologues:=1;
truecorners:=1; % exact bbox
%bboxmargin:=0;
%defaultdx:=0;
%defaultdy:=0;
%labeloffset:=0;

% For the moment, not using anything special for the text in TeX. If
% it was LaTeX or other, dedicated limbo TeX instructions will go
% there.
verbatimtex
magstep=1
etex

% In order to use one definition to define the standard size of the
% elements, we will use the definition of the core diameter as unit.
%
u:=0.4cm;

% Defining various pen with differing form and width.
%
color kcolor, ucolor;
pen fine, med, bold;
fine:=pensquare scaled 0.6pt;
med:=pensquare scaled 0.9pt;
bold:=pensquare scaled 1.2pt;

% The primitives.
%
path core, hproc;
picture gcore, kcore, vcore, score;
picture fkern, fuser, hkern, huser;
picture sarrow;

% The results.
%
picture TC, KC, ACV, ACS, XC;

% These unnamed group is the definition of the primitives. The
% beginfig blocks following do define the actual figures that will be
% produced.
%

% Defining the cores primitives.
%
begingroup;
	core:=fullcircle scaled u;

	gcore:=nullpicture;
	addto gcore contour core withcolor .5white;
	addto gcore doublepath core withpen bold;

	kcore:=nullpicture;
	addto kcore contour core withcolor green;
	addto kcore doublepath core withpen bold;

	vcore:=nullpicture;
	addto vcore contour core withcolor red;
	addto vcore doublepath core withpen bold;

	score:=nullpicture;
	addto score contour core withcolor blue;
	addto score doublepath core withpen bold;
endgroup;

% We start by the full processes. The full process is a disk centered
% at the core, with unfilling the full disk to let 1/5u (u is the
% dimension of the core diameter) between the full process and the
% core drawing.
%
begingroup;
	path p, q;

	kcolor:=(1.0, 0.65, 0.0);
	ucolor:=(0.0, 1.0, 1.0);
	p:=fullcircle scaled 4u;
	q:=fullcircle scaled 1.2u;

	fuser:=nullpicture;
	addto fuser contour p withcolor ucolor;
	addto fuser contour q withcolor background;
	addto fuser doublepath p withpen med; 
	addto fuser doublepath q withpen med; 

	fkern:=nullpicture;
	addto fkern contour p withcolor kcolor;
	addto fkern contour q withcolor background;
	addto fkern doublepath p withpen med;
	addto fkern doublepath q withpen med;
endgroup;

% The half proc is semi-disk inserted with the indentation for the
% core. The same path will be used mirrored for the kernel half proc.
% 
begingroup;
	hproc:=(-2u * cosd(9),0.1u)..(0, 2u)..(2u * cosd(9), 0.1u)--
		(.6u * cosd(9), 0.1u) ..(0, .6u)..(-.6u * cosd(9), 0.1u)
		--cycle;
	huser:=nullpicture;
	addto huser contour hproc withcolor ucolor;
	addto huser doublepath hproc withpen med;

	hkern:=nullpicture;
	addto hkern contour hproc rotated 180 withcolor kcolor;
	addto hkern doublepath hproc rotated 180 withpen med;
endgroup;

%
% Drawing our arrows. There will be on a support circle of 4.5u
% and going on a 1/4 th of a quadrant. the origin (0, 0) is at the
% center of the support circle (so it has simply to be rotated to
% fit in the figures and the vanilla path is the left arrow.
% The head is a simple filled triangle, centered on its base at
% (0,0), up.
%
begingroup;
	picture head;
	path p;
	p:=(-2.2u * cosd(90/4), 2.2u * sind(90/4))
		..(-2.2u, 0)
		..(-2.2u * cosd(90/4), -2.2u * sind(90/4));
	head:=nullpicture;
	addto head contour (-0.1u,0)--(0,0.3u)--(0.1u,0)--cycle
		withcolor black;
	sarrow:=nullpicture;
	addto sarrow doublepath p withpen fine;
	addto sarrow also head rotated (180 + 90/4)
		shifted (-2.2u * cosd(90/4), -2.2u * sind(90/4));
endgroup;

%
% Traditional scheme.
%
begingroup;
	path p;
	picture l; % label
	TC:=nullpicture;
	p:=fullcircle scaled (5u);
	addto TC doublepath p withpen bold;
	for i=0 upto 59:
		addto TC doublepath (0, 0)
			--(2.5*cosd(6*i)*u, 2.5*sind(6*i)*u)
			withpen fine;
	endfor;
	% Cut them shorter.
	% Erasing the majority of the "seconds" sectors drawn
	p:=fullcircle scaled (4.7u);
	addto TC contour p withpen fine withcolor background;

	% Stronger and longer marks for every 5 sec.
	for i=0 upto 11:
		addto TC doublepath (0, 0)
			--(2.5*cosd(30*i)*u, 2.5*sind(30*i)*u)
			withpen bold;
	endfor;
	% Erasing the majority of the "5 seconds" sectors drawn
	p:=fullcircle scaled (4.5u);
	addto TC contour p withpen fine withcolor background;

	% Adding a handle.
	p:=(-0.25u,0)--(0.25u,0)--(0.25u,0.3u)--(-0.25u,0.3u)--cycle;
	addto TC doublepath p shifted (0,2.5u) withpen bold;
	addto TC contour p scaled 0.6 shifted (0,2.8u) withpen bold
		withcolor black;
	p:=fullcircle scaled (1u);
	addto TC doublepath p shifted (0,3.39u) withpen bold;
	addto TC doublepath p scaled 1.1 shifted (0,3.39u) withpen med;
	% The general core.
	addto TC also gcore;
	% The greyed half procs. (grey: 0.21R + 0.72G + 0.07B)
	addto TC contour hproc withcolor (0.68, 0.68, 0.68);
	addto TC doublepath hproc withpen med;
	addto TC contour hproc rotated 180 withcolor (0.79, 0.79, 0.79);
	addto TC doublepath hproc rotated 180 withpen med;
	addto TC also sarrow;
	addto TC also sarrow rotated 180;
	% Unfilling running half user.
	p:=(0,0.6u)--(0,2u)
		..(2*cosd(75)*u,2*sind(75)*u)
		..(2*cosd(60)*u,2*sind(60)*u)
		--(0.6*cosd(60)*u,0.6*sind(60)*u)
		..(0.6*cosd(75)*u,0.6*sind(70)*u)
		..cycle;
	addto TC contour p withcolor ucolor;
	addto TC doublepath p withpen med;
	% The clock hands.
	addto TC doublepath (0,0)--(0,2.1u) withcolor red withpen med;
	addto TC doublepath (0,0)--(2.1*cosd(60)*u,2.1*sind(60)*u)
		withcolor red withpen med;
	p:=(-0.1u,-0.1u)--(0.1u,-0.1u)--(0,0.3u)--cycle;
	addto TC contour p rotated -30
		shifted (2*cosd(60)*u,2*sind(60)*u)
		withcolor red;
	% Help reading by label.
	l:= thelabel.top(btex $U$ etex, (0,0));
	addto TC contour bbox l shifted (-1u, 0.5u) withcolor background;
	addto TC also l shifted (-1u, 0.5u);
	l:= thelabel.top(btex $K$ etex, (0,0));
	addto TC contour bbox l shifted (0, -1.5u) withcolor background;
	addto TC also l shifted (0, -1.5u);

	l:=thelabel.top(btex {\bf TC} etex, (0,0));
	addto TC also l shifted (0, -4u);
	
	% Displaying dimensions
	%show "TC"; show llcorner TC; show urcorner TC;
	
endgroup;

%
% KC
%
begingroup;
	picture l;
	KC:=nullpicture;
	addto KC also fkern;
	addto KC also kcore;

	l:=thelabel.top(btex {\bf KC} etex, (0,0));
	addto KC also l shifted (0, -4u);

	% Displaying dimensions
	show "KC"; show llcorner TC; show urcorner TC;
endgroup;

%
% ACV
%
begingroup;
	picture l;

	ACV:=nullpicture;
	addto ACV also fuser;
	addto ACV also vcore;

	l:=thelabel.top(btex {\bf ACV} etex, (0,0));
	addto ACV also l shifted (0, -4u);

	show "ACV"; show llcorner TC; show urcorner TC;
endgroup;

%
% ACS
%
begingroup;
	picture l;
	ACS:=nullpicture;
	addto ACS also fuser;
	addto ACS also score;

	l:=thelabel.top(btex {\bf ACS} etex, (0,0));
	addto ACS also l shifted (0, -4u);

	show "ACS"; show llcorner TC; show urcorner TC;
endgroup;

%
% XC
%
begingroup;
	picture l;

	XC:=nullpicture;
	addto XC also huser;
	addto XC also hkern;
	addto XC also gcore;
	addto XC also sarrow;
	addto XC also sarrow rotated 180;

	l:=thelabel.top(btex {\bf XC} etex, (0,0));
	addto XC also l shifted (0, -4u);

	show "XC"; show llcorner TC; show urcorner TC;
endgroup;

%
% The like "original" illustration
%
beginfig(1);
endfig;

beginfig(1);
	picture l, p, q;
	numeric left, hic, lxnix;

	p:=nullpicture;
	addto p also TC;
	z1=llcorner(TC); % lower corner of the whole picture
	z2=urcorner(TC); % top of TC, higher picture

	draw TC shifted (-x1, -y1);
	label.top(btex {\bf Traditional scheme} etex, (-x1,y2 - y1));
	
	% A simple straight arrow to the Nix evolution.
	drawarrow (x2 - x1 + 1u, -y1)--(x2 - x1 + 4u, -y1) withpen bold;

	% Save coordinates of right currentpicture.
	z3=urcorner(currentpicture);
	left = x3 + 1u;
	hic = left;

	z4=llcorner(KC);
	draw KC shifted (hic - x4, -y1);

	z5=urcorner(currentpicture);
	hic:=x5;
	z6=llcorner(ACV);
	draw ACV shifted (hic - x6 + 1u, -y1);

	z7=urcorner(currentpicture);
	hic:=x7;
	z8=llcorner(ACS);
	draw ACS shifted (hic - x8 + 1u, -y1);
	% We will put the text on the center core if not the
	% center picture.
	lxnix = hic - x8 + 1u;

	z9=urcorner(currentpicture);
	hic:=x9;
	z10=llcorner(XC);
	draw XC shifted (hic - x10 + 1u, -y1);

	z11=urcorner(currentpicture);
	hic:=x11;
	z12=llcorner(TC);
	draw TC shifted (hic - x12 + 1u, -y1);

	% Put a center "NIX" above the various NIX cores
	z13=urcorner(currentpicture);
	label.top(btex {\bf NIX Scheme} etex,
		(lxnix, y2 - y1));

	% Draw a bounding box with a small margin
	%draw (-10, -10)--(x13+10, -10)--(x13+10,y13+10)--(-10,y13+10)
	%	--cycle;
endfig;

end
