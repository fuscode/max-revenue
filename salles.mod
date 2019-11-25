# Declaration of parameters

param mwh := 1;
param mw := 1;
param ti := 1; 
param tf;


param p{t in ti..tf}; 
# param pda{t in ..61320}; 



# Declaration of variables

var x_c {t in ti..tf};
var x_d {t in ti..tf};
var y {t in (ti-1)..tf} >=0 ;
var r {t in ti..tf}; 
var r_DA_in_RT {t in ti..tf}; 


# Objective function

maximize revenue: sum{t in ti..tf} p[t]*(x_d[t]-x_c[t])*1 ; 

#Constraints

subject to c_init {t in (ti-1)..tf}: y[ti-1] =mwh/2;
subject to c_final {t in (ti-1)..tf}: y[tf] =mwh/2;


subject to c_xmin {t in ti..tf}: x_c[t] <= mw;
subject to c_xmax {t in ti..tf}: x_d[t] <= mw;

subject to c_xmin1 {t in ti..tf}: x_c[t] >= 0 ;
subject to c_xmax2 {t in ti..tf}: x_d[t] >= 0;

subject to c_cons {t in ti..tf}: y[t] = y[t-1] +(1*x_c[t]-x_d[t]);


subject to c_ymax {t in ti..tf}: y[t] <= mwh;
subject to c_ymin {t in ti..tf}: y[t] >= 0;


# subject to rev {t in ti..tf}: r[t] = pda[t]*(x_d[t]-x_c[t]);
# subject to rev2 {t in ti..tf}: r_DA_in_RT[t] = p[t]*(x_d[t]-x_c[t]);

