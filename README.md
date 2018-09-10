# dependency-redundancy
Code for the example of the WRR paper:

Dependency and redundancy: how information theory untangles three variable interactions in environmental data
By Steven V, Weijs, Akhil Kumar, and Hossein Foroozand
Submitted to Water Resources Research, 2018

This file is provided to further explore the example, which is a difficult
test case for partial information decomposition approaches.
The idea of this example is that it provides a case where there is
dependence between sources, but only over a range where the sources do not
jointly inform the target variable T.
Conversely, over the range where T is a sum of both sources, the sources
are independent. 
This is to highlight that dependency of variables is not a guarantee for 
redundant influencing of a target, and to aid in developing methods of 
estimating redundancy that can handle this behaviour.
For more information, please contact the corresponding author of the
article mentioned above.

 To install:
add functions to the path that were downloaded from the "TIPNet" GIT repository
This can be downloaded from the repository:
 https://github.com/HydroComplexity/TIPNet 
the master folder should be added as a subfolder to the path of this script
the functions used are in v2, which is here added to the path:
TIPNet-master\TIPNet_v2\Functions\


Note1: , this code is relating to the paper:
Goodwell, A. E., & Kumar, P. (2017a). 
Temporal information partitioning: Characterizing synergy, uniqueness, and redundancy in interacting environmental variables. 
Water Resources Research, 53(7), 5920–5942. doi:10.1002/2016WR020216
Note2: the only functions used from the TIPNets toolbox by Goodwell and Kumar are : 
These can be found under the follwing direct links:

https://github.com/HydroComplexity/TIPNet/blob/master/TIPNet_v2/Functions/compute_pdf_fixedbins.m

https://github.com/HydroComplexity/TIPNet/blob/master/TIPNet_v2/Functions/compute_info_measures.m
