function [d, initialcross, finalcross, nextcross, midreference]= dutycycle(x, varargin)
    
      
    // This function estimate duty cycle of bilevel waveform pulses.
    // Calling Sequence
    // d=dutycycle(x)
    // d=dutycycle(x, t)
    // d= dutycycle(tau, prf)
    // d=dutycycle (x, t, 'Polarity', pol)
    // d=dutycycle(x, t, 'MidPercentReferenceLevel', N )
    // d=dutycycle(x, t, 'Tolerance', M)
    // d=dutycycle(x, t,'StateLevels', O)
    
    // [d initialcross finalcross nextcross midreference]=dutycycle(x)
    // [d initialcross finalcross nextcross midreference]=dutycycle(x, t)
    // [d initialcross finalcross nextcross midreference]=dutycycle(x, t, 'Polarity', pol)
    // [d initialcross finalcross nextcross midreference]=dutycycle(x, t, 'MidPercentReferenceLevel', N )
    // [d initialcross finalcross nextcross midreference]= dutycycle(x, t, 'Tolerance', M)
    // [d initialcross finalcross nextcross midreference]= dutycycle(x, t,'StateLevels', O)
    // 
    //  
    // Parameters
    // x: real vector.
    // t: defiene instant sample time t as vector with same length of x, or specifies the sample rate, t, as a positive scalar.
    // tau: define real scalar input pulse width TAU (in seconds).
    // prf: pulse repetition frequency PRF (in Hz). The product of TAU and PRF must be less than or equal to 1.
    // Polarity: specify the polarity of the pulse as either 'positive' or 'negative', where the default value is 'positive'.
    // MidPercentReferenceLevel: specify the mid percent reference leves as a percentage, default value of N is 50.
    // Tolerance: define the tolerance value as real scaler value, where default value of M is 2.0.
    // StateLevels:  define the lower and upper state levels as two element real vector. 
    // d: returns the ratio of the pulse width to the pulse period for each positive-polarity pulse
    // initialcross: returns a vector of initial cross values of bilevel waveform transitions X
    // finalcross: returns a vector of final cross values of bilevel waveform transitions X
    // nextcross: returns a vector of next cross values of bilevel waveform transitions X
    // midreference: return mid reference value corrosponding to mid percenr reference value.
    
    // Examples
    // x=[1.2, 5, 10, -20, 12]
    //t=1:length(x)
    //d=dutycycle(x, t) 
    // See also
    // Authors
    // Jitendra Singh
  
      
  // run statelevels and midcross function before running risetime function.  

    
    
    
    
    
    
   
   if sum(length(x))==1 & length(varargin)==0 then
       error('You need exactly two inputs specified when TAU is a scalar.')
   elseif sum(length(x))==1 & type(varargin(1))==1 then
     
       
     if length(argn(1))>1 then
         error('Too many outputs specified when TAU is a scalar.');
        end
      
       dd=x*varargin(1);
       
   if   or(dd>1) then
            
       error('The product of TAU and PRF should be less than or equal to 1.')
       else
       d=x*varargin(1);
   end
   
   else
       
    
    if  length(varargin)==0 then
   varargin=varargin;
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


pol='Positive';
polidx=[];

