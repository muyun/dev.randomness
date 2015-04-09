function s = binaryVectorToString(v)
% convert a binary vector into string format
%

str_v = num2str(v);
%t = str_v(str_v ~= ' ');
s = str_v(str_v ~= ' ');