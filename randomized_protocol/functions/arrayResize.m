function z = arrayResize(p, m) 
% resize the array and remove the same element in the array
%
%  INPUT:
%             p      -   the input element p = p1 ... pn
%             m      -   the size of the resizing array
%
%   OUTPUT:
%             z      -   the array
%

%init
z = zeros(1, m);

%TODO: the problem here is that p is a vector, so ...
if find(z == p) > 0  % there is p in z
       disp(' The pi prime is in the array'); 
       
else
        inds = length(find(z > 0));
    
        if inds == length(z)   % array resizing 
                z_ = zeros(1, ceil(m*0.4)); % by default, enlarge 40%
                z = [ z,  z_ ];
        end
    
        z(inds + 1) = p;
        
end