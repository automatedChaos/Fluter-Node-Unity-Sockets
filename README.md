Example code for connecting a Flutter app with Unity via web sockets. 

Components: 

* NodeSockets - very basic socket server that manages connections and comms. There are two main types of connections: *player* that allows the user to control a character and a *display* used to display the game. 
* TestApp - a simple Flutter app that can connect to the socket server and control a player.
* Unity-Socket-Client - that can be used as the boilerplate for a game. When a player connects the Unity scene adds a player and allows them to be controlled. 
* Webclient - used for analytics and testing purposes. This is experimental and still requires development. 
