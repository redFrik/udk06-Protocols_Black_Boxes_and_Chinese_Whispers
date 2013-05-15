//RecRecRecRecRecRecRecRecRecRecRecRecRecRec


//a single buffer recorder. records mic into ~buffers[x]. change x to select buffer
(
Ndef(\recorder, {
	var src= SoundIn.ar;
	RecordBuf.ar(src, ~buffers[15], loop:0);
})
)

//test
~buffers[0].plot
~buffers[0].play
~buffers[15].play


//TRIGGER RECORDER - using SOUND DETECTOR patch
(
Ndef(\recorderWithDetector, {
	var src= SoundIn.ar;
	RecordBuf.ar(src, ~buffers[0], loop:0, trigger: Ndef.ar(\onOff)*MouseButton.kr);
})
)
~buffers[0].play
