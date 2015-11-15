function [s, lowercrossvalue, uppercrossvalue, lowerreference, upperreference]=slewrate(x, varargin)
    
    
    // This function estimate slew rate of bilevel waveform transitions
    // Calling Sequence
    // s=slewrate(x)
    // s=slewrate(x, t)
    // s=slewrate(x, t, 'PercentReferenceLevels', N )
    // s=slewrate(x, t, 'Tolerance', M)
    // s=slewrate(x, t,'StateLevels', O)
    
    // [s lowercrossvalue uppercrossvalue lowerreference upperreference]=slewrate(x)
    // [s lowercrossvalue uppercrossvalue lowerreference upperreference]=slewrate(x, t)
    // [s lowercrossvalue uppercrossvalue lowerreference upperreference]=slewrate(x, t, 'PercentReferenceLevels', N )
    // [s lowercrossvalue uppercrossvalue lowerreference upperreference]= slewrate(x, t, 'Tolerance', M)
    // [s lowercrossvalue uppercrossvalue lowerreference upperreference]= slewrate(x, t,'StateLevels', O)
    // 
    //  
    // Parameters
    // x: real vector.
    // t: defiene instant sample time t as vector with same length of x, or specifies the sample rate, t, as a positive scalar.
    // PercentReferenceLevels: specify the mid percent reference leves as a percentage, default value of N is [10 90].
    // Tolerance: define the tolerance value as real scaler value, where default value of M is 2.0.
    // StateLevels:  define the lower and upper state levels as two element real vector. 
    // s: returns a vector of the ratios of the level difference to the time duration between the points where each transition crosses the 10% and 90% reference levels.
    // lowercrossvalue: return the lowerc cross value of bilevel waveform transitions X
    // uppercrossvalue: return the upper cross value of bilevel waveform transitions X
    // lowerreference: return lower reference value corrosponding to lower percent reference value.
    // upperreference: return upper reference value corrosponding to upper percent reference value.
    
    // Examples
    // x=[1.2, 5, 10, -20, 12]
    //t=1:length(x)
    //s=slewrate(x, t) 
    // See also
    // Authors
    // Jitendra Singh
  
      
  // run statelevels and midcross function before running risetime function.  

    
    
    
    
    
    if  length(varargin)==0 then
        [levels hist]=statelevels(x);
        Lvarargin=list(1:length(x), 'StateLevels', levels(1), 'MidPercentReferenceLevel', 10, 'Tolerance', 2)
        Uvarargin=list(1:length(x), 'StateLevels', levels(2), 'MidPercentReferenceLevel', 90, 'Tolerance', 2)
    end
    
    
  sindex=[];
if length(varargin)>=1 then
a=1;

for i=1:length(varargin)   
    if type(varargin(i))==10 then
        sindex(a)=i;
        a=a+1;
        end      
end
end  

if length(sindex)>3 then
    error('Unexpected argument.')
end



if (~isempty(sindex)) then
        for j=1:length(sindex)
            select varargin(sindex(j))
                case {'StateLevels'}                                 
                case {'PercentReferenceLevels'}          
               case {'Tolerance'}           
            else      
              error(strcat(['Invalid optional argument'," ", varargin(sindex(j))]));
            end // switch
        end // for
    end // if

   
    
    if (~isempty(varargin))  then
        
        for i=1:length(varargin)
            
             select varargin(i)
                 
            case {'PercentReferenceLevels'}
                
                if length(varargin) <=i then
                      error(strcat(['parameter PercentReferenceLevels required a value']));
                      
                  elseif type(varargin(i+1))==10 then
                      
                    error('Expected PercentReferenceLevels to be one of these types: double, Instead its type was char.')
                    
                elseif length(varargin(i+1))~=2 then
                    error ('Expected PercentReferenceLevels to be of size 1x2');                   
                else
                       perval=varargin(i+1);
                
                       if perval(2)<=perval(1) then
                     error('The PercentReferenceLevels must be in increasing order.')
                     end
                  
                       varargin(i)='MidPercentReferenceLevel';
                     varargin(i+1)=perval(1);
                    Lvarargin= varargin;
                    
                    varargin(i+1)=perval(2);
                    Uvarargin=varargin;
               
                end
            else

                end           
            
            end
    end
    
 
 index=[];
if length(varargin)>=1 then
a=1;
for i=1:length(varargin)
     
  index(a)=find(varargin(i)=='MidPercentReferenceLevel')  
    a=a+1;
end
end  


