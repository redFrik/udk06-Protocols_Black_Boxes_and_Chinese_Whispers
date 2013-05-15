Ndef(\amptracker, {Amplitude.ar(SoundIn.ar).poll})

Ndef(\snd).play
Ndef(\snd, {SinOsc.ar(400, 0, Ndef.ar(\amptracker))})

Ndef(\snd, {SinOsc.ar(400, 0, DelayN.ar(Ndef.ar(\amptracker), 1, 1))})

Ndef(\snd, {SinOsc.ar(400, 0, DelayN.ar(Ndef.ar(\amptracker)>0.3, 1, 1))})

Ndef(\snd, {SinOsc.ar(400, 0, Decay.ar(DelayN.ar(Ndef.ar(\amptracker)>0.3*0.1, 1, 1), 0.1))})

Ndef(\snd, {SinOsc.ar(400, 0, Decay.ar(DelayN.ar(Ndef.ar(\amptracker)>MouseY.kr(0, 1)*MouseX.kr(0, 1), 1, 1), 0.1))})

Ndef(\amptracker).clear



Ndef(\pcttracker, {Pitch.kr(SoundIn.ar).poll})

Ndef(\snd, {SinOsc.ar(Ndef.kr(\pcttracker)[0], 0, Ndef.kr(\pcttracker)[1]*0.2)})

Ndef(\snd, {SinOsc.ar(Ndef.kr(\pcttracker)[0]*0.99, 0, Ndef.kr(\pcttracker)[1]*0.2)})

Ndef(\snd, {DelayN.ar(SinOsc.ar(Ndef.kr(\pcttracker)[0], 0, Ndef.kr(\pcttracker)[1]*0.2), 1, 1)})

Ndef(\pcttracker).clear





//avoid double triggers
Ndef(\snd, {SinOsc.ar(400, 0, Decay.kr(Trig1.kr(Ndef.kr(\beatTracker), 1/15), 0.1)*0.3)})
Ndef(\snd).play




Ndef(\snd, {var trg= Trig1.kr(Ndef.kr(\onsets), 0.1); DelayN.ar(SinOsc.ar(TRand.kr(300, 3000, trg), 0, Decay.kr(trg, 0.1)*0.3), 1, 1)})

Ndef(\snd, {var trg= Trig1.kr(Ndef.kr(\onsets), 0.1); DelayN.ar(SinOsc.ar(TRand.kr(400, 4000, trg), 0, Decay.kr(Trig1.kr(Ndef.kr(\onsets), 0.1), 0.1)*0.3), 1, 1)})

