//--pool of buffers

~buffers= {Buffer.alloc(s, s.sampleRate*2)}.dup(16);

//this will create 16 buffers, each 2 seconds long

//access a single buffer
~buffers[0].plot	//plot first buffer
~buffers[1].plot	//plot second buffer
//and so on
~buffers[15].plot	//plot the last buffer