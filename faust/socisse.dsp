import("stdfaust.lib");
import("basics.lib");
import("signals.lib");
import("oscillators.lib");

oscsaw = signal with { 
  osc_group(x) = vgroup("[0] VIRTUAL ANALOG OSCILLATORS
    [tooltip: See Faust's oscillator.lib for documentation and references]",x);

  // Signals
  saw = (amp/3) * 
    (sawtooth(sfreq) + sawtooth(sfreq*detune1) + sawtooth(freq*detune2));
  sq = (amp/3) * 
    (square(sfreq) + square((sfreq)*detune1) + square(freqSq*detune2));
  tri = (amp) * 
    (triangle(sfreq) + triangle(sfreq*detune1) + triangle(freqTri*detune2));
  pt = (amp/3) * (pulsetrain(sfreq,ptd) 
                + pulsetrain(freqPwm*detune1,ptd) 
                + pulsetrain(sfreq*detune2,ptd));
  ptN = (amp/3) * (pulsetrainN(N,freqPwm,ptd) 
                + pulsetrainN(N,freqPwm*detune1,ptd)
                + pulsetrainN(N,freqPwm*detune2,ptd)) with {N=3;};
  pn = amp * 5 * no.noise;	

  signal = ssaw*saw + ssq*sq + stri*tri 
  	   + spt*((ssptN*ptN)+(1-ssptN)*pt) 
	   + spn*pn + sei*_;

  // Signal controls:
  signal_group(x) = osc_group(hgroup("[0] Signal Levels",x));
  ssaw = signal_group(vslider("[0] Sawtooth [style:vslider]",1,0,1,0.01));

  pt_group(x) = signal_group(vgroup("[1] Pulse Train",x));
  ssptN = 1;
  spt = pt_group(vslider("[1] [style:vslider]",0,0,1,0.01));
  ptd = pt_group(vslider("[2] Duty Cycle [style:knob]",0.5,0,1,0.01))
        : smooth(0.99);

  ssq = signal_group(vslider("[2] Square [style:vslider]",0,0,1,0.01));
  stri = signal_group(vslider("[3] Triangle [style:vslider]",0,0,1,0.01));
  spn = signal_group(vslider(
      "[4] Pink Noise [style:vslider] 
       [tooltip: Pink Noise (or 1/f noise) is Constant-Q Noise, meaning that it has the same total power in every octave (uses only amplitude controls)]",0,0,1,0.01));
  sei = signal_group(vslider("[5] Ext. Input [style:vslider]",0,0,1,0.01));

  // Signal Parameters
  knob_group(x) = osc_group(hgroup("[1] Signal Parameters", x));
  af_group(x) = knob_group(hgroup("[0]", x));
  ampdb  = af_group(hslider("[1] Mix Amplitude [unit:dB] [style:knob]
    [tooltip: Sawtooth waveform amplitude]",
    -20,-120,10,0.1));
  amp = ampdb : db2linear : smooth(0.999);
  freq = af_group(hslider("[2] Tune Saw [unit:PK] [style:knob]
    [tooltip: Sawtooth frequency as a Piano Key (PK) number (A440 = key 49)]",
    49,1,88,0.01) : pianokey2hz);
  freqPwm = af_group(hslider("[3] Tune PWM [unit:PK] [style:knob]
    [tooltip: Sawtooth frequency as a Piano Key (PK) number (A440 = key 49)]",
    49,1,88,0.01) : pianokey2hz);
  freqSq = af_group(hslider("[4] Tune Square [unit:PK] [style:knob]
    [tooltip: Sawtooth frequency as a Piano Key (PK) number (A440 = key 49)]",
    49,1,88,0.01) : pianokey2hz);
   freqTri = af_group(hslider("[5] Tune Tri [unit:PK] [style:knob]
    [tooltip: Sawtooth frequency as a Piano Key (PK) number (A440 = key 49)]",
    49,1,88,0.01) : pianokey2hz);
  
  pianokey2hz(x) = 440.0*pow(2.0, (x-49.0)/12); // piano key 49 = A440 (also defined in effect.lib)

  de_group(x) = knob_group(hgroup("[6]", x));
  detune1 = 1 - 0.01 * de_group(
    vslider("[3] Detuning 1 [unit:%%] [style:knob]
      [tooltip: Percentange frequency-shift up or down for second oscillator]",
      -0.1,-10,10,0.01));
  detune2 = 1 + 0.01 * de_group(
    vslider("[4] Detuning 2 [unit:%%] [style:knob]
      [tooltip: Percentange frequency-shift up or down for third detuned oscillator]",
    +0.1,-10,10,0.01));
  sfreq = freq;
};

//process=oscsaw;