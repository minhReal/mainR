<h1 align="center">Require Executor – Free & Open Source</h1>

# About
Require Executor is a free and open-source Roblox executor system designed to
run module scripts using require(ID).

This project is made for learning, testing, and experimenting with require-based
scripts inside your own Roblox games. It focuses on transparency, simplicity,
and compatibility with free executors.

There is no obfuscation, no hidden backdoors, and no malicious code.

# System Overview
This system uses:
- A LocalScript for the GUI and client-side control
- A Server Script for server-side execution
- A RemoteEvent for client–server communication

# Security Warning (Important)
This executor is capable of running server-side code when SERVER mode is enabled.

If you allow all players in your server to freely use SERVER execution, you are
effectively giving them the ability to run arbitrary code on the server.

This can be extremely dangerous.

Possible risks include:
- Abusing server-side functions
- Damaging game data or gameplay
- Triggering Roblox moderation systems
- Getting the game owner or place permanently banned

For safety reasons:
- Do NOT allow public players to use SERVER mode
- Restrict SERVER execution to trusted users only
- Use Admin lists, permission checks, or private testing places
- Prefer CLIENT mode for public environments

This project is intended for controlled environments, such as:
- Personal projects
- Private test places
- Development servers
- Trusted developer teams

You are fully responsible for how this system is used in your game.

# Installation Guide

# Step 1: Create the RemoteEvent
1. Open Roblox Studio
2. Go to ReplicatedStorage
3. Right-click and select:
   Insert Object -> RemoteEvent
4. Rename the RemoteEvent to:Exe

This RemoteEvent is required for SERVER execution mode.

# Step 2: LocalScript Placement
1. Get the localscript [here](https://github.com/minhReal/mainR/blob/main/Localscript.lua)
2. Create a __Localscript__ inside __StarterGui__
3. Place it inside __Localscript__
   
The LocalScript handles:
- GUI rendering
- User input
- Client-side execution
- Sending requests to the server

# Step 3: Server Script Placement
1. Get the script [here](https://github.com/minhReal/mainR/blob/main/Script.lua)
2. Create a __script__ inside __ServerScriptService__
3. Place it inside __script__
   

This Script listens to the RemoteEvent and performs server-side actions.

# Execution Modes
SERVER mode:
- Uses RemoteEvent
- Code executes on the server
- Requires the Server Script

CLIENT mode:
- Uses loadstring
- Code executes locally
- Does not require the Server Script

# How to Use
1. Join the game
2. Click the "<\>" button on the screen to open the executor
3. Enter a command such as:
   require(123456789)("PlayerName")

Or use the IDS tab to insert a script automatically.

4. Select execution mode:
   SERVER or CLIENT

5. Press RUN to execute the script

# Cooldown System
- Default users have a cooldown
- Admins have no cooldown
- Gamepass owners have reduced cooldown

# Important Notes
- Intended for use in your own games only
- Required modules must be public and not deleted
- This does not bypass Roblox security
- Misuse may result in moderation actions

# License
Free to use and modify for learning purposes.
Do not resell or claim ownership of this project.

# Disclaimer
This project is provided for educational purposes only.
Use responsibly.
