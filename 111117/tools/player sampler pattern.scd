//playback engine

//asadsa  MY UTLRA PLAYBACKER THINGIE!!!!!!!!!


//plays back sounds recorded into ~buffers

(	//a genereic mono buffer player
SynthDef(\player, {|out= 0, buf, pan= 0, amp= 0.1, atk= 0.01, rel= 0.1, gate= 1, rate= 1|
	var env= EnvGen.ar(Env.asr(atk, amp, rel), gate, doneAction:2);
	var snd= PlayBuf.ar(1, buf, rate);
	Out.ar(out, Pan2.ar(snd*env, pan));
}).add;
)

Pdef(\pattern).play
Pdef(\pattern, Pbind(\instrument, \player, \buf, ~buffers[m], \rate, 1.2))

Pdef(\pattern, Pbind(\instrument, \player, \buf, ~buffers[15], \rate, Pseq([1, 0.9, 1.1], inf), \dur, Pseq([0.25, 0.25, 0.5, 1], inf)))
Pdef(\pattern).stop
~buffers[15].plot