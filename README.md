One-Dimensional-SN
==================

*Use one dimensional SN algorithm to calculation distribution of neutrons*

By using **Discrete Ordinates Method** (SN method), these programs calculates the neutron angular flux and fluence rate in the simplest one dimensional homogeneous isotropic bare reactors (finite plane reactor & finite sphere reactor).

These programs are written in MATLAB language and requires MATLAB 7.0 or later versions. All reports are written with XeLaTeX which is a version of LaTeX/TeX and the *xxxx.tex* files are encoded in UTF-8.

As a Chinese undergraduate, I wrote all comments and reports in Simplified Chinese. Please contact me if you need the English version.



本程序采用**离散纵标法**（SN方法）计算均匀分布、各向同性的一维裸堆（有限平板堆、有限球堆）的中子角通量、中子注量率分布。

所有的计算程序采用MATLAB语言编写，需要MATLAB 7.0之后的版本编译运行。所有的报告采用XeLaTeX编写，*xxxx.tex*文件使用UTF-8编码和保存。


---

**文件清单 / File List:** 

+ 1D_plane 	一维平板堆 / one dimensional plane reactor

	1. `one_dimensional_plane.m`  ----  	计算主程序 / main calculation program
	1. `getGaussianQuadTuple.m` ---- 		获取高斯求积组 / get Gaussian quadrature tuple (mu, weight)
	1. `1D_plane_report.pdf` ----	计算报告(pdf) / assignment report (pdf)
	1. `1D_plane_report.tex` ----	计算报告(tex) / assignment report (tex)
	1. `1D_plane_neutron_flux.eps` ---- 报告插图 / illustrations of the report

+ 1D_sphere 	一维球堆 / one dimensional sphere reactor
	
	1. `one_dimensional_sphere.m`  ---- 计算主程序 / main calculation program
	2. `getGaussianQuadTuple.m`  ----	获取高斯求积组 / get Gaussian quadrature tuple (mu, weight)
	3. `1D_sphere_report.pdf` ---- 计算报告(pdf) / assignment report (pdf)
	4. `1D_sphere_report.tex`  ----	计算报告(tex) / assignment report (tex)
	5. `1D_sphere_neutron_flux.eps` ---- 	报告插图 / illustrations of the report


