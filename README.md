# Self-Adaptive Mesh Generator for Global Complex Roots and Poles Finding Algorithm

##### Programming language: MATLAB

[![Version](https://img.shields.io/badge/version-1.0-green.svg)](README.md) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

---
## Program goals
The SA-GRPF algorithm aims to **find all the zeros and poles of the function in the fixed region**. This program includes a method for creating a **self-adaptive initial mesh** for the **[regular GRPF algorithm](https://ieeexplore.ieee.org/document/8457320)**. The proposed solution uses **gradient calculation** to identify areas requiring mesh refinement, including areas where a zero and a pole are close. An overall class of functions can be analyzed, and any arbitrarily shaped search region can be considered. As demonstrated in the attached examples, the adaptive mesh allows for faster and more accurate analysis of functions with a much smaller number of samples. The algorithm is not limited to computational electrodynamics. It can be used for similar problems, e.g., acoustics, control theory, and quantum mechanics.

## Solution method
The function should be defined in the [fun.m](0_rational_function/fun.m) at the beginning of the process. Also, the user sets the analyzed domain and defines the accuracy with which the results ([analysis_parameters.m](0_rational_function/analysis_parameters.m)). The next step gives the number of nodes that will be used to create the **initial adaptive mesh**. After that, the function values at the new mesh nodes are calculated, and Delaunay triangulation is performed. For each new triangle, the **gradient of the phase is determined**. Based on the analysis of this condition, the candidate edges that will be halved to densify the adaptive mesh are selected. The mesh is analyzed for skinny triangles, and the most extended edges in a given element are split in half. In the final step, the discretized Cauchy's argument principle is applied. However, **it does not require the function's derivative and integration over the contour**. In the final process, **regular GRPF [(use code)](https://github.com/PioKow/GRPF)** can be applied (inside the previously determined candidate regions) to improve the accuracy of the results.

## Scientific work
If the code is used in a scientific work, then **reference should be made to the following publication**:
1. S. Dziedziewicz, M. Warecka, R. Lech and P. Kowalczyk, "**Self-Adaptive Mesh Generator for Global Complex Roots and Poles Finding Algorithm**," in _IEEE Transactions on Microwave Theory and Techniques_, doi: 10.1109/TMTT.2023.3238014. [link](https://ieeexplore.ieee.org/document/10025853)

---
## Manual
1. **[SA_GRPF.m](SA_GRPF.m) - starts the program**
2. [analysis_parameters.m](0_rational_function/analysis_parameters.m) - contains all parameters of the analysis, e.g.:
    * the rectangle domain size (**xb,xe,yb,ye**)
    * accuracy (**Tol**)
	* approach: two aviable adaptive and regular GRPF - (**Mode**)
	* optional fun parameters (**Optional**)
	* buffer (**ItMax**, **NodesMin**, **NodesMax**)
3. [fun.m](0_rational_function/fun.m) - definition of the function for which roots and poles will be calculated
4. **to run examples**: add folder **uncomment line 23 or 24 in the [SA_GRPF.m](SA_GRPF.m) (addpath)** in order to include the folder with (analysis_parameters.m) and (fun.m) files or copy them from the folder containing the example to the main folder and start SAGRPF program.
 
## Short description of the functions
- [SA_GRPF.m](SA_GRPF.m) - main body of the algorithm  
	- [analysis_parameters.m](0_rational_function/analysis_parameters.m) - analysis parameters definition
	- [fun.m](0_rational_function/fun.m) - function definition
	- [rect_dom.m](rect_dom.m) - initial mesh generator for rectangular domain
	- [vinq.m](vinq.m) - converts the function value into proper quadrant
	- [adaptive.m](adaptive.m) - main body of the self-adaptive mesh generator
		- [phase_validation.m](phase_validation.m) - checking the extrema of a function
		- [get_edges_attach_toVertix.m](get_edges_attach_toVertix.m)
		- [calc_gradient.m](calc_gradient.m) - calculation of phase gradients in elements
			- [dPhase.m](dPhase.m)
		- [analyse_gradients.m](analyse_gradients.m) - checking angle between the phase gradients for two adjacent triangles(including length of the edges)
	- [regular.m](regular.m) - regular GRPF appraoch base on [https://github.com/PioKow/GRPF](https://github.com/PioKow/GRPF)
	- [find_skiny_elements.m](find_skiny_elements.m) - verifying the stability of the mesh
	- [analyse_regions.m](analyse_regions.m) - applying the discretized CAP in order to final verification of the results
		- [find_next_node.m](find_next_node.m) - finds the next node in the candidate boundary creation process
	- [vis.m](vis.m) - mesh visualization

## Additional comments
The code involves MATLAB function [delaunayTriangulation](https://mathworks.com/help/matlab/ref/delaunaytriangulation.html) which was introduced in R2013a version. In the older versions some modifications are required and the function can be replaced by [DelaunayTri](https://mathworks.com/help/matlab/ref/delaunaytri.html), however this solution is not recommended.

## Authors
The project has been developed in **Gdansk University of Technology**, Faculty of Electronics, Telecommunications and Informatics by **Sebastian Dziedziewicz, Piotr Kowalczyk, Rafał Lech, Małgorzata Warecka** ([Department of Microwave and Antenna Engineering](https://eti.pg.edu.pl/en/kima-en)). 

Corresponding e-mail: sebastian.dziedziewicz@pg.edu.pl

## License
GRPF is an open-source Matlab code licensed under the [MIT license](LICENSE).
