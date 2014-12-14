var socket = io.connect('192.168.1.20:2014');

var room = window.location.pathname.replace("/", "");

socket.on("created", function (){
    console.log("On Created");
    isInitiator = true;
    console.log('client_sig: isInitiator', isInitiator);
})

socket.on("joined", function(){
    console.log("A client just joined. Room might be full now");
    isChannelReady = true;
})

socket.on("full", function(){
    console.log("Room Full, max number of 2");
})

socket.on("message", function(data) {
    if (data.type === 'gotStream') {
	console.log("gg", data.message);
	maybeStart();
    } else if (data.type === 'candidate' && isStarted) {
	var candidate = new RTCIceCandidate({
	    candidate: data.message.candidate,
	    sdpMLineIndex:  data.message.sdpMLineIndex
	});
	pc.addIceCandidate(candidate);
    }else if (data.type === 'answer' && isStarted) {
	pc.setRemoteDescription(new RTCSessionDescription(data.message));
    }else if (data.type === 'offer') {
	if (!isInitiator && !isStarted) {
	    maybeStart();
	}
	pc.setRemoteDescription(new RTCSessionDescription(data.message));
	startAnswer();
    }else if (data.type === 'im') {
	appendNewIM(data.message.user, data.message.content);
    }else if (data.type === 'by') {
	stop();
    }
})
