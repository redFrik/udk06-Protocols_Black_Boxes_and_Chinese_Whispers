//--black boxes, protocols, whisper games


http://entropie.digital.udk-berlin.de/wiki/Klasse_Generative_Kunst_/_Computational_Art


(start 27oct, then 10nov, 17nov, 24nov etc)



     listening  ->  composing  ->  performing  >

	<		<				<			<
	

	
//tools: supercollider, pd, arduino



//--sc

s.boot

//--amplitude tracking

Ndef(\ampTrack, {Amplitude.ar(SoundIn.ar).poll})

Ndef(\snd).play
Ndef(\snd, {SinOsc.ar(400, 0, Ndef.ar(\ampTrack))})

Ndef(\snd, {SinOsc.ar(400, 0, Ndef.ar(\ampTrack)>0.2)})

//add an delay to avoid feedback when testing.  here 1sec
Ndef(\snd, {SinOsc.ar(400, 0, DelayN.ar(Ndef.ar(\ampTrack)>0.2, 1, 1))})


Ndef(\snd, {SinOsc.ar(400, 0, DelayN.ar( Decay.ar(Ndef.ar(\ampTrack)>0.2*0.1, 0.1), 1, 1))})


//to stop...
//cmd+.  osx
//alt +.  win



//--frequency tracking / pitchtracking

Ndef(\pctTrack, {Pitch.kr(SoundIn.ar).poll})		//output 2 values: freq, stable on/off

//Hertz  cps

Ndef(\snd).play
Ndef(\snd, {SinOsc.ar(Ndef.kr(\pctTrack)[0], 0, 0.5)})

//again add a 1sec delay
Ndef(\snd, {DelayN.ar( SinOsc.ar(Ndef.kr(\pctTrack)[0], 0, 0.5), 1, 1)})

//using the hasFreq
Ndef(\snd, {DelayN.ar( SinOsc.ar(Ndef.kr(\pctTrack)[0], 0, Ndef.kr(\pctTrack)[1]*0.5), 1, 1)})



//--onset / event tracking

Ndef(\beatTracker, {Onsets.kr(FFT(LocalBuf(512), SoundIn.ar), 0.5).poll})

Ndef(\snd).play
Ndef(\snd, {SinOsc.ar( 400, 0, Decay.kr(Ndef.kr(\beatTracker), 0.1)*0.1)})

//add a 1sec delay
Ndef(\snd, { DelayN.ar( SinOsc.ar(400, 0, Decay.kr(Ndef.kr(\beatTracker), 0.1)*0.1), 1, 1)})

//avoid double triggers
Ndef(\snd, {SinOsc.ar(400, 0, Decay.kr(Trig1.kr(Ndef.kr(\beatTracker), 1/15), 0.1)*0.1)})

Ndef(\snd, {var trg= Trig1.kr(Ndef.kr(\beatTracker), 0.1); SinOsc.ar(TRand.kr(300, 3000, trg), 0, Decay.kr(trg, 0.1)*0.1)})

//avoid double triggers
Ndef(\snd, {var trg= Trig1.kr(Ndef.kr(\beatTracker), 0.1); SinOsc.ar(TRand.kr(300, 3000, trg), 0, Decay.kr(Trig1.kr(Ndef.kr(\beatTracker), 0.1), 0.1)*0.1)})

//stop all




//--
Ndef(\ampTrack, {Amplitude.ar(SoundIn.ar)})
Ndef(\pctTrack, {Pitch.kr(SoundIn.ar)})
Ndef(\beatTrack, {Onsets.kr(FFT(LocalBuf(512), SoundIn.ar), 0.5)})

(
Ndef(\snd, {
	Trig1.kr(Ndef.kr(\beatTrack), 1)
	*
	Pan2.ar(
		DelayN.ar(
			SinOsc.ar( Ndef.kr(\pctTrack)[0], 0, Ndef.ar(\ampTrack)),
			1,
			1
		),
		1	//pan it to right channel only - another trick to avoid feedback on mac with microphone on left side
	)
})
)
Ndef(\snd).play
Ndef(\snd).clear


//making it transform sounds
(
Ndef(\snd, {
	Trig1.kr(Ndef.kr(\beatTrack), 1)
	*
	Pan2.ar(
		DelayN.ar(
			SinOsc.ar( Median.kr(40, Ndef.kr(\pctTrack)[0]).round(100), 0, Ndef.ar(\ampTrack).lag(0.4)),
			1,
			1
		),
		1
	)
})
)
Ndef(\snd).play



//--

(
Ndef(\clar, {		//set Pitch's clar to >0 and hasFreq will be continuous
	var src= SoundIn.ar;
	var pch= Pitch.kr(src, clar: 1);
	pch[1].poll;
	DelayN.ar(Pan2.ar(SinOsc.ar(pch[0], 0, 0.1), pch[0].explin(100, 3000, -1, 1, \minmax)), 2, 2);
})
)
Ndef(\clar).play

//output pink noise when a pitch is detected - the more stable pitch, the louder noise
(
Ndef(\clar, {
	Pan2.ar(
		PinkNoise.ar(
			Pitch.kr(SoundIn.ar, clar:1)[1].poll*0.2
		),
		1
	)
})
)

Ndef(\clar).clear
