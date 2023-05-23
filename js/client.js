
const socket=io('http://localhost:6700/');

const form=document.getElementsByClassName("send")[0];
const btn=document.getElementsByClassName("btn")[0];
const messageContainer=document.getElementsByClassName("container")[0];


const append=(message,position)=>{
    const messageElement=document.createElement("div");
    messageElement.innerText=message;
    messageElement.classList.add(position);
    messageContainer.append(messageElement);
}

form.addEventListener("submit",(e)=>{
    e.preventDefault();
    const messageInput=document.getElementsByClassName("typeMsg")[0];
    if(messageInput.value.length>0){
        append(messageInput.value,"sendMsg");
        socket.emit("send",messageInput.value);
        messageInput.value="";
    }
});
socket.on("recieve",(data)=>{
    append(`${data.name}: ${data.message}`,"recieveMsg");
    console.log(data);
})
const Name=prompt("Enter Your Name to Join");
socket.emit("new-user-joined", Name);
socket.on("user-joined", (name)=>{
    append(`${name} joined the chat`,"notification");
})

const messageEle=document.createElement("div");
messageEle.innerText="You joined the Chat";
messageEle.classList.add("notification");
messageContainer.append(messageEle);

socket.on("diss",(name)=>{
    append(`${name} left the chat`,"notification")
})