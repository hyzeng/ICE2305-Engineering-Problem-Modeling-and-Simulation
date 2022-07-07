function output = my_interpolation( premea_vout,premea_tempr,vout,k)

if(k==0)
    output=interp1(premea_vout,premea_tempr,vout,'makima');
elseif(k==1)
    output=interp1(premea_vout,premea_tempr,vout,'spline');
else
    output=interp1(premea_vout,premea_tempr,vout,'pchip');
end


end

