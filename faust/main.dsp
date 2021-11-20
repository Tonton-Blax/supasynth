import("stdfaust.lib");
import("socisse.dsp");
import("feumeu.dsp");
import("osync.dsp");
import("moogvcf.dsp");

process= feumeu, oscsaw, osync :> _ : moogvcf <: _,_;