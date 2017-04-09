function [x,y,numsam]=noisingexamples(x,y,factor,noise,stdvar)
%Fisrt, the number of examples is extended by the factor of "factor", second,the noise
%of the type "noise" with the standard variance of "stdvar" is added.
%usage:
%    [x,y,numsam]=noisingexample(x,y,factor,noise,stdvar);

if nargin<2 | nargin>5
    help noisingexamples
else
    if nargin<5,stdvar=1;,end
    if nargin<4,noise='gaussian';,end
    if nargin<3,factor=10;,end
    x=kron(x,ones(factor,1));
    y=kron(y,ones(factor,1));
    numsam=length(y);
    switch lower(noise)
        case 'gaussian'
            x=x+stdvar*randn(size(x));
        case 'uniform'
            x=x+stdvar*rand(size(x))-stdvar/2;
        otherwise
            disp(['no predefined the noise of the type:',lower(noise)]);
    end
end