if  sum(index)==0 then
    
     varargin(length(varargin)+1)='MidPercentReferenceLevel';
           varargin(length(varargin)+1)=10;
                    Lvarargin= varargin;
                    
                    varargin(length(varargin))=90;
                    Uvarargin=varargin;
    
    
end
   

    
   [lcrossval lref levels t tolerance]= midcross(x, Lvarargin(:)); 
   
    [ucrossval uref]=midcross(x, Uvarargin(:));
    
    
    if length(lcrossval)==length(ucrossval) then 
        ss=ucrossval-lcrossval
        
    elseif length(lcrossval)>length(ucrossval)
        n=length(ucrossval);
       ss=ucrossval-lcrossval(1:n);
       
    else
        n=length(lcrossval);
        ss=ucrossval(1:n)-lcrossval;
      
    
 end
 

 s=(uref-lref)./ss;
 
    
 uppercrossvalue=ucrossval;
 lowercrossvalue=lcrossval; 
 
 lowerreference=lref;
 upperreference=uref; 
  
     upperbound= levels(2)- (tolerance/100)*(levels(2)-levels(1));
 mostupperbound=levels(2)+ (tolerance/100)*(levels(2)-levels(1));
  lowerbound= levels(1)+ (tolerance/100)*(levels(2)-levels(1));
  mostlowerbound=levels(1)- (tolerance/100)*(levels(2)-levels(1));    
    
    
 
    
    
   if argn(1) == 1 then   // if the defined output is only 1, the it will provide the graphical representation of                          //levels
       
      if length(s)==0 then
         
        plot(t,x, 'LineWidth',1, 'color', 'black')
      
         plot(t,upperreference * ones(1, length(t)),'-r', 'LineWidth',0.5)
   
       plot(t,lowerreference * ones(1, length(t)),'-g', 'LineWidth',0.5)
        
   
      plot(t,mostupperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
      plot(t,levels(2) * ones(1, length(t)),'--k', 'LineWidth',0.5) 
      
      plot(t,upperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
    
       
       plot(t,lowerbound *ones(1, length(t)),'--g', 'LineWidth',0.5)
       
       plot(t,levels(1) * ones(1, length(t)),'--k', 'LineWidth',0.5)
       
       plot(t,mostlowerbound * ones(1, length(t)),'--g', 'LineWidth',0.5) 
       
       xlabel("Time (second)", "fontsize",3, "color", "black" )
     ylabel("Level (Volts)", "fontsize",3, "color", "black" )  
       

     legends(["Signal";   "upper boundary"; "upper state"; "lower boundary"; "upper reference"; "lower reference"; "upper boundary"; "lower state"; "lower boundary"],  [[1;1], [5;2], [1;2], [5;2], [5;1], [3;1], [3;2], [1;2], [3;2]], opt='?')  
         

      else 

        
      plot(t,x, 'LineWidth',1, 'color', 'black')
      
       plot(t,upperreference * ones(1, length(t)),'-r', 'LineWidth',0.5)
  
      plot(t,lowerreference * ones(1, length(t)),'-g', 'LineWidth',0.5)
         
    rects=[lowercrossvalue; upperreference*ones(lowercrossvalue); ss; (upperreference-lowerreference)*ones(s)]
 
   col=-10*ones(s);
    
    xrects(rects, col);
    
     plot(uppercrossvalue, upperreference*ones(uppercrossvalue), "r*", 'MarkerSize',15);
     
      plot(lowercrossvalue, lowerreference*ones(lowercrossvalue), "g*", 'MarkerSize',15);
      
      plot(t,mostupperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
      plot(t,levels(2) * ones(1, length(t)),'--k', 'LineWidth',0.5) 
      
      plot(t,upperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
    
       
       plot(t,lowerbound *ones(1, length(t)),'--g', 'LineWidth',0.5)
       
       plot(t,levels(1) * ones(1, length(t)),'--k', 'LineWidth',0.5)
       
       plot(t,mostlowerbound * ones(1, length(t)),'--g', 'LineWidth',0.5) 
//       
       xlabel("Time (second)", "fontsize",3, "color", "black" )
     ylabel("Level (Volts)", "fontsize",3, "color", "black" )  
       

     legends(["slewrate"; "Signal"; "upper cross"; "lower cross"; "upper boundary"; "upper state"; "lower boundary"; "upper reference"; "lower reference"; "upper boundary"; "lower state"; "lower boundary"],  [[-11; 2] , [1;1], [-10;5], [-10;3], [5;2], [1;2], [5;2], [5;1], [3;1], [3;2],[1;2], [3;2]], opt='?')

   end    
   end  
    

endfunction
