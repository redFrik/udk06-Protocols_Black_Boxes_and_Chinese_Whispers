s.boot
Ndef(\ampTrack, {Amplitude.ar(SoundIn.ar)})
Ndef(\pctTrack, {Pitch.kr(SoundIn.ar)})
Ndef(\beatTrack, {Onsets.kr(FFT(LocalBuf(512), SoundIn.ar), 0.5)})

b= {Buffer.alloc(s, 44100*2)}.dup(4)

(
Ndef(\buf, {
	var trig= Trig1.kr(Ndef.kr(\beatTrack), 2).poll;
	BufWr.ar(DelayN.ar(SoundIn.ar, 0.5, 0.5), b[0], Phasor.ar(trig, BufRateScale.kr(b[0])*1, 0, BufFrames.kr(b[0])));
	SinOsc.ar(400, 0, trig.lag(0.1));
})
)
Ndef(\buf).play
b[0].plot
b[0].play


//--
Ndef(\snd).play
(
Ndef(\snd, {|trig= 0, freq= 400, amp= 0.4|
	var env= EnvGen.ar(Env.perc, trig);
	SinOsc.ar(freq*[1, 1.01], 0, env*amp);
});
)
Pdef(\pat).play
Pdef(\pat, Pmono(\snd))
