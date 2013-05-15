

s.boot
//asddafafsasajkhaskjhdkjhasdasdkhasdjhgajhsgsd

//--sound detector
(
Ndef(\onOff, {|thresh= 0.09, time= 0.2|
	var src= SoundIn.ar;
	//var src= BPF.ar(SoundIn.ar, 150, 1); //variant
	var off= DetectSilence.ar(src, thresh, time);
	var on= 1-off;		//invert
	on.poll;
})
)

//use this when you want to detect start and stop of a sound from the microphone