if (~isempty(sindex)) then
        for j=1:length(sindex)
            select varargin(sindex(j))
                case {'StateLevels'}                                 
                case {'MidPercentReferenceLevel'}          
               case {'Tolerance'} 
                   
               case{'Polarity'}

                   if length(varargin)<j+1 then
                       error ('Parameter polarity requires a value.')
                   
                   
                   elseif type( varargin(sindex(j)+1))==1 then
                       error ('POLARITY must be either ''Positive'' or ''Negative''.')
                       
                     elseif  varargin(sindex(j)+1)== 'StateLevels' | varargin(sindex(j)+1)== 'MidPercentReferenceLevel' | varargin(sindex(j)+1)== 'Tolerance' then
                         
                         error ('Parameter polarity requires a value.')
                         
                   
                    elseif  varargin(sindex(j)+1)~= 'Positive' & varargin(sindex(j)+1)~= 'Negative' then
                      
                       error ('POLARITY must be either ''Positive'' or ''Negative''.');
                       
                   else 
                       //varargin (sindex(j))=null(); 
                       polidx=sindex(j);                    
                   end 
                
                
               case {'Positive'}
                   
                   if j==1 then
                       error(strcat(['Unexpected option:', " ", varargin(sindex(j))]));
                   elseif varargin(sindex(j)-1)~= 'Polarity'
                       error(strcat(['Unexpected option:', " ", varargin(sindex(j))]));
                   else
                        polinputidx= sindex(j);
                       
                        pol=varargin (sindex(j)) ;                        
                       end
                       
                       case {'Negative'}
                   
                   if j==1 then
                       error(strcat(['Unexpected option:', " ", varargin(sindex(j))]));
                   elseif varargin(sindex(j)-1)~= 'Polarity'
                       error(strcat(['Unexpected option:', " ", varargin(sindex(j))]));
                   else
                        polinputidx= sindex(j);
                        
                         pol=varargin (sindex(j)) ;                          
                       end    
                                           
            else      
              error(strcat(['Invalid optional argument'," ", varargin(sindex(j))]));
            end // switch
        end // for
    end // if
// 
// disp(varargin)   

if length(polidx)>0 then
    varargin (polidx)=null(); 
     varargin(polinputidx-1)=null();
end


   [crossval midref levels t tolerance Tinput]= midcross(x, varargin(:)); 
   
    
     upperbound= levels(2)- (tolerance/100)*(levels(2)-levels(1));
 mostupperbound=levels(2)+ (tolerance/100)*(levels(2)-levels(1));
  lowerbound= levels(1)+ (tolerance/100)*(levels(2)-levels(1));
  mostlowerbound=levels(1)- (tolerance/100)*(levels(2)-levels(1));  
  
  if length(Tinput)==length(x) then
      crossvalue=crossval;
  else 
      crossvalue=1+(crossval*Tinput);
  end
  
  

  maxx=[];
  minn=[]; 
 
 if length(crossval)>= 2 then
     
     for i =1:(length(crossval)-1)
        
          maxx(i)= max(x(ceil(crossvalue(i)):floor(crossvalue(i+1))))
          
         minn(i)= min(x(ceil(crossvalue(i)):floor(crossvalue(i+1))))
         end   
     end


pos_idx=[];
neg_idx=[];

    
    if  length(maxx)>=1  then
        pos= 100*((maxx-levels(2))/(levels(2)-levels(1)));
        pos_idx=find(pos>0)
        
    end
  
  if length(minn)>=1 then
       neg= 100*((minn-levels(1))/(levels(2)-levels(1)));
       neg_idx=find(neg<0)
  end
  

  int_pos=[];
 final_pos=[];
  int_neg=[];
  final_neg=[]; 
 

 
 if length(pos_idx)>0 then
     int_pos=crossval(pos_idx);
      final_pos=crossval(pos_idx+1);
      
 end 
 
 if length(neg_idx)>0 then
      int_neg=crossval(neg_idx);
      final_neg=crossval(neg_idx+1);
  end
  
