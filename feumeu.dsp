
import("stdfaust.lib");
/////////////////////////////////////////////////////////
// UI ELEMENTS
/////////////////////////////////////////////////////////

osc_group(x) = vgroup("[1] FM OSC
    [tooltip: See Faust's oscillator.lib for documentation and references]",x);
trigger  = osc_group(checkbox("Trigger"));

f_1      = osc_group(hslider("OP 1 Frequency",100,0.01,1000,0.1));
f_2      = osc_group(hslider("OP 2 Frequency",100,0.01,1000,0.1));
ind_1    = osc_group(hslider("Modulation Index",0,0,1000,0.1));


/////////////////////////////////////////////////////////
// FM Function
/////////////////////////////////////////////////////////

am(f1, f2, t1) = gain * os.osc(f1 + (os.osc(f2) * ind_1)* index1)
with
{
gain   = en.arfe(0.01, 0,t1);
index1 = en.arfe(0.01, 0,t1);
};

/////////////////////////////////////////////////////////
// processing
/////////////////////////////////////////////////////////
volfm = osc_group(hslider("volume [unit:dB]", -96, -96, 0, 0.1) : ba.db2linear : si.smoo);
feumeu =  am(f_1,f_2, trigger) * volfm <: _,_;