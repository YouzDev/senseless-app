
var localVideo  =  document.getElementById('webrtc-sourcevid');
var remoteVideo =  document.getElementById('webrtc-remotevid');
var isInitiator = false;
var isChannelReady = false;
var pc = null;
var localStream;
var isStarted = false;
var pc_config = { 'iceServers': [{
    'url': 'stun:stun.l.google.com:19302' },
				 {
				     'url': 'turn:numb.viagenie.ca:3478',
				     'credential': 'webrtcrails',
				     'username': 'xescugil@gmail.com'
				 }]};
var pc_constraints  = {optional: [{DtlsSrtpKeyAgreement: true}]}
var sdpConstraints =
    {'mandatory':
     {
	 'OfferToReceiveAudio':true,
	 'OfferToReceiveVideo':true
     }
    };
var room = prompt("create or join a room");
console.log(room);

if (room !== "") {
    console.log('Joining room ' + room);
    socket.emit('create or join', room);
}
console.log('room: isInitiator: ',isInitiator);

// Logs getUserMedia KO
function gotError(error){
    console.log('Problems with GetUserMedia', error);
}
// Fetch the user Stream (Video and Audio), getUserMedia OK
function gotStream(stream){
    localStream = stream;
    attachMediaStream(localVideo, stream);
    socket.emit('message', {message: 'gotStream', type: 'gotStream', room: room});
    if (isInitiator) {
	maybeStart();
    }
}

// Get User Media
navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
    || window.navigator.mozGetUserMedia || navigator.msGetUserMedia;
window.URL = window.URL || window.webkitURL;

navigator.getUserMedia({video:true, audio:true}, gotStream, gotError);

// requestTurn('https://computeengineondemand.appspot.com/turn?username=41784574&key=4080218913');

function handleIceCandidate(event) {
    console.log('ice', event);
    if (event.candidate) {
	socket.emit('message', {room: room, type: 'candidate', message: event.candidate});
    }
}
function handleOnAddRemoteStream(event){
    console.log("added Remote Stream")
    window.remoteVideoEvent = event;
    attachMediaStream(remoteVideo, event.stream);
}
function handleOnRemoveStream(event){
    console.log('Remote stream removed. Event: ', event);
}

function maybeStart() {
    if (isChannelReady && !isStarted && typeof localStream != 'undefined'){
	pc                = new RTCPeerConnection(pc_config, pc_constraints);
	pc.onicecandidate = handleIceCandidate;
	pc.onaddstream    = handleOnAddRemoteStream;
	pc.onremovestream = handleOnRemoveStream;
	pc.addStream(localStream);
	isStarted         = true;
	console.log("mb start:isInitiator", isInitiator);
	if (isInitiator) {
	    startCall();
	}
    } else {
	console.log("info", isChannelReady, isStarted, typeof localStream);
    }
}

function setLocalAndSendMessageOffer(offer) {
    // offer.sdp = preferOpus(offer.sdp);
    pc.setLocalDescription(offer);
    socket.emit('message', {room: room, type: 'offer', message: offer})
}

function setLocalAndSendMessageAnswer(answer) {
    // answer.sdp = preferOpus(answer.sdp);
    pc.setLocalDescription(answer);
    socket.emit('message', {room: room, type: 'answer', message: answer})
}

function startCall(){
    console.log("Do Call");
    pc.createOffer(setLocalAndSendMessageOffer, handleCreateOfferError);
}

function requestTurn(turn_url) {
    var turnExists = false;
    for (var i in pc_config.iceServers) {
	if (pc_config.iceServers[i].url.substr(0, 5) === 'turn:') {
	    turnExists = true;
	    turnReady = true;
	    break;
	}
    }
    if (!turnExists) {
	console.log('Getting TURN server from ', turn_url);
	// No TURN server. Get one from computeengineondemand.appspot.com:
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function(){
	    if (xhr.readyState === 4 && xhr.status === 200) {
		var turnServer = JSON.parse(xhr.responseText);
		console.log('Got TURN server: ', turnServer);
		pc_config.iceServers.push({
		    'url': 'turn:' + turnServer.username + '@' + turnServer.turn,
		    'credential': turnServer.password
		});
		turnReady = true;
	    }
	};
	xhr.open('GET', turn_url, true);
	xhr.send();
    }
}

function handleCreateOfferError(event) {
    console.log("Error when Creating Offer", event);
}

function handleCreateAnswerError(event) {
    console.log("Error when Creating Answer", event);
}

function startAnswer(){
    console.log("Do Call");
    pc.createAnswer(setLocalAndSendMessageAnswer, handleCreateAnswerError, sdpConstraints);
}
