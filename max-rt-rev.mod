# Declaration of parameters
param mwh := 1;
param mw := 1;
param ti := 1; 
param n := 1; 
param tf;
param p {t in ti..tf};
param ciclos_dia := 5;
param ciclos_total := 2000;
param SOC_max = 0.9;
param SOC_min = 0.3;
param c_b = 100e3 * 0;
param eol = 0.8;

# Declaration of variables
var E_p {t in ti..tf};
var E_s {t in ti..tf};
var SOC {t in (ti-1)..tf} >=0 ;
var E_to {t in ti..tf} = E_p[t]*n;
var E_from {t in ti..tf} = E_s[t]*n;
var te {t in ti..tf} = sum {i in ti..t} (E_from[i]);
var te_24 {t in ti..(tf/24)} = sum {i in (24*(t-1) + 1)..24*t} (E_from[i]);
var q_rem {t in ti..tf} = mwh - 2.71e-5*te[t];
var c {t in ti..tf} = (3.37e-5*E_from[t])/(SOC_max-SOC_min) * c_b/(1-eol);

# Objective function
maximize revenue: sum {t in ti..tf} (p[t]*(E_s[t]-E_p[t])-c[t]);

#Constraints
subject to c_xmin {t in ti..tf}: 0 <= E_p[t] <= mw;
subject to c_xmax {t in ti..tf}: 0 <= E_s[t] <= mw;

# State of Charge inicial final e instantaneo
subject to c_init {t in (ti-1)..tf}: SOC[ti-1] = mwh/2;
subject to c_final {t in (ti-1)..tf}: SOC[tf] = mwh/2;
subject to c_cons {t in ti..tf}: SOC[t] = SOC[t-1] - E_from[t] + E_to[t];

# SOC_range depende da carga remanescente e do range de operacao
subject to DOD_max {t in ti..tf}: SOC[t] <= q_rem[t] * 1;
subject to DOD_min {t in ti..tf}: SOC[t] >= q_rem[t] * 0;

# # Limite de ciclos de carga por dia
# subject to b_max {t in ti..(tf/24)}: te_24[t] <= ciclos_dia * mwh;

# # Limite de 2 mil ciclos de carga-descarga
# subject to b_life {t in ti..tf}: te[tf]/mwh <= ciclos_total;
