
http://www.youtube.com/user/instantdecomposer#p/a/u/1/oML8PzMu3Zs
record new sounds into buffers
pitch rate change
repeats/stuttering
amplitude variation
4, 8th, 16th notes
duration of recording?



analysis
composition
output


Amplitude
Pitch
Onsets


s.boot

build new sounds
pitch rate change
repeats/stuttering
amplitude variation
4, 8th, 16th

duration?




s.boot
//--patterns

Pdef(\degree, Pbind(\degree, Pseq([0, 5, 2, 3, 2, 1], inf)))
Pdef(\degree).play
Pdef(\degree).stop

Pdef(\degree, Pbind(\midinote, Pseq([60, 68, 62, 48], inf)))


Pdef(\degree, Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf), \dur, 0.25))
Pdef(\degree, Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf), \dur, 0.125))

Pdef(\degree, Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf), \dur, 0.25, \octave, 6))

Pdef(\degree, Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf), \dur, 0.25, \octave, 6, \legato, 0.1))

//more readable version - static values
(
Pdef(\degree, Pbind(
	\degree, 1,
	\dur, 0.125,
	\octave, 8,
	\legato, 0.1
))
)

//pattern version
(
Pdef(\degree, Pbind(
	\degree, Pseq([0, 1], inf),
	\dur, Pseq([0.125, 0.125, 0.25], inf),
	\octave, Pseq([5, 6, 7], inf),
	\legato, Pseq([0.1, 2, 0.1, 0.1], inf)
))
)


//Pstutter

//--scales
Pdef(\degree).play
(
Pdef(\degree, Pbind(
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\scale, Scale.hindu,		//minor, lydian, mixolydian, diminished, bartok, hindu
	\dur, 0.125
))
)

(
Pdef(\degree, Pbind(
	\degree, Pseq([0, 1, 2, 3], inf),
	\scale, Scale([0, 1, 2, 7]),
	\dur, 0.125
))
)
//0, 1, 2, 7, 12, 13, 14, 19

(
Pdef(\degree, Pbind(
	\degree, Pseq([0, 1, 2, 3], inf),
	\scale, Scale([0, 1, 2, 7]),
	\dur, 0.125,
	\amp, Pseq([0, 1, 0.125, 0.5, 0.25, 1, 0, 0, 0.4, 0.25], inf)
))
)
Pdef(\degree).play
Pdef(\degree).stop


//

(
Pdef(\track0).play;
Pdef(\track1).play;
Pdef(\track2).play;
)
TempoClock.default.tempo= 90/60	//set tempo to 90bpm

(	//slow bass line
Pdef(\track0, Pbind(
	\dur, Pseq([2, 2, 1, 1], inf),
	\degree, Pseq([0, 1, 1, 0], inf),
	\octave, 4
))
)

(	//mid range arpeggio
Pdef(\track1, Pbind(
	\dur, Pseq([0.25, 0.25, 0.25, 0.25], inf),
	\degree, Pseq([0, 5, 4, 2, 3, 1, 0], inf),
	\octave, 5,
	\amp, Pseq([0.2, 0.1, 0], inf)
))
)

(	//high pitch fast tremolo
Pdef(\track2, Pbind(
	\dur, Pseq([0.125], inf),
	\degree, Pseq([0, -1, 3, 1], inf),
	\octave, 7,
	\amp, 0.05
))
)
Pdef(\track1).stop
Pdef(\track2).stop
Pdef(\track0).stop




(
SynthDef(\mysound, {|freq= 400, amp= 0.1, gate= 1, atk= 0.01, rel= 0.1, pan= 0|
	var env= EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	var src= SinOsc.ar(freq, 0, env*amp);
	Out.ar(0, Pan2.ar(src, pan));
}).add;
)
(
SynthDef(\bd, {|freq= 400, amp= 0.1, atk= 0.01, rel= 0.1, pan= 0|
	var env= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var src= SinOsc.ar(freq, 0, env*amp);
	Out.ar(0, Pan2.ar(src, pan));
}).add;
)
(
SynthDef(\sn, {|amp= 0.1, atk= 0.01, rel= 0.1, pan= 0|
	var env= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var src= PinkNoise.ar(env*amp);
	Out.ar(0, Pan2.ar(src, pan));
}).add;
)
(
Pdef(\sn, Pbind(
	\instrument, \sn,
	\dur, 0.5,
	\amp, Pseq([0.5, 0.2, 0.1, 0, 0, 0.4], inf),
	\pan, Pseq([0, 0.2, 0.9, -0.9, 0.2], inf),
	\atk, 0.001,
	\rel, Pseq([0.1, 0.05, 0.08], inf)
))
)
Pdef(\sn).play
(
Pdef(\bd, Pbind(
	\instrument, \bd,
	\dur, 0.5,
	\freq, 70,
	\amp, Pseq([0.5], inf),
	\pan, Pseq([0, 0.2, 0.9, -0.9, 0.2], inf),
	\atk, 0.001,
	\rel, Pseq([0.1, 0.05, 0.08], inf)
))
)
Pdef(\bd).play

(
Pdef(\mysound, Pbind(
	\instrument, \mysound,
	\dur, Prand([0.5, 0.5, 0.5, 0.25, 0.125], inf),
	\degree, Pseq([[0, 6], 5, 2, 1, [1, 4], 1], inf),
	\amp, Pseq([0.05, 0, 0.05], inf),
	\pan, Pseq([0, 0.2, 0.9, -0.9, 0.2], inf),
	\atk, 0.01,
	\rel, Pseq([0.1, 0.05, 0.08], inf),
	\legato, Prand([1, 0.4, 0.1, 0.2], inf)
))
)
Pdef(\mysound).play
TempoClock.default.tempo= 60/60
Pdef(\bd).stop
Pdef(\sn).stop
Pdef(\mysound).stop


//read more about patterns/synthdefs in the Event helpfile
