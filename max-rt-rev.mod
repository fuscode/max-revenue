# Declaration of parameters

param mwh := 1;
param mw := 1;
param ti := 1; 
param tf;
param p {t in ti..tf};
param ciclos_dia := 5;
param ciclos_total := 2000;
# Declaration of variables

var x_c {t in ti..tf};
var x_d {t in ti..tf};
var y {t in (ti-1)..tf} >=0 ;
var te {t in ti..tf} = sum {i in ti..t} (x_d[i]+x_c[i]);
var te_24 {t in ti..(tf/24)} = sum {i in (24*(t-1) + 1)..24*t} (x_d[i]+x_c[i]);
var q_rem {t in ti..tf} = 1 - 2.71e-5*te[t]/mwh;

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

# Carga remanescente diminiu com o tempo
subject to c_ymax {t in ti..tf}: y[t] <=  q_rem[t] * mwh;
subject to c_ymin {t in ti..tf}: y[t] >= 0;

# Limite de dois ciclos de carga por dia
subject to b_max {t in ti..(tf/24)}: te_24[t] <= ciclos_dia * mwh;

# Limite de 2 mil ciclos de carga-descarga
subject to b_life {t in ti..tf}: te[tf]/mwh <= ciclos_total;
