__kernel void scalar_axpy(
    __global int *A, const int scalar, const int alpha,
    const int Mdim, const int Pdim, const int MdimPad) {
    
    // Get the index of the elements to be processed
    const int globalRow = get_global_id(0); // C Row ID
    const int globalCol = get_global_id(1); // C Col ID
    
    // Do the operation
    if((globalRow <= Mdim) && (globalCol <= Pdim)){
        
        A[globalRow * MdimPad + globalCol] = alpha * A[globalRow * MdimPad + globalCol] + scalar;
    }
}