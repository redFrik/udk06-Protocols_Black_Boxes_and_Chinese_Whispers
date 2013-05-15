http://www.youtube.com/user/instantdecomposer#p/a/u/1/oML8PzMu3Zs

 //--ABC--ABC--ABC--ABC--ABC--ABC--ABC
 //automatic sound record and playback patterner

 
 Server.default= Server.local;
 s.boot
 
 
 //--sound detector
 (
 Ndef(\abcSoundDetector, {|thresh= 0.05, time= 0.2|
 	var input= SoundIn.ar;
 	var off= DetectSilence.ar(input, thresh, time);
 	var on= 1-off;				//invert
 	var cnt= PulseCount.ar(on)%16+1;	//buffer index counter - assumes 16 buffers
 	on*cnt;
 });
 )
 
 //--buffer allocator. 16 buffers, 2 second each
 ~buffers= {Buffer.alloc(s, s.sampleRate*2)}.dup(16);
 
 //--automatic recorder
 (
 Ndef(\abcRecorder, {|mute= 0|
 	var src= DelayN.ar(SoundIn.ar, 0.1, 0.1);	//compensate a little for detector latency
 	var trg= (Ndef.ar(\abcSoundDetector)*(1-mute)).poll;
 	{arg i; RecordBuf.ar(src, ~buffers[i], loop:0, trigger: BinaryOpUGen('==', trg, i+1).poll)}.dup(16);
 });
 )
 
 //--playback using patterns
 (
 SynthDef(\abcPlayer, {|out= 0, buf, pan= 0, amp= 0.1, atk= 0.01, rel= 0.1, gate= 1, rate= 1|
 	var env= EnvGen.ar(Env.asr(atk, amp, rel), gate, doneAction:2);
 	var src= PlayBuf.ar(1, buf, rate);
 	Out.ar(out, Pan2.ar(src*env, pan));
 }).add;
 )
 Pdef(\pattern1).play(quant:1)
 Pdef(\pattern1, Pbind(\instrument, \abcPlayer, \buf, Prand(~buffers, inf), \amp, 0.8, \dur, Pseq([0.25, 0.25, 0.25, 2], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([-1, -1.2], inf)))
 
 Pdef(\pattern2).play(quant:1)
 Pdef(\pattern2, Pbind(\instrument, \abcPlayer, \buf, Prand(~buffers, inf), \amp, 0.5, \dur, Prand([0.25, 0.25, 0.5, 0.5, 1], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([1, 1, 1, 0.9, 1.2]+0.4, inf)))
 
 Pdef(\pattern3).play(quant:1)
 Pdef(\pattern3, Pbind(\instrument, \abcPlayer, \buf, Prand(~buffers, inf), \amp, 0.5, \dur, Prand([0.25, 0.25, 0.5, 0.5, 1], inf), \pan, Pwhite(-1, 1, inf), \rate, Prand([1, 1, 1, 0.9, 1.2]-0.4, inf)))
 
 
 Ndef(\abcRecorder).set(\mute, 1)	//halt any more input into the recorder
 Ndef(\abcRecorder).set(\mute, 0)	//resume recording input
 
 Ndef(\pattern1).stop;
 Ndef(\pattern2).stop;
 Ndef(\pattern3).stop;
 ~buffers.do{|x| x.free};
 
 
 
 //store one buffer to disk 
 ~buffers[0].write("/Users/Stirling/mybuf0.aif")
 ~buffers[0].read("/Users/Stirling/mybuf0.aif")
 
 
 //store all buffers to disk
 ~buffers.do{|b, i| b.write("/Users/Stirling/abcBuffer"++i++".aiff")}
 ~buffers.do{|b, i| b.read("/Users/Stirling/abcBuffer"++i++".aiff")}