d=[];
   
        
      if pol=='Positive' then
          if length(int_pos)>=2 then
              
          if int_pos($)~=crossval($) & final_pos($)~=crossval($) then
              int_pos=[int_pos, crossval($)]
             
              initialcross=int_pos (1:($-1));
          finalcross=final_pos;
          nextcross=int_pos(2:$);
          
          d=(finalcross-initialcross)./(nextcross-initialcross);
              
     else
     
          initialcross=int_pos(1:($-1));
          finalcross=final_pos(1:($-1));
          nextcross=int_pos(2:$);
          d=(finalcross-initialcross)./(nextcross-initialcross);
          end
          
      else
 
          d=[];
           initialcross=[];
          finalcross=[];
          nextcross=[];
          end
          
      else
          
          if length(int_neg)>=2 then
              
           if int_neg($)~=crossval($) & final_neg($)~=crossval($) then
              int_neg=[int_neg, crossval($)]
              
              initialcross=int_neg(1:($-1));
          finalcross=final_neg;
          nextcross=int_neg(2:$);
         d=(finalcross-initialcross)./(nextcross-initialcross);
              
     else
          initialcross=int_neg(1:($-1));
          finalcross=final_neg(1:($-1));
          nextcross=int_neg(2:$);
          d=(finalcross-initialcross)./(nextcross-initialcross);
          end
          
      else
           d=[];
           initialcross=[];
          finalcross=[];
          nextcross=[];
          end
      end
      midreference=midref;
      
 
//midreference=midref;

   if argn(1) == 1 then   // if the defined output is only 1, the it will provide the graphical representation of                          //levels
       
      if length(d)==0 then
          
    plot(t,x, 'LineWidth',1, 'color', 'black')
     // xtitle('', 'Time (second)','Level (Volts)' );
       plot(t,midreference * ones(1, length(t)),'-r', 'LineWidth',0.5)
 
      plot(t,mostupperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
      plot(t,levels(2) * ones(1, length(t)),'--k', 'LineWidth',0.5) 
      
      plot(t,upperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
   
       plot(t,lowerbound *ones(1, length(t)),'--g', 'LineWidth',0.5)
       
       plot(t,levels(1) * ones(1, length(t)),'--k', 'LineWidth',0.5)
       
       plot(t,mostlowerbound * ones(1, length(t)),'--g', 'LineWidth',0.5) 
       
      xlabel("Time (second)", "fontsize",3, "color", "black" )
     ylabel("Level (Volts)", "fontsize",3, "color", "black" )  
       

     legends(["Signal";   "upper boundary"; "upper state"; "lower boundary";  "mid reference"; "upper boundary"; "lower state"; "lower boundary"],  [[1;1], [5;2], [1;2], [5;2], [5;1], [3;2], [1;2], [3;2]], opt='?')  
         

      else 
   
      plot(t,x, 'LineWidth',1, 'color', 'black')
  
       plot(t,midreference * ones(1, length(t)),'-g', 'LineWidth',0.5)
     
     
     //n=length(finalcross);
     
     
//    rects=[initialcross(1:2:$); levels(2)*ones(d(1:2:$)); p(1:2:$); (levels(2)-levels(1))*ones(p(1:2:$))]
//    
//
//   col=-10*ones(p(1:2:$));

    midc=[nextcross, initialcross, finalcross];
    midcross=gsort(midc, 'c','i' )
 
     plot(midcross, midreference*ones(midcross), "r*", 'MarkerSize',15);
  plot(t,mostupperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
      plot(t,levels(2) * ones(1, length(t)),'--k', 'LineWidth',0.5) 
      
      plot(t,upperbound * ones(1, length(t)),'--r', 'LineWidth',0.5)
      
    plot(t,midreference * ones(1, length(t)),'-r', 'LineWidth',0.5)
       
       plot(t,lowerbound *ones(1, length(t)),'--g', 'LineWidth',0.5)
       
       plot(t,levels(1) * ones(1, length(t)),'--k', 'LineWidth',0.5)
       
       plot(t,mostlowerbound * ones(1, length(t)),'--g', 'LineWidth',0.5) 
       
       // xrects(rects, col);
       
       xlabel("Time (second)", "fontsize",3, "color", "black" )
     ylabel("Level (Volts)", "fontsize",3, "color", "black" )  
       

     legends([ "Signal";  "mid cross"; "upper boundary"; "upper state"; "lower boundary";  "mid reference"; "upper boundary"; "lower state"; "lower boundary"],  [ [1;1], [-10;5], [5;2], [1;2], [5;2], [5;1], [3;2],[1;2], [3;2]], opt='?')

   end    
end  
end
//    
//
endfunction
