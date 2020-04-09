Flatiron Institute Fast Multipole Libraries 

This codebase is a set of libraries to compute N-body interactions
governed by the Laplace and Helmholtz equations, to a specified
precision, in three dimensions, on a multi-core shared-memory machine.

Please see the [online documentation](https://fmm3d.readthedocs.io),
or its equivalent [user manual](fmm3d_manual.pdf).

 //////////////////////

Following changes have been applied by 'jmark'.

 - Adding 'Plummer' smoothing parameter to all 'Laplace' routines (without vectorization).
 - Adding additional parameter 'plummer\_input' to subroutine signatures in the 'lfmm3dwrap' module.
