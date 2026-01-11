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

# Security Warning (Read Carefully)

This script does NOT enforce CLIENT-only execution for normal players.

At the current stage, the execution mode logic depends on how the script is
configured and who is allowed to access the executor UI. There is no built-in
system that automatically restricts SERVER mode to regular users.

If SERVER execution is exposed to players without proper permission checks,
they may be able to run server-side require(ID) calls.

This is extremely dangerous.

Important risks:
- Server-side require executes third-party code with full server authority
- Required modules may be unsafe, malicious, or later modified
- Any server-side abuse is attributed to the game, not the user

This means:
- Game owners can be moderated or permanently banned
- Group-owned games can also be moderated or banned
- Administrators are NOT exempt from moderation
- Trust level does not reduce risk

Even if:
- Only the owner uses SERVER mode
- Only admins use SERVER mode
- The game is private or for testing

Roblox moderation may still take action if unsafe code is executed.

Strong recommendations:
- Do NOT expose SERVER mode to public players
- Add permission checks before allowing SERVER execution
- Restrict executor access to trusted users only
- Review every required module manually
- Prefer CLIENT execution for public environments

By using this script, you fully accept responsibility for all consequences
resulting from server-side execution.

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
