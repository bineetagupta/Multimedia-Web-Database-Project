function dist=manhattan(v1,v2)

if size(v1,2)~=size(v2,2)
   error('Vector dimensions do not match') ;
end

dist=0.0;

for i=1:size(v1,2)
    dist=dist+double(abs(v1(i)-v2(i)));
end