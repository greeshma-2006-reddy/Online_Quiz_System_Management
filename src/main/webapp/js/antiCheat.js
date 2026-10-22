let warnings = 0;

// right click
document.addEventListener("contextmenu", e => e.preventDefault());

// copy paste cut
["copy","paste","cut"].forEach(evt=>{
document.addEventListener(evt, e => e.preventDefault());
});

// tab switch
document.addEventListener("visibilitychange", () => {
if(document.hidden){
warnings++;
alert("Warning " + warnings + ": Do not switch tab");

if(warnings >= 3){
document.forms[0].submit();
}
}
});

// fullscreen exit
document.addEventListener("fullscreenchange", () => {
if(!document.fullscreenElement){
warnings++;
alert("Warning " + warnings + ": Stay in fullscreen");

if(warnings >= 3){
document.forms[0].submit();
}
}
});

// keyboard block
document.addEventListener("keydown", e => {

if(
e.key === "F12" ||
(e.ctrlKey && ["c","v","x","u","p","s"].includes(e.key)) ||
(e.ctrlKey && e.shiftKey && ["I","J"].includes(e.key))
){
e.preventDefault();
}

});