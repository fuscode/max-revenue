# Declaration of parameters

param mwh := 1;
param mw := 1;
param ti := 1; 
param tf;
param p {t in ti..tf};

# Declaration of variables

var x_c {t in ti..tf};
var x_d {t in ti..tf};
var y {t in (ti-1)..tf} >=0 ;
var e {t in (ti-1)..tf} >=0 ;
#var TE {t in ti..tf} = sum {j in ti..t} abs(x_d[j]-x_c[j]);
#var q_rem {t in ti..tf} = 1 - 2.71e-5*TE[t]/mwh;

# Objective function

maximize revenue: sum {t in ti..tf} p[t]*(x_d[t]-x_c[t])*1 ; 

#Constraints

subject to c_init {t in (ti-1)..tf}: y[ti-1] =mwh/2;
subject to c_final {t in (ti-1)..tf}: y[tf] =mwh/2;

subject to c_xmin {t in ti..tf}: x_c[t] <= mw;
subject to c_xmax {t in ti..tf}: x_d[t] <= mw;

subject to c_xmin1 {t in ti..tf}: x_c[t] >= 0 ;
subject to c_xmax2 {t in ti..tf}: x_d[t] >= 0;

subject to c_cons {t in ti..tf}: y[t] = y[t-1] +(1*x_c[t]-x_d[t]);

#subject to e_init {t in (ti-1)..tf}: e[ti-1] =0;
subject to te {t in ti..tf}: e[t] = e[t-1] + (1*x_c[t]-x_d[t]);

subject to c_ymax {t in ti..tf}: y[t] <= mwh;
subject to c_ymin {t in ti..tf}: y[t] >= 0;

#subject to rev {t in ti..tf}: r[t] = p[t]*(x_d[t]-x_c[t]);
