s.boot
b= Buffer.alloc(s, s.sampleRate*2);
(
SynthDef(\when, {|in= 0, thresh= 0.5, gate= 1, rel= 1, buf|
	var input= HPF.ar(In.ar(in, 1)*gate, 40);
	//var delay= DelayN.ar(input, 0.1, 0.1);
	var track= Amplitude.ar(input, 0.01, rel);

	var trig= Trig1.kr(Onsets.kr(FFT(LocalBuf(512), input), thresh), 1);
	var silent= (Schmidt.kr(Amplitude.kr(input*Trig1.kr(trig, 4), 0.01, 1), 0.02, 0.1)<1);
	SendReply.kr(trig, 'onsets', [trig, track]);
	SendReply.kr(silent, 'silent', silent);
}).add;
)
(
a= Synth(\when, [\in, 8, \buf, b]);
o= OSCresponder(s.addr, 'onsets', {|t, r, m|
	m.postln;
}).add;
p= OSCresponder(s.addr, 'silent', {|t, r, m|
	m.postln;
}).add;
CmdPeriod.doOnce({o.remove});
)




//--
s.boot
(
Ndef(\onOff, {|thresh= 0.05, time= 0.2|
	var input= SoundIn.ar;
	var off= DetectSilence.ar(input, thresh, time);
	var on= 1-off;
	var cnt= PulseCount.ar(on)%16+1;
	on.poll(label:"on");
	off.poll(label:"off");
	cnt.poll(label:"cnt");
	on*cnt
});
)

(
Ndef(\onOff2, {|threshLo= 0.01, threshHi= 0.1, atk= 0.1, rel= 0.5|
	var input= SoundIn.ar;
	var tracker= Amplitude.ar(input, atk, rel).poll;
	var on= Schmidt.ar(tracker, threshLo, threshHi);
	var off= 1-on;
	var cnt= PulseCount.ar(on)%16+1;
	on.poll(label:"on");
	off.poll(label:"off");
	cnt.poll(label:"cnt");
	on*cnt
});
)

b.do{|x| x.free}
b= {Buffer.alloc(s, s.sampleRate*2)}.dup(16);
(
Ndef(\recorders, {
	var src= DelayN.ar(SoundIn.ar, 0.1, 0.1);
	var trg= Ndef.ar(\onOff).poll;
	{|i| RecordBuf.ar(src, b[i], loop:0, trigger: BinaryOpUGen('==', trg, i+1).poll)}.dup(16);
});
)
b[1].plot
b[6].play
Ndef(\recorders).stop

(
SynthDef(\player, {|out= 0, buf, pan= 0, amp= 0.1, atk= 0.01, rel= 0.1, gate= 1, rate= 1|
	var env= EnvGen.ar(Env.asr(atk, amp, rel), gate, doneAction:2);
	var src= PlayBuf.ar(1, buf, rate);
	Out.ar(out, Pan2.ar(src*env, pan));
}).add;
)
Pdef(\p1).play(quant:1)
Pdef(\p1, Pbind(\instrument, \player, \buf, Prand(b, inf), \amp, 0.5, \dur, Prand([0.25, 0.25, 0.5, 0.5, 1], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([1, 1, 1, 0.9, 1.2], inf)))

Pdef(\p2).play(quant:1)
Pdef(\p2, Pbind(\instrument, \player, \buf, Prand(b, inf), \amp, 0.5, \dur, Prand([0.25, 0.25, 0.5, 0.5, 1], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([1, 1, 1, 0.9, 1.2]+0.4, inf)))

Pdef(\p3).play(quant:1)
Pdef(\p3, Pbind(\instrument, \player, \buf, Prand(b, inf), \amp, 0.5, \dur, Prand([0.25, 0.25, 0.5, 0.5, 1], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([1, 1, 1, 0.9, 1.2]-0.4, inf)))
