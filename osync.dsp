declare name 		"osc";
declare version 	"1.0";
declare author 		"Grame";
declare license 	"BSD";
declare copyright 	"(c)GRAME 2009";

//-----------------------------------------------
// 			Sinusoidal Oscillator
//-----------------------------------------------

import("stdfaust.lib");
import("oscillators.lib");

sigosc = os.saw2(freqsaw) * checkbox("Saw")
		   + os.oscs(freqsync) * checkbox("Sine");

vol = hslider("volume [unit:dB]", -96, -96, 0, 0.1) : ba.db2linear : si.smoo;
freq = hslider("freq [unit:Hz]", 300, 20, 2400, 1);
freqsync = hslider("freq sync [unit:Hz]", 300, 20, 2400, 1);
freqsaw = hslider("freq saw [unit:Hz]", 300, 20, 2400, 1);
osync = vgroup("Oscillator Sync", hs_oscsin(freq, sigosc) * vol);