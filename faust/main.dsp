import("stdfaust.lib");
import("socisse.dsp");
import("feumeu.dsp");
import("osync.dsp");
import("moogish.dsp");

process = feumeu, oscsaw, osync :> _ : moogvcf <: _,_;