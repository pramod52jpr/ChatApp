
const io = require("socket.io")(process.env.PORT || 6700, function () {
    console.log("SERVER STARTED PORT: 6700");
});
io.engine.on("headers", (headers, req) => {
    headers["Access-Control-Allow-Origin"] = "*";
});
const user={};
io.on("connection",(socket)=>{
    socket.on("new-user-joined",(name)=>{
        if(name!=null){
            user[socket.id]=name;
            socket.broadcast.emit("user-joined",name);
        }
    });
    socket.on("send",(message)=>{
        if(message!=null){
            socket.broadcast.emit("recieve",{message:message,name:user[socket.id]});
        }
    });
    socket.on("disconnect",()=>{
        if(user[socket.id]!=null){
            socket.broadcast.emit("diss",user[socket.id]);
            delete user[socket.id];
        }
    })
})