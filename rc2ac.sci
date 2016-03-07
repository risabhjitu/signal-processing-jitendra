function R=rc2ac(k, R0)

//rlevinson function convert reflection coefficients to autocorrelation sequence.
// Calling Sequence
// a = rc2ac(k, R0)

// Parameters
// k: input argument reflection coefficients.
// R0: input argument zero lag autocorrelation
// R: return  autocorrelation sequence.

// Examples
//X = [7 6 5 8 3 6]
// R = rc2ac(X, 0.3)

// See also
//
// Author
// Jitendra Singh
//             
          
 // load rc2poly and rlevinson before running this function         
     
 if (size(k,1) > 1) & (size(k,2) > 1)
    error ('The reflection coefficients must be stored in a vector.')
end
     
    
     if argn(2)<2 then // checking of number of input arguments, if argn(2)<2 execute error.
              error ('Not enough input argument, define zero lag autocorrelation, R0.')
    end 
  
    [a, efinal]=rc2poly (k, R0);
    R=rlevinson(a, efinal)    
          
          
endfunction
